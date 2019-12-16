import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/TripCard.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/enums.dart';
import 'package:travel_checklist/services/NotificationManager.dart';

class TripList extends StatefulWidget {
  final bool notificationsOnly;
  final int numToShow;

  TripList({ Key key, this.notificationsOnly, this.numToShow }) : super(key: key);

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  bool _notificationsOnly = false;
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
    if (widget.notificationsOnly != null) {
      _notificationsOnly = widget.notificationsOnly;
    }
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
    List<Trip> trips = [];
    if (_notificationsOnly) {
      List<PendingNotificationRequest> notifications = await NotificationManager.instance.getNotifications();
      for (PendingNotificationRequest notification in notifications) {
        Trip trip = await _dbHelper.getTrip(notification.id);
        trips.add(trip);
      }
    } else {
      trips = await _dbHelper.getTrips();
      if (_numToShow > 0) {
        DateTime now = DateTime.now();
        List<Trip> filteredTrips = [];
        for (Trip trip in trips) {
          if (trip.departureTimestamp > now.millisecondsSinceEpoch) {
            filteredTrips.add(trip);
          }
        }
        trips = filteredTrips;
        if (trips.length > _numToShow) {
          trips.removeRange(_numToShow, trips.length);
        }
      }
    }
    _listController.sink.add(trips);
  }

  void _sortList(List<Trip> trips) {
    DateTime now = DateTime.now();
    trips.sort((Trip a, Trip b) {
      if (a.departureTimestamp > b.departureTimestamp) {
        if (b.departureTimestamp <= now.millisecondsSinceEpoch) {
          b.isPast = true;
          return -1;
        }
        return 1;
      }
      if (b.departureTimestamp > a.departureTimestamp) {
        if (a.departureTimestamp <= now.millisecondsSinceEpoch) {
          a.isPast = true;
          return 1;
        }
        return -1;
      }
      return 0;
    });
  }
}