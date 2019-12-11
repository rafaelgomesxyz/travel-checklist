import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;

  static final tableItem = 'item';
  static final tableChecklist = 'checklist';
  static final tableTrip = 'trip';
  static final tableChecklistItem = 'checklist_item';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnTimestamp = 'timestamp';
  static final columnDestination = 'destination';
  static final columnIsChecked = 'is_checked';

  DatabaseHelper._privateConstructor(); // classe Singleton
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
      version: _databaseVersion,
      onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableTrip (
$columnId INTEGER PRIMARY KEY AUTOINCREMENT,
$columnTitle VARCHAR(255) NOT NULL,
$columnTimestamp INTEGER NOT NULL,
$columnDestination VARCHAR(255) NOT NULL
)
''');
    await db.execute('''
CREATE TABLE $tableChecklist (
$columnId INTEGER PRIMARY KEY AUTOINCREMENT,
$tableTrip INTEGER NOT NULL REFERENCES $tableTrip ($columnId),
$columnTitle VARCHAR(255) NOT NULL,
)''');
    await db.execute('''
CREATE TABLE $tableItem (
$columnId INTEGER PRIMARY KEY AUTOINCREMENT,
$columnTitle VARCHAR(255) NOT NULL)
''');
    await db.execute('''
CREATE TABLE $tableChecklistItem (
$columnId INTEGER PRIMARY KEY AUTOINCREMENT,
$tableItem INTEGER NOT NULL REFERENCES $tableItem ($columnId),
$tableChecklist INTEGER NOT NULL REFERENCES $tableChecklist ($columnId),
$columnIsChecked TINYINT NOT NULL)
''');
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row); // retorna id da linha inserida
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    Database db = await instance.database;
    return await db.rawQuery(query);
  }

  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
