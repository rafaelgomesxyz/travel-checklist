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
        animatedIcon: AnimatedIcons.menu_close,
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
            backgroundColor: Colors.green,
            child: Icon(Icons.location_city),
            label: 'CIDADE',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: 'CIDADE')));
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: Icon(Icons.local_florist),
            label: 'CAMPO',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: 'CAMPO')));
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.red,
            child: Icon(Icons.beach_access),
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