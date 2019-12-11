import 'package:flutter/material.dart';
import 'package:travel_checklist/components/TripList.dart';
import 'package:travel_checklist/screens/TripFormScreen.dart';
import 'TripListScreen.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  
  HomeScreen({ Key key, this.title }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {} ),
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
            Expanded(
              child: TripList(numToShow: 3),
            ),
            Container(
              child: ButtonTheme(
                minWidth: 100.0,
                child: OutlineButton(
                  child: Text('VER TODAS'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TripListScreen(title: widget.title)));
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
                child: FlatButton.icon(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.beach_access),
                  label: Text('PRAIA'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: 'PRAIA')));
                  },
                ),
              ),
              alignment: Alignment.center,
            ),
            Container(
              child: ButtonTheme(
                minWidth: 200.0,
                child: FlatButton.icon(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.local_florist),
                  label: Text('CAMPO'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: 'CAMPO')));
                  },
                ),
              ),
              alignment: Alignment.center,
            ),
            Container(
              child: ButtonTheme(
                minWidth: 200.0,
                child: FlatButton.icon(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.location_city),
                  label: Text('CIDADE'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TripFormScreen(template: 'CIDADE')));
                  },
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
}