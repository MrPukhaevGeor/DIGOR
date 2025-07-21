import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  static const String dbFileName = "exported_digor.db";

  static Future<Database> get database async {
    if (_database != null) return _database!;

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, dbFileName);

    if (!await File(dbPath).exists()) {
      ByteData data = await rootBundle.load("assets/db/$dbFileName");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    _database = await openDatabase(dbPath);
    return _database!;
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

final databaseProvider = FutureProvider<Database>((ref) async {
  final db = await DBHelper.database;
  return db;
});
