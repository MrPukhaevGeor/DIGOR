import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

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

  SQLiteDataSourceImpl(this._database);

  String _getTableName(String from, String to) {
    return '${from}_${to}_dict';
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

    final dictTable = from == 'dig' ? 'dig_${to}_dict' : '${from}_dig_dict';

    final result = await _database.query(
      dictTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;

    final wordJson = Map<String, dynamic>.from(result.first);

    String refTable;
    if (from == 'dig') {
      refTable = 'dig_${to}_refs';
    } else {
      refTable = 'dig_${from}_refs';
    }
    List<Map<String, dynamic>> refsResult = [];
    if (from == 'dig') {
      refsResult = await _database.query(
        refTable,
        where: 'orig_id = ?',
        whereArgs: [id],
      );
    } else if (to == 'dig') {
      refsResult = await _database.query(
        refTable,
        where: 'ref_id = ?',
        whereArgs: [id],
      );
    }

    final Map<String, int> refs = {
      for (var row in refsResult)
        (row['ref_title']?.toString() ?? row['orig_id']?.toString() ?? row['ref_id'].toString()):
            (from == 'dig') ? row['ref_id'] as int : row['orig_id'] as int
    };

    final word = WordModel.fromJson({
      ...wordJson,
      'refs': refs,
    });

    return word;
  }

  @override
  Future<List<WordModel>> searchByIds(List<int> ids, String lang) async {
    final parts = lang.split("=");
    if (parts.length != 2 || ids.isEmpty) return [];
    final table = _getTableName(parts[0], parts[1]);
    final placeholders = List.filled(ids.length, '?').join(',');
    final result = await _database.rawQuery(
      'SELECT * FROM $table WHERE id IN ($placeholders)',
      ids,
    );
    return result.map((e) => WordModel.fromJson(e)).toList();
  }

  @override
  Future<List<WordModel>> search(String text, String fromLang, String toLang) async {
    final table = _getTableName(fromLang, toLang);

    try {
      final result = await _database.query(
        table,
        where: 'title LIKE ? OR translation LIKE ?',
        whereArgs: ['%$text%', '%$text%'],
        limit: 50,
      );
      return result.map((e) => WordModel.fromJson(e)).toList();
    } catch (e) {
      final result = await _database.query(
        table,
        where: 'title LIKE ?',
        whereArgs: ['%$text%'],
        limit: 50,
      );
      return result.map((e) => WordModel.fromJson(e)).toList();
    }
  }
}

final localApiClientProvider = Provider<SQLiteDataSource>((ref) {
  final db = ref.watch(databaseProvider).maybeWhen(
        data: (db) => db,
        orElse: () => throw Exception('Database is not initialized'),
      );
  return SQLiteDataSourceImpl(db);
});
