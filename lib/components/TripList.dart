import 'dart:math';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/TripCard.dart';
import 'package:travel_checklist/models/Trip.dart';

class TripList extends StatefulWidget {
  final int numToShow;

  TripList({ Key key, this.numToShow }) : super(key: key);

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  List<Trip> _trips;
  int _numToShow;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    if (widget.numToShow != null) {
      this._numToShow = widget.numToShow;
    } else {
      this._numToShow = 0;
    }
    this._resetState();
  }

  @override
  build(BuildContext context) {
    this._sortList();
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

  void _sortList() {
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
    if (this._numToShow > 0) {
      this._trips.removeRange(3, this._trips.length);
    }
  }
}