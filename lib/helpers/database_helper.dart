import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final databasesPath = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(databasesPath, 'places.db'), version: 1,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, address TEXT, lat REAL, lng REAL, description TEXT)');
    });
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await database();
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object>>> getData(String table) async {
    final db = await database();
    return db.query(table);
  }
}
