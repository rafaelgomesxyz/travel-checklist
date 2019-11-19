import 'dart:math';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../components/TripCard.dart';
import '../models/Trip.dart';
import 'TripsScreen.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  
  HomeScreen({ Key key, this.title }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip> _trips;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    this._resetState();
  }

  // Generate random trips until we have a database.
  void _resetState() {
    List<Trip> trips = [];
    Random random = new Random();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 15; i++) {
      int total = random.nextInt(9) + 1;
      int current = random.nextInt(total) + 1;
      Trip trip = Trip(i);
      trip.title = 'Viagem ${i + 1}';
      trip.timestamp = now + current * 1000 * 60 * 60 * 60;
      trip.progress.current = current;
      trip.progress.total = total;
      trips.add(trip);
    }
    setState(() {
      this._trips = trips;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(this._trips.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: this._resetState ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'PRÓXIMAS VIAGENS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            ),
            ...(this._trips.length > 0 ? this._getList() : [Text('Nothing')]),
            Container(
              child: ButtonTheme(
                minWidth: 100.0,
                child: OutlineButton(
                  child: Text('VER TODAS'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TripsScreen(title: widget.title)));
                  },
                ),
              ),
              alignment: Alignment.center,
            ),
            Container(
              child: Text(
                'CRIAR VIAGEM',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            ),
            Container(
              child: ButtonTheme(
                minWidth: 200.0,
                child: FlatButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text('PRAIA'),
                  onPressed: () { },
                ),
              ),
              alignment: Alignment.center,
            ),
            Container(
              child: ButtonTheme(
                minWidth: 200.0,
                child: FlatButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text('CAMPO'),
                  onPressed: () { },
                ),
              ),
              alignment: Alignment.center,
            ),
            Container(
              child: ButtonTheme(
                minWidth: 200.0,
                child: FlatButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text('CIDADE'),
                  onPressed: () { },
                ),
              ),
              alignment: Alignment.center,
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }

  Widget buildList() {
    return RefreshIndicator(
      child: ListView(
        children: this._getList(),
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
        //physics: AlwaysScrollableScrollPhysics(),
      ),
      onRefresh: () async {
        this._resetState();
        return;
      },
    );
  }

  List<Widget> _getList() {
    this._trips.sort((Trip a, Trip b) {
      if (a.progress.current == a.progress.total) {
        return 1;
      }
      if (a.timestamp > b.timestamp) {
        return 1;
      }
      if (a.timestamp < b.timestamp) {
        return -1;
      }
      double aPercentage = a.progress.current / a.progress.total;
      double bPercentage = b.progress.current / b.progress.total;
      if (aPercentage > bPercentage) {
        return 1;
      }
      if (aPercentage < bPercentage) {
        return -1;
      }
      return 0;
    });
    this._trips.removeRange(3, this._trips.length);
    return this._trips.map((Trip trip) => TripCard(trip)).toList();
  }
}