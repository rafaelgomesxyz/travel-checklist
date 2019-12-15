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
  Trip _trip;

  StreamSubscription _checklistAddedSubscription;
  StreamSubscription _checklistRemovedSubscription;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    _checklistAddedSubscription = _eDispatcher.listen(Event.ChecklistAdded, _onChecklistAdded);
    _checklistRemovedSubscription = _eDispatcher.listen(Event.ChecklistRemoved, _onChecklistRemoved);
    _loadChecklists();
  }

  @override
  void dispose() {
    _checklistAddedSubscription.cancel();
    _checklistRemovedSubscription.cancel();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    if (_trip != null && _trip.checklists.length > 0) {
      _sortList();
      return RefreshIndicator(
        child: ListView(
          children: _trip.checklists.map((Checklist checklist) => ChecklistCard(checklist: checklist, coordinates: _trip.destinationCoordinates)).toList(),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
        ),
        onRefresh: () async {
          _loadChecklists();
          return;
        },
      );
    }
    return RefreshIndicator(
      child: Column(
        children: <Widget> [
          Container(
            child: Text('Nenhuma checklist encontrada.'),
            alignment: Alignment.center,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      onRefresh: () async {
        _loadChecklists();
        return;
      },
    );
  }

  void _loadChecklists() async {
    widget.trip.checklists = await _dbHelper.getChecklists(widget.trip.id);
    setState(() {
      _trip = widget.trip;
    });
  }

  void _onChecklistAdded(Map<String, dynamic> data) {
    if (mounted) {
      widget.trip.addChecklist(data['checklist']);
      setState(() {
        _trip = widget.trip;
      });
    }
  }

  void _onChecklistRemoved(Map<String, dynamic> data) {
    if (mounted) {
      widget.trip.removeChecklist(data['checklist'].id);
      setState(() {
        _trip = widget.trip;
      });
    }
  }

  void _sortList() {
    _trip.checklists.sort((Checklist a, Checklist b) => a.name.compareTo(b.name));
  }
}