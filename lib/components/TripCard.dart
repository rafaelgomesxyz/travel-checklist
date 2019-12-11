import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/screens/TripScreen.dart';

class TripCard extends StatefulWidget {
  final Trip trip;

  TripCard({ Key key, this.trip }) : super(key: key);

  @override
  _TripCardState createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  Trip _trip;

  @override
  void initState() {
    super.initState();
    setState(() {
      _trip = widget.trip;
    });
  }

  @override
  build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: <Widget> [
            Container(
              child: Row(
                children: <Widget> [
                  Text(
                    _trip.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(_trip.timestamp), locale: 'pt_BR', allowFromNow: true),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
            ),
            Container(
              child: Row(
                children: <Widget> [
                  Icon(Icons.flight),
                  Text(_trip.destination),
                ],
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.all(10.0),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TripScreen(trip: widget.trip)));
      },
    );
  }
}