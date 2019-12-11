import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/Checklist.dart';

class ChecklistScreen extends StatefulWidget {
  final Checklist checklist;

  ChecklistScreen({ Key key, this.checklist }) : super(key: key);

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.checklist.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {} ),
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
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}