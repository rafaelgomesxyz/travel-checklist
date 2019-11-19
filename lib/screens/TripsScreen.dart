import 'dart:math';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../components/TripCard.dart';
import '../models/Trip.dart';

class TripsScreen extends StatefulWidget {
  final String title;

  TripsScreen({ Key key, this.title }) : super(key: key);

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: implement function to add new trip
        },
        tooltip: 'Adicionar Viagem',
        child: Icon(Icons.add),
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