import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        date TEXT,
        time TEXT,
        priority TEXT,
        isCompleted INTEGER
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'taskDB.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String name,
      String? description,
      String date,
      String time,
      String priority,
      bool isCompleted,
      ) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'description': description,
      'date': date,
      'time': time,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
    };

    final id = await db.insert('tasks', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('tasks', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('tasks', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id,
      String name,
      String? description,
      String date,
      String time,
      String priority,
      bool isCompleted,
      ) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'description': description,
      'date': date,
      'time': time,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
    };

    final result =
    await db.update('tasks', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("tasks", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
