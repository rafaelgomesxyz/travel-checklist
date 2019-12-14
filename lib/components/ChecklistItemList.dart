import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistItemCard.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/models/ChecklistItem.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

class ChecklistItemList extends StatefulWidget {
  final Checklist checklist;

  ChecklistItemList({ Key key, this.checklist }) : super(key: key);

  @override
  _ChecklistItemListState createState() => _ChecklistItemListState();
}

class _ChecklistItemListState extends State<ChecklistItemList> {
  Checklist _checklist;

  StreamSubscription _itemAddedSubscription;
  StreamSubscription _itemCheckedSubscription;
  StreamSubscription _itemRemovedSubscription;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    _itemAddedSubscription = _eDispatcher.listen(EventDispatcher.eventChecklistItemAdded, _onItemAdded);
    _itemCheckedSubscription = _eDispatcher.listen(EventDispatcher.eventChecklistItemChecked, _onItemChecked);
    _itemRemovedSubscription = _eDispatcher.listen(EventDispatcher.eventChecklistItemRemoved, _onItemRemoved);
    _loadItems();
  }

  @override
  void dispose() {
    _itemAddedSubscription.cancel();
    _itemCheckedSubscription.cancel();
    _itemRemovedSubscription.cancel();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    if (_checklist != null && _checklist.items.length > 0) {
      _sortList();
      return RefreshIndicator(
        child: ListView(
          children: _checklist.items.map((ChecklistItem item) => ChecklistItemCard(item: item)).toList(),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
        ),
        onRefresh: () async {
          _loadItems();
          return;
        },
      );
    }
    return RefreshIndicator(
      child: Column(
        children: <Widget> [
          Container(
            child: Text('Nenhum item encontrado.'),
            alignment: Alignment.center,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      onRefresh: () async {
        _loadItems();
        return;
      },
    );
  }

  void _loadItems() async {
    widget.checklist.items = await _dbHelper.getChecklistItems(widget.checklist.id);
    setState(() {
      _checklist = widget.checklist;
    });
  }

  void _onItemAdded(Map<String, dynamic> data) {
    if (mounted) {
      widget.checklist.addItem(data['item']);
      setState(() {
        _checklist = widget.checklist;
      });
    }
  }

  void _onItemChecked(Map<String, dynamic> data) {
    if (mounted) {
      if (data['item'].isChecked) {
        widget.checklist.increaseCheckedItems();
      } else {
        widget.checklist.decreaseCheckedItems();
      }
      setState(() {
        _checklist = widget.checklist;
      });
    }
  }

  void _onItemRemoved(Map<String, dynamic> data) {
    if (mounted) {
      widget.checklist.removeItem(data['item'].id);
      setState(() {
        _checklist = widget.checklist;
      });
    }
  }

  void _sortList() {
    _checklist.items.sort((ChecklistItem a, ChecklistItem b) {
      if (a.isChecked && !b.isChecked) {
        return 1;
      }
      if (!a.isChecked && b.isChecked) {
        return -1;
      }
      return a.name.compareTo(b.name);
    });
  }
}