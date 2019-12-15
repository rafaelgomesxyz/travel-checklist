import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistItemCard.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/models/ChecklistItem.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/enums.dart';

class ChecklistItemList extends StatefulWidget {
  final Checklist checklist;

  ChecklistItemList({ Key key, this.checklist }) : super(key: key);

  @override
  _ChecklistItemListState createState() => _ChecklistItemListState();
}

class _ChecklistItemListState extends State<ChecklistItemList> {
  StreamController<Checklist> _listController = StreamController<Checklist>();
  StreamSubscription _itemAddedSubscription;
  StreamSubscription _itemCheckedSubscription;
  StreamSubscription _itemRemovedSubscription;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    _itemAddedSubscription = _eDispatcher.listen(Event.ChecklistItemAdded, _onItemAdded);
    _itemCheckedSubscription = _eDispatcher.listen(Event.ChecklistItemChecked, _onItemChecked);
    _itemRemovedSubscription = _eDispatcher.listen(Event.ChecklistItemRemoved, _onItemRemoved);
    _loadItems();
  }

  @override
  void dispose() {
    _listController.close();
    _itemAddedSubscription.cancel();
    _itemCheckedSubscription.cancel();
    _itemRemovedSubscription.cancel();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return RefreshIndicator(
      child: StreamBuilder(
        builder: (BuildContext _context, AsyncSnapshot<Checklist> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.items.length > 0) {
              _sortList(snapshot.data);
              return ListView.builder(
                itemBuilder: (BuildContext __context, int index) {
                  ChecklistItem item = snapshot.data.items[index];
                  return ChecklistItemCard(
                    key: Key(item.id.toString()),
                    item: item,
                  );
                },
                itemCount: snapshot.data.items.length,
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
              );
            }
            return Column(
              children: <Widget> [
                Container(
                  child: Text('Nenhum item encontrado.'),
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
        _loadItems();
      },
    );
  }

  void _loadItems() async {
    widget.checklist.items = await _dbHelper.getChecklistItems(widget.checklist.id);
    _listController.sink.add(widget.checklist);
  }

  void _onItemAdded(Map<String, dynamic> data) {
    widget.checklist.addItem(data['item']);
    _listController.sink.add(widget.checklist);
  }

  void _onItemChecked(Map<String, dynamic> data) {
    if (data['item'].isChecked) {
      widget.checklist.increaseCheckedItems();
    } else {
      widget.checklist.decreaseCheckedItems();
    }
    _listController.sink.add(widget.checklist);
  }

  void _onItemRemoved(Map<String, dynamic> data) {
    widget.checklist.removeItem(data['item'].id);
    _listController.sink.add(widget.checklist);
  }

  void _sortList(Checklist checklist) {
    checklist.items.sort((ChecklistItem a, ChecklistItem b) {
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