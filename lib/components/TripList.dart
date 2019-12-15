import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/TripCard.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/enums.dart';

class TripList extends StatefulWidget {
  final int numToShow;

  TripList({ Key key, this.numToShow }) : super(key: key);

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  int _numToShow;

  StreamController<List<Trip>> _listController = StreamController<List<Trip>>();
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
    _tripAddedSubscription = _eDispatcher.listen(Event.TripAdded, _loadTrips);
    _tripRemovedSubscription = _eDispatcher.listen(Event.TripRemoved, _loadTrips);
    _loadTrips({});
  }

  @override
  void dispose() {
    _listController.close();
    _tripAddedSubscription.cancel();
    _tripRemovedSubscription.cancel();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return RefreshIndicator(
      child: StreamBuilder(
        builder: (BuildContext _context, AsyncSnapshot<List<Trip>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              _sortList(snapshot.data);
              return ListView.builder(
                itemBuilder: (BuildContext __context, int index) {
                  Trip trip = snapshot.data[index];
                  return TripCard(
                    key: Key(trip.id.toString()),
                    trip: trip,
                  );
                },
                itemCount: snapshot.data.length,
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, _numToShow > 0 ? 10.0 : 75.0),
              );
            }
            return Column(
              children: <Widget> [
                Container(
                  child: Text('Nenhuma viagem encontrada.'),
                  alignment: Alignment.center,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            );
          }
          return Column(
            children: <Widget> [
              Container(
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          );
        },
        stream: _listController.stream,
      ),
      onRefresh: () async {
        _loadTrips({});
      },
    );
  }

  void _loadTrips(Map<String, dynamic> unused) async {
    List<Trip> trips = await _dbHelper.getTrips();
    _listController.sink.add(trips);
  }

  void _sortList(List<Trip> trips) {
    trips.sort((Trip a, Trip b) {
      if (a.timestamp > b.timestamp) {
        return 1;
      }
      if (b.timestamp > a.timestamp) {
        return -1;
      }
      return 0;
    });
    if (_numToShow > 0 && trips.length > _numToShow) {
      trips.removeRange(_numToShow, trips.length);
    }
  }
}