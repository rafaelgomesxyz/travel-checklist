import 'package:flutter/material.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/screens/ChecklistScreen.dart';

class ChecklistCard extends StatefulWidget {
  final Checklist checklist;
  final String coordinates;

  ChecklistCard({ Key key, this.checklist, this.coordinates }) : super(key: key);

  @override
  _ChecklistCardState createState() => _ChecklistCardState();
}

class _ChecklistCardState extends State<ChecklistCard> {
  Checklist _checklist;

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
                  Text(
                    _checklist.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
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
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistScreen(checklist: widget.checklist, coordinates: widget.coordinates)));
      },
    );
  }
}