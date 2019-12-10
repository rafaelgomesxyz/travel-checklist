import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/TripCard.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';

class TripList extends StatefulWidget {
  final int numToShow;

  TripList({ Key key, this.numToShow }) : super(key: key);

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  List<Trip> _trips = [];
  int _numToShow;

  final _dbHelper = DatabaseHelper.instance;

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
    if (this._trips.length > 0) {
      this._sortList();
      return RefreshIndicator(
        child: ListView(
          children: this._trips.map((Trip trip) => TripCard(trip)).toList(),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
          physics: this._numToShow > 0
            ? NeverScrollableScrollPhysics()
            : AlwaysScrollableScrollPhysics(),
        ),
        onRefresh: () async {
          this._resetState();
          return;
        },
      );
    }

    return RefreshIndicator(
      child: Column(
        children: <Widget> [
          Container(
            child: Text('Nenhuma viagem encontrada.'),
            alignment: Alignment.center,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      onRefresh: () async {
        this._resetState();
        return;
      },
    );
  }

  void _resetState() async {
    List<Map<String, dynamic>> dbTrips = await this._dbHelper.queryAllRows(DatabaseHelper.tableTrip);
    List<Trip> trips = [];

    for (Map<String, dynamic> dbTrip in dbTrips) {
      Trip trip = Trip(dbTrip[DatabaseHelper.columnId]);
      trip.title = dbTrip[DatabaseHelper.columnTitle];
      trip.timestamp = dbTrip[DatabaseHelper.columnTimestamp];
      trip.destination = dbTrip[DatabaseHelper.columnDestination];
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