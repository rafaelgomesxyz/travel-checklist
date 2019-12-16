import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/screens/TripFormScreen.dart';
import 'package:travel_checklist/screens/TripScreen.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/enums.dart';
import 'package:travel_checklist/services/NotificationManager.dart';

class TripCard extends StatefulWidget {
  final Trip trip;

  TripCard({ Key key, this.trip }) : super(key: key);

  @override
  _TripCardState createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  Trip _trip;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      _trip = widget.trip;
    });
  }

  @override
  build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: <Widget> [
            Container(
              child: Text(
                _trip.name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
            ),
            Container(
              child: Row(
                children: <Widget> [
                  Row(
                    children: <Widget> [
                      Icon(Icons.flight),
                      Text(_trip.destination),
                    ],
                  ),
                  Row(
                    children: <Widget> [
                      Text(
                        timeago.format(DateTime.fromMillisecondsSinceEpoch(_trip.departureTimestamp), locale: 'pt_BR', allowFromNow: true),
                      ),
                      Icon(Icons.access_time),
                    ],
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.all(10.0),
      ),
      onLongPress: () {
        _openTripMenu();
      },
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TripScreen(trip: widget.trip)));
      },
    );
  }

  void _openTripMenu() {
    showDialog(
      builder: (BuildContext _context) => SimpleDialog(
        children: <Widget> [
          FlatButton.icon(
            icon: Icon(
              Icons.edit,
              color: Colors.green,
              size: 20.0
            ),
            label: Text('Editar Viagem'),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(trip: widget.trip)));
              Navigator.pop(_context);
              setState(() {
                _trip = widget.trip;
              });
            },
            padding: EdgeInsets.all(0.0),
          ),
          FlatButton.icon(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 20.0
            ),
            label: Text('Deletar Viagem'),
            onPressed: () {
              _deleteTrip();
            },
            padding: EdgeInsets.all(0.0),
          ),
        ],
        contentPadding: EdgeInsets.all(0.0),
      ),
      context: context,
    );
  }

  void _deleteTrip() {
    showDialog(
      builder: (BuildContext _context) => AlertDialog(
        actions: <Widget> [
          FlatButton(
            child: Text('Não'),
            onPressed: () {
              Navigator.pop(_context);
            },
          ),
          FlatButton(
            child: Text('Sim'),
            onPressed: () async {
              await NotificationManager.instance.cancelNotification(_trip.id);
              await _dbHelper.deleteTrip(_trip.id);
              _eDispatcher.emit(Event.TripRemoved, { 'trip': _trip });
              Navigator.pop(_context);
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('Tem certeza que deseja deletar essa viagem?'),
      ),
      context: context,
    );
  }

}