import 'package:flutter/material.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/screens/ChecklistFormScreen.dart';
import 'package:travel_checklist/screens/ChecklistScreen.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/enums.dart';

class ChecklistCard extends StatefulWidget {
  final Checklist checklist;
  final String coordinates;

  ChecklistCard({ Key key, this.checklist, this.coordinates }) : super(key: key);

  @override
  _ChecklistCardState createState() => _ChecklistCardState();
}

class _ChecklistCardState extends State<ChecklistCard> {
  Checklist _checklist;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      _checklist = widget.checklist;
    });
  }

  @override
  build(BuildContext context) {
    Color progressColor;
    Color backgroundColor;
    double percentage = _checklist.totalItems > 0 ? _checklist.checkedItems / _checklist.totalItems : 0;
    if (percentage < 0.3) {
      progressColor = Colors.redAccent;
      backgroundColor = Color(0x55FF5252);
    } else if (percentage < 0.6) {
      progressColor = Colors.orangeAccent;
      backgroundColor = Color(0x55FFAB40);
    } else if (percentage < 1.0) {
      progressColor = Colors.blueAccent;
      backgroundColor = Color(0x55448AFF);
    } else {
      progressColor = Colors.green;
      backgroundColor = Colors.green;
    }
    return GestureDetector(
      child: Card(
        child: Column(
          children: <Widget> [
            Container(
              child: Row(
                children: <Widget> [
                  Row(
                    children: <Widget> [
                      Visibility(
                        child: Icon(Icons.location_on),
                        visible: _checklist.forPlaces,
                      ),
                      Text(
                        _checklist.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text('${_checklist.checkedItems}/${_checklist.totalItems}'),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              padding: EdgeInsets.all(10.0),
            ),
            LinearProgressIndicator(
              value: percentage,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: backgroundColor,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.all(10.0),
      ),
      onLongPress: () {
        _openChecklistMenu();
      },
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistScreen(checklist: widget.checklist, coordinates: widget.coordinates)));
      },
    );
  }

  void _openChecklistMenu() {
    showDialog(
      builder: (BuildContext _context) => SimpleDialog(
        children: <Widget> [
          FlatButton.icon(
            icon: Icon(
              Icons.edit,
              color: Colors.green,
              size: 20.0
            ),
            label: Text('Editar Checklist'),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistFormScreen(checklist: widget.checklist)));
              Navigator.pop(_context);
              setState(() {
                _checklist = widget.checklist;
              });
            },
            padding: EdgeInsets.all(0.0),
          ),
          FlatButton.icon(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 20.0
            ),
            label: Text('Deletar Checklist'),
            onPressed: () {
              _deleteChecklist();
            },
            padding: EdgeInsets.all(0.0),
          ),
        ],
        contentPadding: EdgeInsets.all(0.0),
      ),
      context: context,
    );
  }

  void _deleteChecklist() {
    showDialog(
      builder: (BuildContext _context) => AlertDialog(
        actions: <Widget> [
          FlatButton(
            child: Text('Não'),
            onPressed: () {
              Navigator.pop(_context);
            },
          ),
          FlatButton(
            child: Text('Sim'),
            onPressed: () async {
              await _dbHelper.deleteChecklist(_checklist.id);
              _eDispatcher.emit(Event.ChecklistRemoved, { 'checklist': _checklist });
              Navigator.pop(_context);
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('Tem certeza que deseja deletar essa checklist?'),
      ),
      context: context,
    );
  }
}