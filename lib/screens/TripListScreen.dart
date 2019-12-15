import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:travel_checklist/components/AppDrawer.dart';
import 'package:travel_checklist/components/TripList.dart';
import 'package:travel_checklist/enums.dart';
import 'package:travel_checklist/screens/TripFormScreen.dart';

class TripListScreen extends StatefulWidget {
  final String title;

  TripListScreen({ Key key, this.title }) : super(key: key);

  @override
  _TripListScreenState createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: AppDrawer(currentScreen: Screen.TripList),
      body: TripList(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        animatedIconTheme: IconThemeData(size: 22.0),
        backgroundColor: Colors.white,
        closeManually: false,
        curve: Curves.bounceIn,
        elevation: 8.0,
        foregroundColor: Colors.black,
        heroTag: 'speed-dial-hero-tag',
        marginBottom: 20,
        marginRight: 18,
        onClose: () {},
        onOpen: () {},
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        shape: CircleBorder(),
        tooltip: 'Speed Dial',
        visible: true,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.black54,
            child: Icon(Icons.flight),
            label: 'OUTRA',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: Template.Outro)));
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: Icon(Icons.location_city),
            label: 'CIDADE',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: Template.Cidade)));
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: Icon(Icons.local_florist),
            label: 'CAMPO',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: Template.Campo)));
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.red,
            child: Icon(Icons.beach_access),
            label: 'PRAIA',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: Template.Praia)));
            },
          ),
        ],
      ),
    );
  }
}