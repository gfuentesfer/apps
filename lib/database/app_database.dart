import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Abre la base SQLite embebida (copiada desde assets en el primer arranque).
class AppDatabase {
  AppDatabase._();

  static Database? _db;
  static const _assetPath = 'assets/database/myarrows.db';
  static const _dbFileName = 'myarrows.db';

  static Future<Database> get instance async {
    _db ??= await _open();
    return _db!;
  }

  static Future<void> init() async {
    await instance;
  }

  static Future<Database> _open() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, _dbFileName);

    if (!await File(dbPath).exists()) {
      final data = await rootBundle.load(_assetPath);
      await File(dbPath).writeAsBytes(
        data.buffer.asUint8List(),
        flush: true,
      );
    }

    return openDatabase(
      dbPath,
      readOnly: true,
      singleInstance: true,
    );
  }
}
