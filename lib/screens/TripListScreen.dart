import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/screens/TripFormScreen.dart';
import '../components/TripCard.dart';
import '../models/Trip.dart';

class TripListScreen extends StatefulWidget {
  final String title;

  TripListScreen({ Key key, this.title }) : super(key: key);

  @override
  _TripListScreenState createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  List<Trip> _trips;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    this._resetState();
  }

  void _resetState() {
    List<Trip> trips = [];
    Random random = new Random();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 15; i++) {
      int total = random.nextInt(9) + 1;
      int current = random.nextInt(total) + 1;
      Trip trip = Trip(i);
      trip.destination = current > 5 ? 'Sao Paulo' : 'Rio de Janeiro';
      trip.title = 'Viagem ${i + 1}';
      trip.timestamp = now + current * 1000 * 60 * 60 * 60;
      trip.progress.current = current;
      trip.progress.total = total;
      trips.add(trip);
    }
    setState(() {
      this._trips = trips;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(this._trips.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: this._resetState ),
        ],
      ),
      body: Center(
        child: this._trips.length > 0 ? this.buildList() : Text('nothing'),
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

  Widget buildList() {
    this._trips.sort((Trip a, Trip b) {
      if (a.progress.current == a.progress.total) {
        return 1;
      }
      if (b.progress.current == b.progress.total) {
        return -1;
      }
      if (a.timestamp > b.timestamp) {
        return 1;
      }
      if (a.timestamp < b.timestamp) {
        return -1;
      }
      double aPercentage = a.progress.current / a.progress.total;
      double bPercentage = b.progress.current / b.progress.total;
      if (aPercentage > bPercentage) {
        return 1;
      }
      if (aPercentage < bPercentage) {
        return -1;
      }
      return 0;
    });
    return RefreshIndicator(
      child: ListView(
        children: this._trips.map((Trip trip) => TripCard(trip)).toList(),
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
        //physics: AlwaysScrollableScrollPhysics(),
      ),
      onRefresh: () async {
        this._resetState();
        return;
      },
    );
  }
}