import 'package:flutter/material.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/screens/ChecklistScreen.dart';

class ChecklistCard extends StatelessWidget {
  final Checklist checklist;

  ChecklistCard(this.checklist);

  @override
  build(BuildContext context) {
    Color progressColor;
    Color backgroundColor;
    double percentage = this.checklist.progress.total > 0 ? this.checklist.progress.current / this.checklist.progress.total : 0;
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
                    this.checklist.title,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistScreen(checklist: this.checklist, )));
      },
    );
  }
}