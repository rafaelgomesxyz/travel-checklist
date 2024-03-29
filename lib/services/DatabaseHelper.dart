import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travel_checklist/enums.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/models/ChecklistItem.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/services/TripBuilder.dart';

class DatabaseHelper {
  static final _databaseName = 'database.db';
  static final _databaseVersion = 1;

  static final tableChecklistItem = 'checklist_item';
  static final tableChecklist = 'checklist';
  static final tableTrip = 'trip';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnCoordinates = 'coordinates';
  static final columnIsChecked = 'is_checked';
  static final columnForPlaces = 'for_places';
  static final columnDestination = 'destination';
  static final columnDestinationCoordinates = 'destination_coordinates';
  static final columnDepartureTimestamp = 'departure_timestamp';
  static final columnReturnTimestamp = 'return_timestamp';
  static final columnNotificationHours = 'notification_hours';

  static final schemaChecklistItem = '''
    CREATE TABLE $tableChecklistItem (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $tableChecklist INTEGER NOT NULL REFERENCES $tableChecklist ($columnId),
      $columnName VARCHAR(255) NOT NULL,
      $columnCoordinates VARCHAR(63),
      $columnIsChecked TINYINT NOT NULL
    )
  ''';
  static final schemaChecklist = '''
    CREATE TABLE $tableChecklist (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $tableTrip INTEGER NOT NULL REFERENCES $tableTrip ($columnId),
      $columnName VARCHAR(255) NOT NULL,
      $columnForPlaces TINYINT NOT NULL
    )
  ''';
  static final schemaTrip = '''
    CREATE TABLE $tableTrip (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName VARCHAR(255) NOT NULL,
      $columnDestination VARCHAR(255) NOT NULL,
      $columnDestinationCoordinates VARCHAR(63) NOT NULL,
      $columnDepartureTimestamp INTEGER NOT NULL,
      $columnReturnTimestamp INTEGER NOT NULL,
      $columnNotificationHours INTEGER NOT NULL
    )
  ''';

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
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(schemaTrip);
    await db.execute(schemaChecklist);
    await db.execute(schemaChecklistItem);
  }

  Future<int> insertChecklistItem(ChecklistItem item) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[tableChecklist] = item.checklist;
    row[columnName] = item.name;
    row[columnCoordinates] = item.coordinates;
    row[columnIsChecked] = item.isChecked;
    return await db.insert(tableChecklistItem, row);
  }

  Future<int> insertChecklist(Checklist checklist) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[tableTrip] = checklist.trip;
    row[columnName] = checklist.name;
    row[columnForPlaces] = checklist.forPlaces;
    return await db.insert(tableChecklist, row);
  }

  Future<int> insertTrip(Trip trip, Template template) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[columnName] = trip.name;
    row[columnDestination] = trip.destination;
    row[columnDestinationCoordinates] = trip.destinationCoordinates;
    row[columnDepartureTimestamp] = trip.departureTimestamp;
    row[columnReturnTimestamp] = trip.returnTimestamp;
    row[columnNotificationHours] = trip.notificationHours;
    int tripId = await db.insert(tableTrip, row);

    // Fill trip with predefined checklists based on template.
    Map<String, List<String>> checklists = TripBuilder.instance.getPredefinedChecklists(template);
    if (checklists != null) {
      for (String checklistName in checklists.keys) {
        Checklist checklist = Checklist();
        checklist.trip = tripId;
        checklist.name = checklistName;
        checklist.forPlaces = false;
        int checklistId = await this.insertChecklist(checklist);
        for (String itemName in checklists[checklistName]) {
          ChecklistItem item = ChecklistItem();
          item.checklist = checklistId;
          item.name = itemName;
          item.coordinates = '';
          item.isChecked = false;
          await this.insertChecklistItem(item);
        }
      }
      Checklist checklist = Checklist();
      checklist.trip = tripId;
      checklist.name = '05. Lugares para Visitar';
      checklist.forPlaces = true;
      await this.insertChecklist(checklist);
    }

    return tripId;
  }

  Future<int> updateChecklistItem(ChecklistItem item) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[columnName] = item.name;
    row[columnCoordinates] = item.coordinates;
    row[columnIsChecked] = item.isChecked;
    return await db.update(tableChecklistItem, row, where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future<int> updateChecklist(Checklist checklist) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[columnName] = checklist.name;
    row[columnForPlaces] = checklist.forPlaces;
    return await db.update(tableChecklist, row, where: '$columnId = ?', whereArgs: [checklist.id]);
  }

  Future<int> updateTrip(Trip trip) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {};
    row[columnName] = trip.name;
    row[columnDestination] = trip.destination;
    row[columnDestinationCoordinates] = trip.destinationCoordinates;
    row[columnDepartureTimestamp] = trip.departureTimestamp;
    row[columnReturnTimestamp] = trip.returnTimestamp;
    row[columnNotificationHours] = trip.notificationHours;
    return await db.update(tableTrip, row, where: '$columnId = ?', whereArgs: [trip.id]);
  }

  Future<ChecklistItem> getChecklistItem(int id) async {
    Database db = await instance.database;
    Map<String, dynamic> row = (await db.rawQuery('SELECT * FROM $tableChecklistItem WHERE $columnId = $id')).first;
    ChecklistItem item = ChecklistItem();
    item.id = row[columnId];
    item.checklist = row[tableChecklist];
    item.name = row[columnName];
    item.coordinates = row[columnCoordinates] ?? '';
    item.isChecked = row[columnIsChecked] == 1;
    return item;
  }

  Future<Checklist> getChecklist(int id) async {
    Database db = await instance.database;
    Map<String, dynamic> row = (await db.rawQuery(
      'SELECT * FROM $tableChecklist WHERE $columnId = $id')).first;
    Checklist checklist = Checklist();
    checklist.id = row[columnId];
    checklist.trip = row[tableTrip];
    checklist.name = row[columnName];
    checklist.forPlaces = row[columnForPlaces] == 1;
    checklist.checkedItems = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM $tableChecklistItem WHERE $tableChecklist = ${checklist
          .id} AND $columnIsChecked = 1')
    );
    checklist.totalItems = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM $tableChecklistItem WHERE $tableChecklist = ${checklist
          .id}')
    );
    return checklist;
  }

  Future<Trip> getTrip(int id) async {
    Database db = await instance.database;
    Map<String, dynamic> row = (await db.rawQuery('SELECT * FROM $tableTrip WHERE $columnId = $id')).first;
    Trip trip = Trip();
    trip.id = row[columnId];
    trip.name = row[columnName];
    trip.destination = row[columnDestination];
    trip.destinationCoordinates = row[columnDestinationCoordinates];
    trip.departureTimestamp = row[columnDepartureTimestamp];
    trip.returnTimestamp = row[columnReturnTimestamp];
    trip.notificationHours = row[columnNotificationHours];
    return trip;
  }

  Future<List<ChecklistItem>> getChecklistItems(int checklist) async {
    Database db = await instance.database;
    List<ChecklistItem> items = [];
    List<Map<String, dynamic>> rows = await db.rawQuery('SELECT * FROM $tableChecklistItem WHERE $tableChecklist = $checklist');
    for (Map<String, dynamic> row in rows) {
      ChecklistItem item = ChecklistItem();
      item.id = row[columnId];
      item.checklist = row[tableChecklist];
      item.name = row[columnName];
      item.coordinates = row[columnCoordinates] ?? '';
      item.isChecked = row[columnIsChecked] == 1;
      items.add(item);
    }
    return items;
  }

  Future<List<Checklist>> getChecklists(int trip) async {
    Database db = await instance.database;
    List<Checklist> checklists = [];
    List<Map<String, dynamic>> rows = await db.rawQuery('SELECT * FROM $tableChecklist WHERE $tableTrip = $trip');
    for (Map<String, dynamic> row in rows) {
      Checklist checklist = Checklist();
      checklist.id = row[columnId];
      checklist.trip = row[tableTrip];
      checklist.name = row[columnName];
      checklist.forPlaces = row[columnForPlaces] == 1;
      checklist.checkedItems = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableChecklistItem WHERE $tableChecklist = ${checklist.id} AND $columnIsChecked = 1')
      );
      checklist.totalItems = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableChecklistItem WHERE $tableChecklist = ${checklist.id}')
      );
      checklists.add(checklist);
    }
    return checklists;
  }

  Future<List<Trip>> getTrips() async {
    Database db = await instance.database;
    List<Trip> trips = [];
    List<Map<String, dynamic>> rows = await db.query(tableTrip);
    for (Map<String, dynamic> row in rows) {
      Trip trip = Trip();
      trip.id = row[columnId];
      trip.name = row[columnName];
      trip.destination = row[columnDestination];
      trip.destinationCoordinates = row[columnDestinationCoordinates];
      trip.departureTimestamp = row[columnDepartureTimestamp];
      trip.returnTimestamp = row[columnReturnTimestamp];
      trip.notificationHours = row[columnNotificationHours];
      trips.add(trip);
    }
    return trips;
  }

  Future<int> deleteChecklistItem(int id) async {
    Database db = await instance.database;
    return await db.delete(tableChecklistItem, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteChecklist(int id) async {
    Database db = await instance.database;
    List<ChecklistItem> items = await getChecklistItems(id);
    for (ChecklistItem item in items) {
      await deleteChecklistItem(item.id);
    }
    return await db.delete(tableChecklist, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteTrip(int id) async {
    Database db = await instance.database;
    List<Checklist> checklists = await getChecklists(id);
    for (Checklist checklist in checklists) {
      await deleteChecklist(checklist.id);
    }
    return await db.delete(tableTrip, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }
}
