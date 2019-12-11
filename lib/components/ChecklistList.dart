import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistCard.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

class ChecklistList extends StatefulWidget {
  final int trip;

  ChecklistList({ Key key, this.trip }) : super(key: key);

  @override
  _ChecklistListState createState() => _ChecklistListState();
}

class _ChecklistListState extends State<ChecklistList> {
  int _trip = 0;
  List<Checklist> _checklists = [];

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    this._trip = widget.trip;
    this._resetState(true);
    this._eDispatcher.listen(EventDispatcher.eventChecklist, this._resetState);
  }

  @override
  build(BuildContext context) {
    if (this._checklists.length > 0) {
      this._sortList();
      return RefreshIndicator(
        child: ListView(
          children: this._checklists.map((Checklist checklist) => ChecklistCard(checklist)).toList(),
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
            child: Text('Nenhuma checklist encontrada.'),
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
    List<Map<String, dynamic>> dbChecklists = await this._dbHelper.rawQuery('SELECT * FROM ${DatabaseHelper.tableChecklist} WHERE trip = ${this._trip}');
    List<Checklist> checklists = [];

    for (Map<String, dynamic> dbChecklist in dbChecklists) {
      Checklist checklist = Checklist(dbChecklist[DatabaseHelper.columnId]);
      checklist.title = dbChecklist[DatabaseHelper.columnTitle];
      checklists.add(checklist);
    }

    setState(() {
      this._checklists = checklists;
    });
  }

  void _sortList() {
    this._checklists.sort((Checklist a, Checklist b) => a.title.compareTo(b.title));
  }
}