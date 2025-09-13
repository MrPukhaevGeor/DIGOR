import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  static const String dbFileName = "exported_digor.db";

  static const int _requiredUserVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String dbPath = join(documentsDirectory.path, dbFileName);

    if (!await File(dbPath).exists()) {
      final ByteData data = await rootBundle.load("assets/db/$dbFileName");
      final List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    _database = await openDatabase(
      dbPath,
      readOnly: false,
      onConfigure: (db) async {
        await _configurePragmas(db);
      },
      onOpen: (db) async {
        final currentUv = await _getUserVersion(db);
        if (currentUv < _requiredUserVersion) {
          final changed = await _migrateTitleNormAndIndexes(db);
          if (changed) {
            await _setUserVersion(db, _requiredUserVersion);
          }
        }
      },
    );
    return _database!;
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  static Future<void> _configurePragmas(Database db) async {
    await _pragmaSet(db, 'journal_mode', 'WAL');
    await _pragmaSet(db, 'synchronous', 'NORMAL');
    await _pragmaSet(db, 'temp_store', 'MEMORY');
    try {
      await _pragmaSet(db, 'mmap_size', '268435456');
    } catch (_) {}
  }

  static Future<void> _pragmaSet(Database db, String name, String value) async {
    await db.rawQuery('PRAGMA $name=$value');
  }

  static Future<int> _getUserVersion(Database db) async {
    final res = await db.rawQuery('PRAGMA user_version');
    if (res.isEmpty) return 0;
    final m = res.first;
    final dynamic v = m.values.isNotEmpty ? m.values.first : 0;
    return (v is int) ? v : (int.tryParse('$v') ?? 0);
  }

  static Future<void> _setUserVersion(Database db, int v) async {
    await db.rawQuery('PRAGMA user_version=$v');
  }

  static Future<bool> _migrateTitleNormAndIndexes(Database db) async {
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE '%dict';",
    );
    if (tables.isEmpty) return false;

    bool migratedAny = false;

    for (final row in tables) {
      final String table = (row['name'] as String);
      if (table.startsWith('sqlite_')) continue;

      await db.transaction((txn) async {
        final bool hasTitle = await _hasColumn(txn, table, 'title');
        if (!hasTitle) return;

        final bool hasNorm = await _hasColumn(txn, table, 'title_norm');
        final String alpha = _inferAlphaFromTable(table);

        final String normExpr = (alpha == 'iron' || alpha == 'dig' || alpha == 'ru')
            ? "LOWER(REPLACE(REPLACE(REPLACE(REPLACE(title,'æ','ӕ'),'Æ','Ӕ'),'a','а'),'A','А'))"
            : "LOWER(title)";

        final batch = txn.batch();

        if (!hasNorm) {
          migratedAny = true;
          batch.execute('ALTER TABLE $table ADD COLUMN title_norm TEXT;');
          batch.execute('UPDATE $table SET title_norm = $normExpr;');
        } else {
          batch.execute('UPDATE $table SET title_norm = $normExpr WHERE title_norm IS NULL;');
        }

        batch.execute('CREATE INDEX IF NOT EXISTS idx_${table}_title_norm ON $table(title_norm);');
        await batch.commit(noResult: true);
      });
    }

    if (migratedAny) {
      await db.execute('ANALYZE;');
    }

    return migratedAny;
  }

  static String _inferAlphaFromTable(String table) {
    if (table == 'ir1_ru1_dict') return 'iron';
    if (table == 'ru2_ir2_dict') return 'ru';
    if (table.startsWith('dig_') && table.endsWith('_dict')) return 'dig';
    if (table.endsWith('_dig_dict')) {
      final from = table.substring(0, table.length - '_dig_dict'.length);
      return _normalizeAlphaKey(from);
    }
    final parts = table.split('_');
    if (parts.length >= 3) return _normalizeAlphaKey(parts[0]);
    return 'ru';
  }

  static String _normalizeAlphaKey(String s) {
    if (s.startsWith('ru')) return 'ru';
    if (s.startsWith('ir') || s.startsWith('iron')) return 'iron';
    if (s.startsWith('dig')) return 'dig';
    if (s.startsWith('en')) return 'en';
    if (s.startsWith('turk')) return 'turk';
    return s;
  }

  static Future<bool> _hasColumn(DatabaseExecutor db, String table, String column) async {
    final rows = await db.rawQuery('PRAGMA table_info($table);');
    for (final r in rows) {
      if ((r['name'] as String?) == column) return true;
    }
    return false;
  }
}

final databaseProvider = FutureProvider<Database>((ref) async {
  final db = await DBHelper.database;
  return db;
});