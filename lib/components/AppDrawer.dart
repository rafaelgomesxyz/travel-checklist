import 'package:flutter/material.dart';
import 'package:travel_checklist/screens/HomeScreen.dart';
import 'package:travel_checklist/screens/NotificationsScreen.dart';
import 'package:travel_checklist/screens/SettingsScreen.dart';
import 'package:travel_checklist/enums.dart';
import 'package:travel_checklist/screens/TripListScreen.dart';

class AppDrawer extends StatelessWidget {
  final Screen currentScreen;

  AppDrawer({ Key key, @required this.currentScreen }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget> [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Row(
              children: <Widget> [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 48.0,
                  margin: EdgeInsets.only(right: 10.0),
                  width: 48.0,
                ),
                Text(
                  'Travel Checklist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            onTap: () {
              if (currentScreen == Screen.Home) {
                Navigator.pop(context);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_context) => HomeScreen(title: 'Travel Checklist')));
              }
            },
            title: Text('Página Inicial'),
          ),
          ListTile(
            leading: Icon(Icons.airplanemode_active),
            onTap: () {
              if (currentScreen == Screen.TripList) {
                Navigator.pop(context);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_context) => TripListScreen(title: 'Travel Checklist')));
              }
            },
            title: Text('Viagens'),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            onTap: () {
              if (currentScreen == Screen.Notifications) {
                Navigator.pop(context);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_context) => NotificationsScreen()));
              }
            },
            title: Text('Notificações'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            onTap: () {
              if (currentScreen == Screen.Settings) {
                Navigator.pop(context);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_context) => SettingsScreen()));
              }
            },
            title: Text('Configurações'),
          ),
        ],
        padding: EdgeInsets.zero,
      ),
    );
  }
}