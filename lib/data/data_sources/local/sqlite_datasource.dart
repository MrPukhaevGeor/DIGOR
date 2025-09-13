import 'package:flutter/foundation.dart';
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
  final Set<String> _indexesEnsured = {};
  final Map<String, bool> _tableHasTitleNorm = {};

  static const int _SORT_IN_ISOLATE_THRESHOLD = 2000;

  static const int _FUZZY_BUCKET_LIMIT = 1200;

  static const int _MAX_PREFIX_VARIANTS = 48;

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
      await _database
          .execute('CREATE INDEX IF NOT EXISTS idx_${table}_${column} ON $table($column)');
    } catch (_) {/* ignore */}
    _indexesEnsured.add(key);
  }

  Future<bool> _hasColumn(String table, String column) async {
    final cacheKey = '$table::$column';
    final cached = _tableHasTitleNorm[cacheKey];
    if (cached != null) return cached;
    try {
      final rows = await _database.rawQuery('PRAGMA table_info($table)');
      final ok = rows.any((r) => (r['name'] as String?) == column);
      _tableHasTitleNorm[cacheKey] = ok;
      return ok;
    } catch (_) {
      _tableHasTitleNorm[cacheKey] = false;
      return false;
    }
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
    final refTable  = _getRefTableName(from, to);

    final wordRows = await _database.query(
      dictTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (wordRows.isEmpty) return null;

    Map<String, int> refs = {};
    try {
      final refRows = await _database.query(
        refTable,
        where: (from == 'dig' || from == 'iron' || to == 'iron')
            ? 'orig_id = ?'
            : 'ref_id = ?',
        whereArgs: [id],
      );
      refs = {
        for (final r in refRows)
          (r['ref_title']?.toString()
              ?? r['orig_id']?.toString()
              ?? r['ref_id'].toString()):
          (from == 'dig' || from == 'iron' || to == 'iron')
              ? r['ref_id'] as int
              : r['orig_id'] as int
      };
    } catch (_) {
    }

    return WordModel.fromJson({
      ...wordRows.first,
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

    final table = _getTableNameForSearch(fromLang, toLang);

    final columns = <String>[
      'id',
      'title',
      'translation',
      if (fromLang != 'dig' &&
          !(fromLang == 'ru' && toLang == 'iron') &&
          !(fromLang == 'iron' && toLang == 'ru'))
        'trn_id',
    ];

    final hasNorm = await _hasColumn(table, 'title_norm');
    if (hasNorm) {
      await _ensureIndexForTable(table, 'title_norm');
    } else {
      await _ensureIndexForTable(table, 'title');
    }

    if (input.length == 1) {
      final ch = input[0];
      if (hasNorm) {
        final lower = col.normalizeAlpha(ch, fromLang).toLowerCase();
        final rows = await _queryByRanges(
          table: table,
          columns: columns,
          ranges: [('$lower', '$lower\uFFFF')],
          useNorm: true,
        );
        final list = rows.map((r) => _mapRow(r, isRuToDig)).toList();
        return _sortPrefixMaybeInIsolate(list, fromLang, input);
      } else {
        final patterns = <String>{'$ch%', '${ch.toUpperCase()}%'} .toList(growable: false);
        final rows = await _database.query(
          table,
          columns: columns,
          where: 'title LIKE ? OR title LIKE ?',
          whereArgs: patterns,
        );
        final list = rows.map((r) => _mapRow(r, isRuToDig)).toList();
        return _sortPrefixMaybeInIsolate(list, fromLang, input);
      }
    }

    List<WordModel> prefix;
    if (hasNorm) {
      final variants = _expandAeVariants(input, _MAX_PREFIX_VARIANTS, alpha: fromLang)
          .map((v) => col.normalizeAlpha(v, fromLang).toLowerCase())
          .toSet()
          .toList(growable: false);

      final ranges = <(String, String)>[
        for (final v in variants) (v, '$v\uFFFF'),
      ];

      final rows = await _queryByRanges(
        table: table,
        columns: columns,
        ranges: ranges,
        useNorm: true,
      );
      prefix = rows.map((r) => _mapRow(r, isRuToDig)).toList();
    } else {
      final patterns = _buildPrefixPatternsRelaxed(input, fromLang);
      final where = List.filled(patterns.length, 'title LIKE ?').join(' OR ');
      final rows = await _database.query(
        table,
        columns: columns,
        where: where,
        whereArgs: patterns,
      );
      prefix = rows.map((r) => _mapRow(r, isRuToDig)).toList();
    }

    if (prefix.isNotEmpty) {
      return _sortPrefixMaybeInIsolate(prefix, fromLang, input);
    }

    if (fromLang == 'dig' || fromLang == 'iron') {
      final correctedPrefix = await _tryOssetEarlyPrefix(
        input: input,
        fromLang: fromLang,
        table: table,
        columns: columns,
        useNorm: hasNorm,
        isRuToDig: isRuToDig,
      );
      if (correctedPrefix.isNotEmpty) {
        return _sortPrefixMaybeInIsolate(correctedPrefix, fromLang, input);
      }
    }

    final bucket2 = _buildTwoLetterBucketPatterns(input, fromLang);
    final where2 = List.filled(bucket2.length, 'title LIKE ?').join(' OR ');
    final rows2 = await _database.query(
      table,
      columns: columns,
      where: where2,
      whereArgs: bucket2,
      limit: _FUZZY_BUCKET_LIMIT,
    );
    final cand2 = rows2.map((r) => _mapRow(r, isRuToDig)).toList();
    final k = _fuzzyK(input.length);
    var fuzzy = _rankFuzzyKLocal(
      candidates: cand2,
      input: input,
      alpha: fromLang,
      k: k,
    );

    int bestDist = 999;
    if (fuzzy.isNotEmpty) {
      bestDist = _levAtMostK(fuzzy.first.title, input, 6);
    }

    if (fuzzy.isEmpty || bestDist > 1) {
      final bucket1 = _buildFirstLetterBucketPatternsStrict(input);
      final where1 = List.filled(bucket1.length, 'title LIKE ?').join(' OR ');
      final rows1 = await _database.query(
        table,
        columns: columns,
        where: where1,
        whereArgs: bucket1,
        limit: _FUZZY_BUCKET_LIMIT,
      );
      final map = <int, WordModel>{};
      for (final w in cand2) map[w.id] = w;
      for (final w in rows1.map((r) => _mapRow(r, isRuToDig))) map[w.id] = w;

      fuzzy = _rankFuzzyKLocal(
        candidates: map.values.toList(growable: false),
        input: input,
        alpha: fromLang,
        k: k,
      );
    }

    if (fuzzy.isEmpty) return [];

    final anchor = fuzzy.first.title;

    if (hasNorm) {
      final variants = _expandAeVariants(anchor, _MAX_PREFIX_VARIANTS, alpha: fromLang)
          .map((v) => col.normalizeAlpha(v, fromLang).toLowerCase())
          .toSet()
          .toList(growable: false);

      final ranges = <(String, String)>[
        for (final v in variants) (v, '$v\uFFFF'),
      ];

      final rows = await _queryByRanges(
        table: table,
        columns: columns,
        ranges: ranges,
        useNorm: true,
      );
      final correctedPrefix = rows.map((r) => _mapRow(r, isRuToDig)).toList();
      return _sortPrefixMaybeInIsolate(correctedPrefix, fromLang, input);
    } else {
      final patterns = _buildPrefixPatternsRelaxed(anchor, fromLang);
      final where = List.filled(patterns.length, 'title LIKE ?').join(' OR ');
      final rows = await _database.query(
        table,
        columns: columns,
        where: where,
        whereArgs: patterns,
      );
      final correctedPrefix = rows.map((r) => _mapRow(r, isRuToDig)).toList();
      return _sortPrefixMaybeInIsolate(correctedPrefix, fromLang, input);
    }
  }

  Future<List<WordModel>> _tryOssetEarlyPrefix({
    required String input,
    required String fromLang,
    required String table,
    required List<String> columns,
    required bool useNorm,
    required bool isRuToDig,
  }) async {
    bool _isGeminatable(String ch) {
      const g = {
        'ц','т','с','н','л','к','п','м','р','б','д','ж','з','ч','ш','ф','г','х'
      };
      return g.contains(ch.toLowerCase());
    }

    List<String> _vowelAlts(String ch) {
      switch (ch) {
        case 'и': return ['е'];
        case 'е': return ['и'];
        case 'И': return ['Е'];
        case 'Е': return ['И'];
      }
      return const [];
    }

    final vset = <String>{};
    final vbound = input.length < 3 ? input.length : 3;
    for (int i = 0; i < vbound; i++) {
      final alts = _vowelAlts(input[i]);
      for (final a in alts) {
        vset.add(input.substring(0, i) + a + input.substring(i + 1));
      }
    }

    final gset = <String>{};
    final gbound = input.length < 5 ? input.length : 5;
    for (int i = 0; i < gbound; i++) {
      final ch = input[i];
      if (i + 1 < input.length && input[i + 1] == ch) {
        gset.add(input.substring(0, i) + ch + input.substring(i + 2));
      } else if (_isGeminatable(ch)) {
        gset.add(input.substring(0, i) + ch + ch + input.substring(i + 1));
      }
    }

    final variants = <String>{...vset, ...gset};
    final baseForCombo = List<String>.from(vset);
    for (final s in baseForCombo) {
      final n = s.length < 5 ? s.length : 5;
      for (int i = 0; i < n; i++) {
        final ch = s[i];
        if (i + 1 < s.length && s[i + 1] == ch) {
          variants.add(s.substring(0, i) + ch + s.substring(i + 2));
        } else if (_isGeminatable(ch)) {
          variants.add(s.substring(0, i) + ch + ch + s.substring(i + 1));
        }
      }
      if (variants.length >= 24) break;
    }

    if (variants.isEmpty) return const [];

    if (useNorm) {
      final ranges = <(String, String)>[
        for (final v in variants)
          (col.normalizeAlpha(v, fromLang).toLowerCase(),
          col.normalizeAlpha(v, fromLang).toLowerCase() + '\uFFFF'),
      ];
      final rows = await _queryByRanges(
        table: table,
        columns: columns,
        ranges: ranges.take(24).toList(),
        useNorm: true,
      );
      return rows.map((r) => _mapRow(r, isRuToDig)).toList();
    } else {
      final patterns = <String>{
        for (final v in variants.take(24))
          ...{'$v%', '${v.isNotEmpty ? v[0].toUpperCase() : ''}${v.length > 1 ? v.substring(1) : ''}%'}
      }.toList(growable: false);
      final where = List.filled(patterns.length, 'title LIKE ?').join(' OR ');
      final rows = await _database.query(
        table,
        columns: columns,
        where: where,
        whereArgs: patterns,
      );
      return rows.map((r) => _mapRow(r, isRuToDig)).toList();
    }
  }

  Future<List<Map<String, Object?>>> _queryByRanges({
    required String table,
    required List<String> columns,
    required List<(String, String)> ranges,
    required bool useNorm,
  }) async {
    final colName = useNorm ? 'title_norm' : 'title';
    final whereParts = <String>[];
    final args = <Object?>[];
    for (final (l, u) in ranges) {
      whereParts.add('($colName >= ? AND $colName < ?)');
      args..add(l)..add(u);
    }
    final where = whereParts.join(' OR ');
    return _database.query(table, columns: columns, where: where, whereArgs: args);
  }

  Future<List<WordModel>> _sortPrefixMaybeInIsolate(
      List<WordModel> list, String alpha, String input) async {
    if (list.length <= _SORT_IN_ISOLATE_THRESHOLD) {
      return _sortPrefixSync(list, alpha, input);
    }
    final titles = List<String>.generate(list.length, (i) => list[i].title, growable: false);
    final order = await compute<_SortPrefixArgs, List<int>>(
      _sortIndicesByPrefix, _SortPrefixArgs(titles, alpha, input),
    );
    return [for (final i in order) list[i]];
  }

  List<WordModel> _sortPrefixSync(List<WordModel> list, String alpha, String input) {
    final inp = _lowerNoConflate(input);
    int score(String title) {
      final t = _lowerNoConflate(title);
      final n = inp.length <= t.length ? inp.length : t.length;
      int s = 0;
      for (int i = 0; i < n; i++) {
        if (t[i] != inp[i]) s++;
      }
      return s;
    }

    list.sort((a, b) {
      final sa = score(a.title);
      final sb = score(b.title);
      if (sa != sb) return sa - sb;
      return col.compareByAlphabet(a.title, b.title, alpha);
    });
    return list;
  }

  String _normForOsset(String s, bool isOsset) {
    s = s.replaceAll('æ', 'ӕ').replaceAll('Æ', 'Ӕ');
    if (isOsset) s = s.replaceAll('a', 'а').replaceAll('A', 'А');
    return s;
  }

  String _normED(String s) => s
      .toLowerCase()
      .replaceAll('æ', 'ӕ')
      .replaceAll('Æ', 'Ӕ')
      .replaceAll('a', 'а')
      .replaceAll('ӕ', 'а');

  String _lowerNoConflate(String s) =>
      s.toLowerCase().replaceAll('æ', 'ӕ').replaceAll('Æ', 'Ӕ');

  WordModel _mapRow(Map<String, Object?> row, bool isRuToDig) {
    if (isRuToDig && row.containsKey('trn_id') && row['trn_id'] != null) {
      final copy = Map<String, Object?>.from(row);
      copy['id'] = row['trn_id'];
      return WordModel.fromJson(copy);
    }
    return WordModel.fromJson(row);
  }

  List<String> _expandAeVariants(String s, int maxVariants, {required String alpha}) {
    final osset = (alpha == 'dig' || alpha == 'iron');
    if (!osset) return [s];

    if (!s.contains('а') && !s.contains('А') && !s.contains('ӕ') && !s.contains('Ӕ')) {
      return [s];
    }

    List<String> seeds = [''];
    for (int i = 0; i < s.length; i++) {
      final ch = s[i];

      List<String> alts;
      final isA = (ch == 'а' || ch == 'А');
      final isAe = (ch == 'ӕ' || ch == 'Ӕ');
      if (isA) {
        alts = [_toCase(ch, 'а'), _toCase(ch, 'ӕ')];
      } else if (isAe) {
        alts = [_toCase(ch, 'ӕ')];
      } else {
        alts = [ch];
      }

      final next = <String>[];
      for (final seed in seeds) {
        for (final a in alts) {
          next.add('$seed$a');
          if (next.length >= maxVariants) break;
        }
        if (next.length >= maxVariants) break;
      }
      seeds = next;
      if (seeds.length >= maxVariants) break;
    }

    return seeds.isEmpty ? [s] : seeds;
  }

  List<String> _buildPrefixPatternsRelaxed(String input, String alpha) {
    final variants = _expandAeVariants(input, _MAX_PREFIX_VARIANTS, alpha: alpha);
    final set = <String>{};
    for (final v in variants) {
      set.add('$v%');
      if (v.isNotEmpty) {
        final up = v[0].toUpperCase() + (v.length > 1 ? v.substring(1) : '');
        set.add('$up%');
      }
    }
    return set.toList(growable: false);
  }

  List<String> _buildTwoLetterBucketPatterns(String input, String alpha) {
    final s = input;
    final int n = s.length >= 2 ? 2 : 1;

    List<String> seeds = [''];
    for (int i = 0; i < n; i++) {
      final ch = s[i];
      List<String> alts;

      if (alpha == 'ru') {
        if (ch == 'а' || ch == 'А' || ch == 'о' || ch == 'О') {
          alts = [_toCase(ch, 'а'), _toCase(ch, 'о')];
        } else if (ch == 'е' || ch == 'Е' || ch == 'ё' || ch == 'Ё') {
          alts = [_toCase(ch, 'е'), _toCase(ch, 'ё')];
        } else {
          alts = [ch];
        }
      } else if (alpha == 'iron' || alpha == 'dig') {
        if (ch == 'а' || ch == 'А' || ch == 'ӕ' || ch == 'Ӕ') {
          alts = [_toCase(ch, 'а'), _toCase(ch, 'ӕ')];
        } else if (ch == 'и' || ch == 'И' || ch == 'е' || ch == 'Е') {
          alts = [_toCase(ch, 'и'), _toCase(ch, 'е')];
        } else {
          alts = [ch];
        }
      } else {
        alts = [ch];
      }

      final next = <String>[];
      for (final seed in seeds) {
        for (final a in alts) {
          next.add('$seed$a');
        }
      }
      seeds = next;
    }

    final patterns = <String>{};
    for (final p in seeds) {
      patterns.add('$p%');
      if (p.isNotEmpty) {
        final up = p[0].toUpperCase() + (p.length > 1 ? p.substring(1) : '');
        patterns.add('$up%');
      }
    }
    return patterns.toList(growable: false);
  }

  List<String> _buildFirstLetterBucketPatternsStrict(String input) {
    final lower = input[0].toLowerCase();
    final upper = input[0].toUpperCase();
    return {'$lower%', '$upper%'}.toList(growable: false);
  }

  int _fuzzyK(int inputLen) {
    if (inputLen >= 6) return 3;
    if (inputLen >= 4) return 2;
    return 1;
  }

  int _levAtMostK(String a, String b, int k) {
    a = _normED(a);
    b = _normED(b);
    final la = a.length, lb = b.length;
    if ((la - lb).abs() > 3) return k + 1;

    final maxVal = k + 1;
    List<int> prev = List<int>.generate(lb + 1, (j) => j);
    List<int> curr = List<int>.filled(lb + 1, 0);

    for (int i = 1; i <= la; i++) {
      curr[0] = i;
      final from = (i - k) > 1 ? (i - k) : 1;
      final to = (i + k) < lb ? (i + k) : lb;

      for (int j = 1; j < from; j++) curr[j] = maxVal;
      for (int j = from; j <= to; j++) {
        final cost = (a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1)) ? 0 : 1;
        final del = prev[j] + 1;
        final ins = curr[j - 1] + 1;
        final sub = prev[j - 1] + cost;
        int v = del < ins ? del : ins;
        if (sub < v) v = sub;
        curr[j] = v;
      }
      for (int j = to + 1; j <= lb; j++) curr[j] = maxVal;

      final tmp = prev; prev = curr; curr = tmp;

      int rowMin = maxVal;
      for (int j = 0; j <= lb; j++) if (prev[j] < rowMin) rowMin = prev[j];
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
    final scored = <(int, WordModel)>[];

    for (final w in candidates) {
      final titleN = _normED(w.title);
      final dlen = (titleN.length - inp.length).abs();
      if (dlen > 3) continue;

      final d = _levAtMostK(titleN, inp, k);
      if (d <= k) scored.add((d, w));
    }

    scored.sort((a, b) {
      final c = a.$1.compareTo(b.$1);
      if (c != 0) return c;
      return col.compareByAlphabet(a.$2.title, b.$2.title, alpha);
    });

    return [for (final e in scored) e.$2];
  }

  String _toCase(String src, String targetLower) {
    final isUpper = src == src.toUpperCase();
    final t = targetLower;
    return isUpper ? t.toUpperCase() : t;
  }
}

final localApiClientProvider = Provider<SQLiteDataSource>((ref) {
  final db = ref.watch(databaseProvider).maybeWhen(
    data: (db) => db,
    orElse: () => throw Exception('Database is not initialized'),
  );
  return SQLiteDataSourceImpl(db);
});

class _SortPrefixArgs {
  final List<String> titles;
  final String alpha;
  final String input;
  const _SortPrefixArgs(this.titles, this.alpha, this.input);
}

String _lowerNoConflate(String s) =>
    s.toLowerCase().replaceAll('æ', 'ӕ').replaceAll('Æ', 'Ӕ');

List<int> _sortIndicesByPrefix(_SortPrefixArgs a) {
  final inp = _lowerNoConflate(a.input);
  int score(String title) {
    final t = _lowerNoConflate(title);
    final n = inp.length <= t.length ? inp.length : t.length;
    int s = 0;
    for (int i = 0; i < n; i++) {
      if (t[i] != inp[i]) s++;
    }
    return s;
  }

  final idx = List<int>.generate(a.titles.length, (i) => i);
  idx.sort((i, j) {
    final si = score(a.titles[i]);
    final sj = score(a.titles[j]);
    if (si != sj) return si - sj;
    return col.compareByAlphabet(a.titles[i], a.titles[j], a.alpha);
  });
  return idx;
}