import 'package:flutter/material.dart';
import 'package:travel_checklist/components/AppDrawer.dart';
import 'package:travel_checklist/components/TripList.dart';
import 'package:travel_checklist/enums.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
      ),
      drawer: AppDrawer(currentScreen: Screen.Home),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'Você possui notificações ativas para as seguintes viagens:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            ),
            Expanded(
              child: TripList(notificationsOnly: true),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}