import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {} ),
        ],
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(trip: widget.trip)));
          // TODO: implement function to add new trip
        },
        tooltip: 'Editar Viagem',
        child: Icon(Icons.edit),
      ),
    );
  }
}