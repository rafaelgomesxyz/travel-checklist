import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/screens/TripScreen.dart';

class TripCard extends StatelessWidget {
  final Trip trip;

  TripCard(this.trip);

  @override
  build(BuildContext context) {
    double percentage = this.trip.progress.total > 0 ? this.trip.progress.current / this.trip.progress.total : 0;
    Color progressColor;
    Color backgroundColor;
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
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    this.trip.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(this.trip.timestamp), locale: 'pt_BR', allowFromNow: true),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.flight),
                  Text(this.trip.destination),
                ],
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => TripScreen(trip: this.trip)));
      },
    );
  }
}