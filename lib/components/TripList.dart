import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/TripCard.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

class TripList extends StatefulWidget {
  final int numToShow;

  TripList({ Key key, this.numToShow }) : super(key: key);

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  List<Trip> _trips = [];
  int _numToShow;

  StreamSubscription _tripAddedSubscription;
  StreamSubscription _tripRemovedSubscription;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    if (widget.numToShow != null) {
      _numToShow = widget.numToShow;
    } else {
      _numToShow = 0;
    }
    _tripAddedSubscription = _eDispatcher.listen(EventDispatcher.eventChecklistAdded, _loadTrips);
    _tripRemovedSubscription = _eDispatcher.listen(EventDispatcher.eventChecklistRemoved, _loadTrips);
    _loadTrips({});
  }

  @override
  void dispose() {
    super.dispose();
    _tripAddedSubscription.cancel();
    _tripRemovedSubscription.cancel();
  }

  @override
  build(BuildContext context) {
    if (_trips.length > 0) {
      _sortList();
      return RefreshIndicator(
        child: ListView(
          children: _trips.map((Trip trip) => TripCard(trip: trip)).toList(),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
          physics: _numToShow > 0
            ? NeverScrollableScrollPhysics()
            : AlwaysScrollableScrollPhysics(),
        ),
        onRefresh: () async {
          _loadTrips({});
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
        _loadTrips({});
        return;
      },
    );
  }

  void _loadTrips(Map<String, dynamic> unused) async {
    List<Trip> trips = await _dbHelper.getTrips();
    setState(() {
      _trips = trips;
    });
  }

  void _sortList() {
    _trips.sort((Trip a, Trip b) {
      if (a.timestamp > b.timestamp) {
        return 1;
      }
      if (b.timestamp > a.timestamp) {
        return -1;
      }
      return 0;
    });
    if (_numToShow > 0 && _trips.length > 3) {
      _trips.removeRange(3, _trips.length);
    }
  }
}