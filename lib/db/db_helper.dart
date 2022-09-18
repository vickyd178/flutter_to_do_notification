import 'package:flutter_to_do/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print("creating new one");
        return db.execute("CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING,"
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)");
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task task) async {
    print("insert function called");
    return await _db.insert(_tableName, task.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db.query(_tableName);//strftime('%I:%M %p',startTime)
  }

  static delete(Task task) async {
    return await _db.delete(_tableName, where: "id=?", whereArgs: [task.id]);
  }

  static updateTaskStatus(int id,int status) async {
    return await _db.rawUpdate('''
    UPDATE $_tableName SET isCompleted = ?
    WHERE id = ?
    ''', [status, id]);
  }

  static updateTask(Task task) async {
    return
     await _db.update(_tableName,task.toJson(),where: "id = ${task.id}");
  }

}
