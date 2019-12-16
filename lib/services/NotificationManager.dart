import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:travel_checklist/enums.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/screens/TripScreen.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

class NotificationManager {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  NotificationManager._privateConstructor(); // Singleton
  static final NotificationManager instance = NotificationManager._privateConstructor();
  static FlutterLocalNotificationsPlugin _plugin;
  static BuildContext _context;

  Future<FlutterLocalNotificationsPlugin> get plugin async {
    if (_plugin != null) {
      return _plugin;
    }
    _plugin = FlutterLocalNotificationsPlugin();
    return _plugin;
  }

  Future init(BuildContext context) async {
    FlutterLocalNotificationsPlugin plg = await instance.plugin;
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('icon');
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(androidInitializationSettings, iosInitializationSettings);
    plg.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
    _context = context;
  }

  Future _onSelectNotification(String payload) async {
    int id = int.parse(payload);
    Trip trip = await _dbHelper.getTrip(id);
    Navigator.push(_context, MaterialPageRoute(builder: (BuildContext routeContext) => TripScreen(trip: trip)));
    trip.notificationHours = 0;
    await _dbHelper.updateTrip(trip);
    EventDispatcher.instance.emit(Event.TripEdited, { 'trip': trip });
  }

  Future scheduleNotification(int id, String title, String body, DateTime notificationTime) async {
    FlutterLocalNotificationsPlugin plg = await instance.plugin;
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
    );
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    return plg.schedule(
      id,
      title,
      body,
      notificationTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      payload: id.toString(),
    );
  }

  Future cancelNotification(int id) async {
    FlutterLocalNotificationsPlugin plg = await instance.plugin;
    return plg.cancel(id);
  }

  Future<List<PendingNotificationRequest>> getNotifications() async {
    FlutterLocalNotificationsPlugin plg = await instance.plugin;
    return plg.pendingNotificationRequests();
  }
}