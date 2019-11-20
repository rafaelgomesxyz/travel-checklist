import 'package:flutter/material.dart';

class CheckListScreen extends StatefulWidget{
  final String title;
  CheckListScreen({ Key key, this.title }) : super(key: key);

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<CheckListScreen>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
    );
  }
}