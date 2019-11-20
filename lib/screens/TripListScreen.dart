import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:travel_checklist/components/TripList.dart';
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
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {} ),
        ],
      ),
      body: TripList(),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        child: Icon(Icons.add),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.location_city),
            backgroundColor: Colors.green,
            label: 'CIDADE',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: 'CIDADE')));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.local_florist),
            backgroundColor: Colors.blue,
            label: 'CAMPO',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: 'CAMPO')));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.beach_access),
            backgroundColor: Colors.red,
            label: 'PRAIA',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: 'PRAIA')));
            },
          ),
        ],
      ),
    );
  }
}