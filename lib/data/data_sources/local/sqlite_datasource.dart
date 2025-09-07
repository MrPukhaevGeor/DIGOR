import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/database/db_helper.dart';
import '../../../core/utils/collation.dart' as col;
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
  final Set<String> _indexesEnsured = {};

  static const int _FUZZY_K = 3;
  static const int _FUZZY_MIN_INPUT = 4;
  static const int _FUZZY_PREFIX_THRESHOLD = 5;
  static const int _FUZZY_BUCKET_LIMIT = 5000;

  SQLiteDataSourceImpl(this._database);

  String _getTableNameForGetById(String from, String to) {
    return switch ((from, to)) {
      ('iron', _) => 'ir1_ru1_dict',
      (_, 'iron') => 'ru2_ir2_dict',
      ('dig', _) => 'dig_${to}_dict',
      (_, 'dig') => 'dig_${from}_dict',
      _ => '${from}_${to}_dict',
    };
  }

  String _getTableNameForSearch(String from, String to) {
    return switch ((from, to)) {
      ('iron', _) => 'ir1_ru1_dict',
      (_, 'iron') => 'ru2_ir2_dict',
      ('dig', _) => 'dig_${to}_dict',
      (_, 'dig') => '${from}_dig_dict',
      _ => '${from}_${to}_dict',
    };
  }

  String _getRefTableName(String from, String to) {
    return switch ((from, to)) {
      ('dig', _) => 'dig_${to}_refs',
      ('iron', _) => 'ir1_ru1_refs',
      (_, 'iron') => 'ru2_ir2_refs',
      _ => 'dig_${from}_refs',
    };
  }

  Future<void> _ensureIndexForTable(String table, String column) async {
    final key = '$table.$column';
    if (_indexesEnsured.contains(key)) return;
    try {
      await _database.execute('CREATE INDEX IF NOT EXISTS idx_${table}_${column} ON $table($column)');
    } catch (_) {/* ignore */}
    _indexesEnsured.add(key);
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
    final dictTable = _getTableNameForGetById(from, to);
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
        where: (from == 'dig' || from == 'iron' || to == 'iron') ? 'orig_id = ?' : 'ref_id = ?',
        whereArgs: [id],
      ),
    ]);

    final wordResult = results[0];
    if (wordResult.isEmpty) return null;

    final refsResult = results[1];
    final refs = {
      for (final row in refsResult)
        (row['ref_title']?.toString() ?? row['orig_id']?.toString() ?? row['ref_id'].toString()):
        (from == 'dig' || from == 'iron' || to == 'iron')
            ? row['ref_id'] as int
            : row['orig_id'] as int
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
    final table = _getTableNameForSearch(parts[0], parts[1]);
    final placeholders = List.filled(ids.length, '?').join(',');

    final result = await _database.rawQuery(
      'SELECT * FROM $table WHERE id IN ($placeholders)',
      ids,
    );
    return result.map(WordModel.fromJson).toList();
  }

  @override
  Future<List<WordModel>> search(String text, String fromLang, String toLang) async {
    String input = text.trim();
    if (input.isEmpty) return [];

    final bool isOsset = (fromLang == 'dig' || fromLang == 'iron');

    input = _normForOsset(input, isOsset);

    final isRuToDig = (fromLang == 'ru' && toLang == 'dig');
    const searchColumn = 'title';
    final table = _getTableNameForSearch(fromLang, toLang);

    final columns = <String>[
      'id',
      'title',
      'translation',
      if (fromLang != 'dig' && !(fromLang == 'ru' && toLang == 'iron') && !(fromLang == 'iron' && toLang == 'ru'))
        'trn_id',
    ];

    await _ensureIndexForTable(table, searchColumn);

    if (input.length == 1) {
      final patterns = _buildSingleLetterPatternsStrict(input);
      final where = List.filled(patterns.length, '$searchColumn LIKE ?').join(' OR ');
      final rows = await _database.query(
        table,
        columns: columns,
        where: where,
        whereArgs: patterns,
      );
      final mapped = rows.map((row) {
        if (isRuToDig && row.containsKey('trn_id') && row['trn_id'] != null) {
          final copy = Map<String, Object?>.from(row);
          copy['id'] = row['trn_id'];
          return WordModel.fromJson(copy);
        }
        return WordModel.fromJson(row);
      }).toList()
        ..sort((a, b) => col.compareByAlphabet(a.title, b.title, fromLang));
      return mapped;
    }

    final prefixPatterns = _buildPrefixPatterns(input, isOsset);
    final prefixWhere = List.filled(prefixPatterns.length, '$searchColumn LIKE ?').join(' OR ');
    final prefixRows = await _database.query(
      table,
      columns: columns,
      where: prefixWhere,
      whereArgs: prefixPatterns,
      limit: 200,
    );
    final prefix = prefixRows.map((row) {
      if (isRuToDig && row.containsKey('trn_id') && row['trn_id'] != null) {
        final copy = Map<String, Object?>.from(row);
        copy['id'] = row['trn_id'];
        return WordModel.fromJson(copy);
      }
      return WordModel.fromJson(row);
    }).toList();

    final inputLower = _norm(input);
    final exacts = prefix.where((w) => _norm(w.title) == inputLower).toList();
    if (exacts.isNotEmpty) {
      exacts.sort((a, b) => col.compareByAlphabet(a.title, b.title, fromLang));
      return exacts;
    }

    if (prefix.length >= _FUZZY_PREFIX_THRESHOLD || input.length < _FUZZY_MIN_INPUT) {
      prefix.sort((a, b) => col.compareByAlphabet(a.title, b.title, fromLang));
      return prefix;
    }

    final firstLetterPatterns = _buildFirstLetterBucketPatterns(input, isOsset);
    final firstWhere = List.filled(firstLetterPatterns.length, '$searchColumn LIKE ?').join(' OR ');
    final fuzzRows = await _database.query(
      table,
      columns: columns,
      where: firstWhere,
      whereArgs: firstLetterPatterns,
      limit: _FUZZY_BUCKET_LIMIT,
    );
    final fuzzCandidates = fuzzRows.map((row) {
      if (isRuToDig && row.containsKey('trn_id') && row['trn_id'] != null) {
        final copy = Map<String, Object?>.from(row);
        copy['id'] = row['trn_id'];
        return WordModel.fromJson(copy);
      }
      return WordModel.fromJson(row);
    }).toList();

    final fuzzy = _rankFuzzyKLocal(
      candidates: fuzzCandidates,
      input: input,
      alpha: fromLang,
      k: _FUZZY_K,
    );

    prefix.sort((a, b) => col.compareByAlphabet(a.title, b.title, fromLang));
    final seen = <int>{};
    final merged = <WordModel>[];
    for (final w in prefix) {
      if (seen.add(w.id)) merged.add(w);
    }
    for (final w in fuzzy) {
      if (seen.add(w.id)) merged.add(w);
    }
    return merged;
  }

  String _norm(String s) => s.toLowerCase().replaceAll('æ', 'ӕ').replaceAll('Æ', 'Ӕ').replaceAll('a', 'а');

  String _normForOsset(String s, bool isOsset) {
    s = s.replaceAll('æ', 'ӕ').replaceAll('Æ', 'Ӕ');
    if (isOsset) s = s.replaceAll('a', 'а').replaceAll('A', 'А');
    return s;
  }

  List<String> _buildSingleLetterPatternsStrict(String input) {
    final ch = input[0];
    final up = ch.toUpperCase();
    return ['$ch%', '$up%'];
  }

  List<String> _buildPrefixPatterns(String input, bool isOsset) {
    final first = input[0];
    final rest = input.substring(1);
    final upFirst = first.toUpperCase();
    final upRest = rest.isEmpty ? '' : '${rest[0].toUpperCase()}${rest.substring(1)}';

    final patterns = <String>['${first}${rest}%', '${upFirst}${upRest}%'];

    if (isOsset && (first == 'а' || first == 'А' || first == 'ӕ' || first == 'Ӕ')) {
      final alt = (first == 'а' || first == 'А') ? 'ӕ' : 'а';
      final altUp = alt.toUpperCase();
      patterns.add('${alt}${rest}%');
      patterns.add('${altUp}${upRest}%');
    }
    return patterns;
  }

  List<String> _buildFirstLetterBucketPatterns(String input, bool isOsset) {
    final ch = input[0];
    final up = ch.toUpperCase();
    return ['$ch%', '$up%'];
  }

  String _normED(String s) =>
      s.toLowerCase()
          .replaceAll('æ', 'ӕ')
          .replaceAll('Æ', 'Ӕ')
          .replaceAll('a', 'а')
          .replaceAll('ӕ', 'а');

  int _levAtMostK(String a, String b, int k) {
    a = _normED(a);
    b = _normED(b);
    final la = a.length, lb = b.length;
    if ((la - lb).abs() > 1) return k + 1;

    final maxVal = k + 1;
    List<int> prev = List<int>.generate(lb + 1, (j) => j);
    List<int> curr = List<int>.filled(lb + 1, 0);

    for (int i = 1; i <= la; i++) {
      curr[0] = i;
      final from = (i - k) > 1 ? (i - k) : 1;
      final to = (i + k) < lb ? (i + k) : lb;

      for (int j = 1; j < from; j++) {
        curr[j] = maxVal;
      }
      for (int j = from; j <= to; j++) {
        final cost = (a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1)) ? 0 : 1;
        final del = prev[j] + 1;
        final ins = curr[j - 1] + 1;
        final sub = prev[j - 1] + cost;
        int v = del < ins ? del : ins;
        if (sub < v) v = sub;
        curr[j] = v;
      }
      for (int j = to + 1; j <= lb; j++) {
        curr[j] = maxVal;
      }
      final tmp = prev;
      prev = curr;
      curr = tmp;

      int rowMin = maxVal;
      for (int j = 0; j <= lb; j++) {
        if (prev[j] < rowMin) rowMin = prev[j];
      }
      if (rowMin > k) return k + 1;
    }
    return prev[lb];
  }

  List<WordModel> _rankFuzzyKLocal({
    required List<WordModel> candidates,
    required String input,
    required String alpha,
    required int k,
  }) {
    final inp = _normED(input);
    final hits = <WordModel, int>{};
    for (final w in candidates) {
      final dlen = (_normED(w.title).length - inp.length).abs();
      if (dlen > 1) continue;

      final d = _levAtMostK(w.title, inp, k);
      if (d <= k) hits[w] = d;
    }
    final list = hits.entries.toList()
      ..sort((a, b) {
        final c = a.value.compareTo(b.value);
        if (c != 0) return c;
        return col.compareByAlphabet(a.key.title, b.key.title, alpha);
      });
    return [for (final e in list) e.key];
  }
}

final localApiClientProvider = Provider<SQLiteDataSource>((ref) {
  final db = ref.watch(databaseProvider).maybeWhen(
    data: (db) => db,
    orElse: () => throw Exception('Database is not initialized'),
  );
  return SQLiteDataSourceImpl(db);
});