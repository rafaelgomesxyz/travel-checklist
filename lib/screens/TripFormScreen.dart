import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

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
  final _eDispatcher = EventDispatcher.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _timestampController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    if (widget.trip == null) {
      if (widget.template != null) {
        _template = widget.template;
        _title = 'Criar Viagem - ${_template}';
      } else {
        _template = 'Blank';
        _title = 'Criar Viagem';
      }
    } else {
      _isCreating = false;
      _title = 'Editar Viagem - ${widget.trip.title}';
      _titleController.text = widget.trip.title;
      _timestampController.text = widget.trip.timestamp.toString();
      _destinationController.text = widget.trip.destination;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // TODO: resetar
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget> [
              Icon(
                Icons.flight,
                size: 50,
              ),
              TextFormField(
                controller: _titleController,
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
                controller: _timestampController,
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
              TextFormField(
                //enabled: false,
                controller: _destinationController,
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
              _buildButton(),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
          key: _formKey,
        ),
        padding: EdgeInsets.all(20.0),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      child: RaisedButton(
        child: Text(
          _isCreating ? 'Criar' : 'Editar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        color: Colors.blueAccent,
        onPressed: () async {
          if (_isCreating) {
            Trip trip = Trip();
            trip.title = _titleController.text;
            trip.timestamp = int.parse(_timestampController.text);
            trip.destination = _destinationController.text;
            trip.id = await _dbHelper.insertTrip(trip);
            _eDispatcher.emit(EventDispatcher.eventTripAdded, { 'trip': trip });
          } else {
            widget.trip.title = _titleController.text;
            widget.trip.timestamp = int.parse(_timestampController.text);
            widget.trip.destination = _destinationController.text;
            await _dbHelper.updateTrip(widget.trip);
            _eDispatcher.emit('${EventDispatcher.eventTripEdited}_${widget.trip.id}', { 'trip': widget.trip });
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
