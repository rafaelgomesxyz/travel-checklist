import 'package:flutter/material.dart';
import 'package:travel_checklist/models/ChecklistItem.dart';

class ChecklistItemCard extends StatefulWidget {
  final String title;
  final ChecklistItem checklistitem;

  ChecklistItemCard({Key key, this.title, this.checklistitem}) : super(key: key);

  @override
  _ChecklistItemCardState createState() => _ChecklistItemCardState(this.checklistitem);
}

class _ChecklistItemCardState extends State<ChecklistItemCard>{

  final ChecklistItem checklistitem;
  _ChecklistItemCardState(this.checklistitem);

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