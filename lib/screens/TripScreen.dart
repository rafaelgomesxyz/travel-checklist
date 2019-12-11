import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistList.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/screens/ChecklistFormScreen.dart';
import 'package:travel_checklist/screens/TripFormScreen.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

class TripScreen extends StatefulWidget {
  final Trip trip;

  TripScreen({ Key key, this.trip }) : super(key: key);

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  Trip _trip;

  StreamSubscription _tripEditedSubscription;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    _tripEditedSubscription = _eDispatcher.listen('${EventDispatcher.eventTripEdited}_${widget.trip.id}', _onTripEdited);
    setState(() {
      _trip = widget.trip;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tripEditedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(_trip.timestamp);
    return Scaffold(
      appBar: AppBar(
        title: Text(_trip.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // TODO: resetar
            },
          ),
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
                Text(_trip.destination),
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
            child: ChecklistList(trip: widget.trip),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
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
            backgroundColor: Colors.red,
            child: Icon(Icons.delete),
            label: 'Deletar Viagem',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              await _dbHelper.deleteTrip(_trip.id);
              _eDispatcher.emit(EventDispatcher.eventTripRemoved, { 'trip': _trip });
              Navigator.pop(context);
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: Icon(Icons.edit),
            label: 'Editar Viagem',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(trip: widget.trip)));
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: Icon(Icons.playlist_add_check),
            label: 'Criar Checklist',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistFormScreen(trip: widget.trip.id)));
            },
          ),
        ],
      ),
    );
  }

  void _onTripEdited(Map<String, dynamic> data) {
    if (mounted) {
      setState(() {
        _trip = widget.trip;
      });
    }
  }
}