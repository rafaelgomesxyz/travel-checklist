import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistItemCard.dart';
import 'package:travel_checklist/models/ChecklistItem.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

class ChecklistItemList extends StatefulWidget {
  final int checklist;

  ChecklistItemList({ Key key, this.checklist }) : super(key: key);

  @override
  _ChecklistItemListState createState() => _ChecklistItemListState();
}

class _ChecklistItemListState extends State<ChecklistItemList> {
  int _checklist = 0;
  List<ChecklistItem> _items = [];

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    this._checklist = widget.checklist;
    this._resetState(true);
    this._eDispatcher.listen(EventDispatcher.eventChecklistItem, this._resetState);
  }

  @override
  build(BuildContext context) {
    if (this._items.length > 0) {
      this._sortList();
      return RefreshIndicator(
        child: ListView(
          children: this._items.map((ChecklistItem item) => ChecklistItemCard(item)).toList(),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
        ),
        onRefresh: () async {
          this._resetState(true);
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
        this._resetState(true);
        return;
      },
    );
  }

  void _resetState(dynamic unused) async {
    List<Map<String, dynamic>> dbItems = await this._dbHelper.rawQuery('SELECT ci.id, ci.item, ci.checklist, ci.is_checked, i.title FROM ${DatabaseHelper.tableChecklistItem} AS ci INNER JOIN ${DatabaseHelper.tableItem} AS i ON ci.item = i.id WHERE checklist = ${this._checklist} GROUP BY ci.id');
    List<ChecklistItem> items = [];
    for (Map<String, dynamic> dbItem in dbItems) {
      ChecklistItem item = ChecklistItem(dbItem[DatabaseHelper.columnId]);
      item.title = dbItem[DatabaseHelper.columnTitle];
      item.isChecked = dbItem[DatabaseHelper.columnIsChecked] == 1 ? true : false;
      items.add(item);
    }

    setState(() {
      this._items = items;
    });
  }

  void _sortList() {
    this._items.sort((ChecklistItem a, ChecklistItem b) => a.title.compareTo(b.title));
  }
}