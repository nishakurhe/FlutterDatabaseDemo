import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'Model.dart';

abstract class SqliteDatabase {
  static Database productDb;
  static String table = "product_items";
  static Future<void> init() async {
    if (productDb != null) return;
    try {
      String dbPath = await getDatabasesPath() + "product";
      productDb = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void _onCreate(Database db, int ver) async => await db.execute(
      'CREATE TABLE product_items (id INTEGER PRIMARY KEY NOT NULL, name TEXT, image TEXT)');

  static Future<List<Map<String, dynamic>>> getAllProduct() async =>
      productDb.query(table);

  static Future<int> insert(Model model) async =>
      await productDb.insert(table, model.toMap());

  static Future<int> update(Model model) async => await productDb
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(Model model) async =>
      await productDb.delete(table, where: 'id = ?', whereArgs: [model.id]);
}
