import 'package:flutter/material.dart';
import 'package:travel_checklist/models/ChecklistItem.dart';

import 'ChecklistItemCard.dart';

class ChecklistItemList extends StatefulWidget {

  ChecklistItemList({ Key key }) : super(key: key);

  @override
  _ChecklistItemListState createState() => _ChecklistItemListState();
}

class _ChecklistItemListState extends State<ChecklistItemList>{

  List<ChecklistItem> _checklistitens;

  void initState() {
    super.initState();
  }

  @override
  build(BuildContext context) {
    return RefreshIndicator(
      child: ListView(
        //children: this._checklistitens.map((ChecklistItem checklistitem) => ChecklistItemCard(checklistitem)).toList(),
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
        //physics: AlwaysScrollableScrollPhysics(),
      ),
      onRefresh: () async {
        //this._resetState();
        return;
      },
    );
  }
}
