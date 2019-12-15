import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistCard.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/enums.dart';

class ChecklistList extends StatefulWidget {
  final Trip trip;

  ChecklistList({ Key key, this.trip }) : super(key: key);

  @override
  _ChecklistListState createState() => _ChecklistListState();
}

class _ChecklistListState extends State<ChecklistList> {
  StreamController<Trip> _listController = StreamController<Trip>();
  StreamSubscription _checklistItemCheckedSubscription;
  StreamSubscription _checklistAddedSubscription;
  StreamSubscription _checklistRemovedSubscription;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    _checklistItemCheckedSubscription = _eDispatcher.listen(Event.ChecklistItemChecked, _onChecklistItemChecked);
    _checklistAddedSubscription = _eDispatcher.listen(Event.ChecklistAdded, _onChecklistAdded);
    _checklistRemovedSubscription = _eDispatcher.listen(Event.ChecklistRemoved, _onChecklistRemoved);
    _loadChecklists();
  }

  @override
  void dispose() {
    _listController.close();
    _checklistItemCheckedSubscription.cancel();
    _checklistAddedSubscription.cancel();
    _checklistRemovedSubscription.cancel();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return RefreshIndicator(
      child: StreamBuilder(
        builder: (BuildContext _context, AsyncSnapshot<Trip> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.checklists.length > 0) {
              _sortList(snapshot.data);
              return ListView.builder(
                itemBuilder: (BuildContext __context, int index) {
                  Checklist checklist = snapshot.data.checklists[index];
                  return ChecklistCard(
                    key: Key(checklist.id.toString()),
                    checklist: checklist,
                    coordinates: snapshot.data.destinationCoordinates,
                  );
                },
                itemCount: snapshot.data.checklists.length,
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
              );
            }
            return Column(
              children: <Widget> [
                Container(
                  child: Text('Nenhuma checklist encontrada.'),
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
        _loadChecklists();
      },
    );
  }

  void _loadChecklists() async {
    widget.trip.checklists = await _dbHelper.getChecklists(widget.trip.id);
    _listController.sink.add(widget.trip);
  }

  void _onChecklistItemChecked(Map<String, dynamic> data) {
    _listController.sink.add(widget.trip);
  }

  void _onChecklistAdded(Map<String, dynamic> data) {
    widget.trip.addChecklist(data['checklist']);
    _listController.sink.add(widget.trip);
  }

  void _onChecklistRemoved(Map<String, dynamic> data) {
    widget.trip.removeChecklist(data['checklist'].id);
    _listController.sink.add(widget.trip);
  }

  void _sortList(Trip trip) {
    trip.checklists.sort((Checklist a, Checklist b) {
      double aPercentage = a.totalItems > 0 ? a.checkedItems / a.totalItems : 0;
      double bPercentage = b.totalItems > 0 ? b.checkedItems / b.totalItems : 0;
      if (aPercentage > bPercentage) {
        return 1;
      }
      if (bPercentage > aPercentage) {
        return -1;
      }
      return a.name.compareTo(b.name);
    });
  }
}