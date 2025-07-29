import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import '../../../core/database/db_helper.dart';
import '../../../domain/models/word_model.dart';

abstract interface class SQLiteDataSource {
  Future<WordModel?> searchById(int id, String lang);
  Future<List<WordModel>> searchByIds(List<int> ids, String lang);
  Future<List<WordModel>> search(String text, String fromLang, String toLang);
  Future<void> addReport(Map<String, dynamic> body);
}

final class SQLiteDataSourceImpl implements SQLiteDataSource {
  final Database _database;
  final Map<String, List<WordModel>> _cache = {};

  SQLiteDataSourceImpl(this._database);

  String _getTableName(String from, String to) {
    return switch ((from, to)) {
      ('iron', _) => 'ir2_ru2_dict',
      (_, 'iron') => 'ru2_ir2_dict',
      _ => '${from}_${to}_dict',
    };
  }

  String _getRefTableName(String from, String to) {
    return switch ((from, to)) {
      ('dig', _) => 'dig_${to}_refs',
      ('iron', _) || (_, 'iron') => 'ru2_ir2_refs',
      _ => 'dig_${from}_refs',
    };
  }

  @override
  Future<void> addReport(Map<String, dynamic> body) async {
    await _database.insert('reports', body);
  }

  @override
  Future<WordModel?> searchById(int id, String lang) async {
    final parts = lang.split('=');
    if (parts.length != 2) return null;

    final from = parts[0];
    final to = parts[1];
    final dictTable = _getTableName(from, to);
    final refTable = _getRefTableName(from, to);

    final results = await Future.wait([
      _database.query(
        dictTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      ),
      _database.query(
        refTable,
        where: from == 'dig' || from == 'iron' || to == 'iron' ? 'orig_id = ?' : 'ref_id = ?',
        whereArgs: [id],
      ),
    ]);

    final wordResult = results[0];
    if (wordResult.isEmpty) return null;

    final refsResult = results[1];
    final refs = {
      for (var row in refsResult)
        (row['ref_title']?.toString() ?? row['orig_id']?.toString() ?? row['ref_id'].toString()):
            (from == 'dig' || from == 'iron' || to == 'iron') ? row['ref_id'] as int : row['orig_id'] as int
    };

    return WordModel.fromJson({
      ...wordResult.first,
      'refs': refs,
    });
  }

  @override
  Future<List<WordModel>> searchByIds(List<int> ids, String lang) async {
    if (ids.isEmpty) return [];

    final parts = lang.split("=");
    if (parts.length != 2) return [];

    final table = _getTableName(parts[0], parts[1]);
    final placeholders = List.filled(ids.length, '?').join(',');

    final result = await _database.rawQuery(
      'SELECT * FROM $table WHERE id IN ($placeholders)',
      ids,
    );

    return result.map(WordModel.fromJson).toList();
  }

  @override
  Future<List<WordModel>> search(String text, String fromLang, String toLang) async {
    final input = text.toLowerCase();
    final tableKey = '${fromLang}_$toLang';

    // Кешируем загруженные данные
    if (!_cache.containsKey(tableKey)) {
      final table = _getTableName(fromLang, toLang);
      final candidatesRaw = await _database.query(
        table,
        columns: [
          'id',
          'title',
          'translation',
          if (fromLang != 'dig' && !(fromLang == 'ru' && toLang == 'iron')) 'trn_id'
        ],
      );
      _cache[tableKey] = candidatesRaw.map(WordModel.fromJson).toList();
    }

    // Используем compute для тяжелых вычислений
    return await compute(
      _performSearch,
      _SearchData(
        candidates: _cache[tableKey]!,
        input: input,
      ),
    );
  }

  static List<WordModel> _performSearch(_SearchData data) {
    final scored = <WordModel, double>{};
    final input = data.input;
    final candidates = data.candidates;

    for (final word in candidates) {
      final title = word.title.toLowerCase();
      final translation = word.translate.toLowerCase();

      // Быстрая проверка точного совпадения
      if (title == input) {
        scored[word] = 1.0;
        continue;
      }

      if (translation == input) {
        scored[word] = 0.9;
        continue;
      }

      // Fuzzy-поиск только если нет точного совпадения
      final scoreTitle = ratio(title, input) / 100;
      final scoreTrans = ratio(translation, input) / 100;

      final startsBonus = title.startsWith(input) ? 0.3 : 0.0;
      final lengthBonus = (12 - title.length).clamp(0, 6) * 0.05;

      final weighted = (scoreTitle * 3 + scoreTrans + startsBonus + lengthBonus) / 4.0;
      if (weighted >= 0.4) {
        scored[word] = weighted;
      }
    }

    // Сортировка результатов
    final sorted = scored.entries.toList()
      ..sort((a, b) {
        final cmp = b.value.compareTo(a.value);
        if (cmp != 0) return cmp;
        final lenCmp = a.key.title.length.compareTo(b.key.title.length);
        if (lenCmp != 0) return lenCmp;
        return a.key.title.compareTo(b.key.title);
      });

    return sorted.map((e) => e.key).toList();
  }
}

class _SearchData {
  final List<WordModel> candidates;
  final String input;

  _SearchData({
    required this.candidates,
    required this.input,
  });
}

final localApiClientProvider = Provider<SQLiteDataSource>((ref) {
  final db = ref.watch(databaseProvider).maybeWhen(
        data: (db) => db,
        orElse: () => throw Exception('Database is not initialized'),
      );
  return SQLiteDataSourceImpl(db);
});
