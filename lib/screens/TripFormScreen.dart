import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/services/DatabaseHelper.dart';
import '../models/Trip.dart';

class TripFormScreen extends StatefulWidget {
  final Trip trip;
  final String template;

  TripFormScreen({Key key, this.trip, this.template}) : super(key: key);

  @override
  _TripFormScreenState createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  bool _isCreating = true;
  String _title = '';
  String _template = '';

  final _dbHelper = DatabaseHelper.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      this._isCreating = false;
      this._title = 'Editar - ${widget.trip.title}';
      this._titleController.text = widget.trip.title;
      this._destinationController.text = widget.trip.destination;
      this._dateController.text = widget.trip.timestamp.toString();
    } else {
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
          IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.flight,
                size: 50,
              ),
              TextFormField(
                controller: this._titleController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 15.0),
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  labelText: 'Título',
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.left,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'O título não pode ser vazio!';
                  }
                },
              ),
              TextFormField(
                //enabled: false,
                controller: this._destinationController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 15.0),
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  labelText: 'Destino',
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.left,
              ),
              FlatButton.icon(
                color: Colors.blueAccent,
                textColor: Colors.white,
                icon: Icon(Icons.place),
                label: Text('Escolher Destino'),
                onPressed: () {
                  // TODO: implement map
                },
              ),
              TextFormField(
                //enabled: false,
                controller: this._dateController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 15.0),
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  labelText: 'Data',
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.left,
              ),
              FlatButton.icon(
                color: Colors.blueAccent,
                textColor: Colors.white,
                icon: Icon(Icons.calendar_today),
                label: Text('Escolher Data'),
                onPressed: () {
                  // TODO: implement date
                },
              ),
              this._buildButton(),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
          key: this._formKey,
        ),
        padding: EdgeInsets.all(20.0),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      child: RaisedButton(
        child: Text(
          this._isCreating ? 'Criar' : 'Editar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        color: Colors.blueAccent,
        onPressed: () async {
          Map<String, dynamic> trip = {
            DatabaseHelper.columnTitle: this._titleController.text,
            DatabaseHelper.columnTimestamp: int.parse(this._dateController.text),
            DatabaseHelper.columnDestination: this._destinationController.text,
          };

          if (this._isCreating) {
            await this._dbHelper.insert(DatabaseHelper.tableTrip, trip);
          } else {
            trip[DatabaseHelper.columnId] = widget.trip.id;
            await this._dbHelper.update(DatabaseHelper.tableTrip, trip);
          }

          Navigator.pop(context);
        },
      ),
      height: 50.0,
      margin: EdgeInsets.only(
        bottom: 20.0,
        top: 20.0,
      ),
    );
  }
}
