import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/models/ChecklistItem.dart';
import 'package:travel_checklist/models/Trip.dart';

class DatabaseHelper {
  static final _databaseName = 'database.db';
  static final _databaseVersion = 1;

  static final tableChecklistItem = 'checklist_item';
  static final tableChecklist = 'checklist';
  static final tableTrip = 'trip';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnCurrentItems = 'current_items';
  static final columnTotalItems = 'total_items';
  static final columnTimestamp = 'timestamp';
  static final columnDestination = 'destination';
  static final columnIsChecked = 'is_checked';

  DatabaseHelper._privateConstructor(); // Singleton
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
$columnCurrentItems INTEGER NOT NULL,
$columnTotalItems INTEGER NOT NULL
)''');
    await db.execute('''
CREATE TABLE $tableChecklistItem (
$columnId INTEGER PRIMARY KEY AUTOINCREMENT,
$tableChecklist INTEGER NOT NULL REFERENCES $tableChecklist ($columnId),
$columnTitle VARCHAR(255) NOT NULL),
$columnIsChecked TINYINT NOT NULL)
''');
  }

  Future<int> insertChecklistItem(ChecklistItem item) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[tableChecklist] = item.checklist;
    row[columnTitle] = item.title;
    row[columnIsChecked] = item.isChecked;
    return await db.insert(tableChecklistItem, row);
  }

  Future<int> insertChecklist(Checklist checklist) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[tableTrip] = checklist.trip;
    row[columnTitle] = checklist.title;
    row[columnCurrentItems] = checklist.currentItems;
    row[columnTotalItems] = checklist.totalItems;
    return await db.insert(tableChecklist, row);
  }

  Future<int> insertTrip(Trip trip) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[columnTitle] = trip.title;
    row[columnTimestamp] = trip.timestamp;
    row[columnDestination] = trip.destination;
    return await db.insert(tableTrip, row);
  }

  Future<int> updateChecklistItem(ChecklistItem item) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[columnTitle] = item.title;
    row[columnIsChecked] = item.isChecked;
    return await db.update(tableChecklistItem, row, where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future<int> updateChecklist(Checklist checklist) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[columnTitle] = checklist.title;
    row[columnCurrentItems] = checklist.currentItems;
    row[columnTotalItems] = checklist.totalItems;
    return await db.update(tableChecklist, row, where: '$columnId = ?', whereArgs: [checklist.id]);
  }

  Future<int> updateTrip(Trip trip) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[columnTitle] = trip.title;
    row[columnTimestamp] = trip.timestamp;
    row[columnDestination] = trip.destination;
    return await db.update(tableTrip, row, where: '$columnId = ?', whereArgs: [trip.id]);
  }

  Future<List<ChecklistItem>> getChecklistItems(int checklist) async {
    Database db = await instance.database;
    List<ChecklistItem> items = [];
    List<Map<String, dynamic>> rows = await db.rawQuery('SELECT * FROM $tableChecklistItem WHERE $tableChecklist = $checklist');
    for (Map<String, dynamic> row in rows) {
      ChecklistItem item = ChecklistItem(row[columnId], row[tableChecklist]);
      item.title = row[columnTitle];
      item.isChecked = row[columnIsChecked];
      items.add(item);
    }
    return items;
  }

  Future<List<Checklist>> getChecklists(int trip) async {
    Database db = await instance.database;
    List<Checklist> checklists = [];
    List<Map<String, dynamic>> rows = await db.rawQuery('SELECT * FROM $tableChecklist WHERE $tableTrip = $trip');
    for (Map<String, dynamic> row in rows) {
      Checklist checklist = Checklist(row[columnId], row[tableTrip]);
      checklist.title = row[columnTitle];
      checklist.currentItems = row[columnCurrentItems];
      checklist.totalItems = row[columnTotalItems];
      checklists.add(checklist);
    }
    return checklists;
  }

  Future<List<Trip>> getTrips() async {
    Database db = await instance.database;
    List<Trip> trips = [];
    List<Map<String, dynamic>> rows = await db.query(tableTrip);
    for (Map<String, dynamic> row in rows) {
      Trip trip = Trip(row[columnId]);
      trip.title = row[columnTitle];
      trip.timestamp = row[columnTimestamp];
      trip.destination = row[columnDestination];
      trips.add(trip);
    }
    return trips;
  }

  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
