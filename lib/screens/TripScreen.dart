import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistList.dart';
import 'package:travel_checklist/screens/ChecklistFormScreen.dart';
import 'package:travel_checklist/screens/TripFormScreen.dart';
import '../models/Trip.dart';

class TripScreen extends StatefulWidget {
  final Trip trip;

  TripScreen({ Key key, this.trip }) : super(key: key);

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.trip.timestamp);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {} ),
        ],
      ),
      body: Column(
        children: <Widget> [
          Container(
            child: Row(
              children: <Widget> [
                Text(
                  'DATA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${date.toIso8601String()} (${timeago.format(date, locale: 'pt_BR', allowFromNow: true)})'),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          ),
          Container(
            child: Row(
              children: <Widget> [
                Text(
                  'DESTINO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.trip.destination),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          ),
          Container(
            child: Text(
              'CHECKLISTS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
          ),
          Expanded(
            child: ChecklistList(trip: widget.trip.id),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            label: 'Deletar',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.edit),
            backgroundColor: Colors.green,
            label: 'Editar',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(trip: widget.trip)));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.playlist_add_check),
            backgroundColor: Colors.blue,
            label: 'Adicionar Checklist',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistFormScreen(trip: widget.trip.id)));
            },
          ),
        ],
      ),
    );
  }
}