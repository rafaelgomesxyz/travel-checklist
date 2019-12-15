import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistItemList.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/screens/ChecklistFormScreen.dart';
import 'package:travel_checklist/screens/ChecklistItemFormScreen.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

class ChecklistScreen extends StatefulWidget {
  final Checklist checklist;
  final String coordinates;

  ChecklistScreen({ Key key, this.checklist, this.coordinates }) : super(key: key);

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  Checklist _checklist;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    setState(() {
      _checklist = widget.checklist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_checklist.name),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // TODO: resetar
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget> [
          Container(
            child: Text(
              'ITENS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
          ),
          Expanded(
            child: ChecklistItemList(checklist: widget.checklist),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        backgroundColor: Colors.white,
        closeManually: false,
        curve: Curves.bounceIn,
        elevation: 8.0,
        foregroundColor: Colors.black,
        heroTag: 'speed-dial-hero-tag',
        marginBottom: 20,
        marginRight: 18,
        onClose: () {},
        onOpen: () {},
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        shape: CircleBorder(),
        tooltip: 'Speed Dial',
        visible: true,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.red,
            child: Icon(Icons.delete),
            label: 'Deletar Checklist',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              await _dbHelper.deleteChecklist(_checklist.id);
              _eDispatcher.emit(EventDispatcher.eventChecklistRemoved, { 'checklist': _checklist });
              Navigator.pop(context);
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: Icon(Icons.edit),
            label: 'Editar Checklist',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistFormScreen(checklist: widget.checklist)));
              setState(() {
                _checklist = widget.checklist;
              });
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: Icon(Icons.check_box),
            label: 'Criar Item',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistItemFormScreen(checklist: widget.checklist, coordinates: widget.coordinates)));
            },
          ),
        ],
      ),
    );
  }
}