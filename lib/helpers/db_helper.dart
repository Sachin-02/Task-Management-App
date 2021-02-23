import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;

// static helper class for accessing the sqlite database

class DBHelper {
  DBHelper._();
  static final DBHelper db = DBHelper._();
  static Database _database;

  // making sure there is only one instance of the db active
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, "tasks.db"),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE IF NOT EXISTS task_groups(
              id TEXT PRIMARY KEY, 
              name TEXT)
              ''');
        await db.execute('''CREATE TABLE IF NOT EXISTS user_tasks(
              id TEXT PRIMARY KEY, 
              groupId TEXT, 
              title TEXT, 
              description TEXT, 
              isCompleted TEXT,
              FOREIGN KEY(groupId) REFERENCES task_groups
              )''');
      },
      onConfigure: (db) {
        // enables foreign key constraint usage
        db.execute("PRAGMA foreign_keys = ON");
      },
      version: 1,
    );
  }

  Future<void> insert(String tableName, Map<String, Object> data) async {
    final db = await database;
    await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> getAllData(String table) async {
    final db = await database;
    return db.query(table);
  }

  Future<List<Map<String, dynamic>>> getData(
      {String table, String columnId, String arg}) async {
    final db = await database;
    return db.query(
      table,
      where: "$columnId = ?",
      whereArgs: [arg],
    );
  }

  Future<void> delete({String table, String columnId, String whereArg}) async {
    final db = await database;
    await db.delete(table, where: "$columnId = ?", whereArgs: [whereArg]);
  }

  Future<void> update(
      {String table,
      String columnId,
      String whereColumnId,
      String setArg,
      String whereArg}) async {
    final db = await database;
    await db.rawUpdate(
        "UPDATE $table SET $columnId = ? WHERE $whereColumnId = ?",
        [setArg, whereArg]);
  }

  Future<void> updateColumn({String table, String columnId, String arg}) async {
    final db = await database;
    await db.rawUpdate("UPDATE $table SET $columnId = ?", ["$arg"]);
  }

  Future<void> deleteDb() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase("$dbPath/tasks.db");
  }
}
