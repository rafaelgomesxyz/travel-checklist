import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/Trip.dart';

class TripFormScreen extends StatefulWidget {
  final Trip trip;
  final String template;

  TripFormScreen({ Key key, this.trip, this.template }) : super(key: key);

  @override
  _TripFormScreenState createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  bool _isCreating = true;
  String _title = '';
  String _template = '';

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      this._title = 'Editar - ${widget.trip.title}';
    } else {
      this._isCreating = false;
      if (widget.template != null) {
        this._template = widget.template;
        this._title = 'Criar Viagem - ${this._template}';
      } else {
        this._template = 'Blank';
        this._title = 'Criar Viagem';
      }
    }
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {} ),
        ],
      ),
      body: Center(),
    );
  }
}