import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistList.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/screens/ChecklistFormScreen.dart';
import 'package:travel_checklist/screens/TripFormScreen.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/enums.dart';

class TripScreen extends StatefulWidget {
  final Trip trip;

  TripScreen({ Key key, this.trip }) : super(key: key);

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  DateFormat _dateFormat;
  Trip _trip;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat.yMd('pt_BR').add_Hm();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    setState(() {
      _trip = widget.trip;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime departureDate = DateTime.fromMillisecondsSinceEpoch(_trip.departureTimestamp);
    DateTime returnDate = DateTime.fromMillisecondsSinceEpoch(_trip.returnTimestamp);
    return Scaffold(
      appBar: AppBar(
        title: Text(_trip.name),
      ),
      body: Column(
        children: <Widget> [
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
            child: Row(
              children: <Widget> [
                Text(
                  'IDA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${_dateFormat.format(departureDate)} (${timeago.format(departureDate, locale: 'pt_BR', allowFromNow: true)})'),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          ),
          Container(
            child: Row(
              children: <Widget> [
                Text(
                  'VOLTA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${_dateFormat.format(returnDate)} (${timeago.format(returnDate, locale: 'pt_BR', allowFromNow: true)})'),
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
            onTap: () {
              _deleteTrip();
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: Icon(Icons.edit),
            label: 'Editar Viagem',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(trip: widget.trip)));
              setState(() {
                _trip = widget.trip;
              });
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