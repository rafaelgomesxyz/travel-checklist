import 'package:flutter/material.dart';
import 'package:travel_checklist/models/ChecklistItem.dart';

class ChecklistCard extends StatefulWidget {
  final String title;
  final ChecklistItem checklistitem;

  ChecklistCard({Key key, this.title, this.checklistitem}) : super(key: key);

  @override
  _ChecklistCardState createState() => _ChecklistCardState(this.checklistitem);
}

class _ChecklistCardState extends State<ChecklistCard>{

  final ChecklistItem checklistitem;
  _ChecklistCardState(this.checklistitem);

  @override
  void initState() {
    super.initState();
  }

  @override
  build(BuildContext context){
    return Dismissible(
      child: Card(
          child: CheckboxListTile(
            title: Text(this.checklistitem.title),
            value: this.checklistitem.isChecked,
            onChanged:  (bool value){
              setState(() {
                this.checklistitem.uncheck();
              });
            },
          )
      ),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.remove_circle_outline),
      ), key: Key(this.checklistitem.id.toString()),
    );
  }
}