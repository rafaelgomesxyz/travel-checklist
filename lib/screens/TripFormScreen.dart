import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/place_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/screens/MapScreen.dart';
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
  DateFormat _dateFormat;
  bool _isCreating = true;
  String _title = '';
  String _destinationCoordinates = '';
  String _template = '';

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _timestampController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    _dateFormat = DateFormat.yMd('pt_BR').add_Hm();
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
      _title = 'Editar Viagem - ${widget.trip.name}';
      _nameController.text = widget.trip.name;
      _destinationController.text = widget.trip.destination;
      _destinationCoordinates = widget.trip.destinationCoordinates;
      _timestampController.text = _dateFormat.format(DateTime.fromMillisecondsSinceEpoch(widget.trip.timestamp));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _timestampController.dispose();
    super.dispose();
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
                controller: _nameController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 15.0),
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  labelText: 'Nome',
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.left,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'O nome não pode ser vazio!';
                  }
                  return null;
                },
              ),
              TextFormField(
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Selecione um destino!';
                  }
                  if (_destinationCoordinates.isEmpty) {
                    return 'Destino inválido!';
                  }
                  return null;
                },
              ),
              FlatButton.icon(
                color: Colors.blueAccent,
                textColor: Colors.white,
                icon: Icon(Icons.place),
                label: Text('Selecionar Destino'),
                onPressed: () async {
                  double latitude = 0.0;
                  double longitude = 0.0;
                  if (_destinationCoordinates.isNotEmpty) {
                    List<String> latlng = _destinationCoordinates.split(',');
                    latitude = double.parse(latlng[0]);
                    longitude = double.parse(latlng[1]);
                  }
                  LocationResult result = await Navigator.push(context, MaterialPageRoute(
                    builder: (_context) => MapScreen(
                      initialLocation: _destinationCoordinates.isNotEmpty ? LatLng(latitude, longitude) : null,
                    ),
                  ));
                  if (result != null) {
                    latitude = result.latLng.latitude;
                    longitude = result.latLng.longitude;
                    setState(() {
                      _destinationController.text = result.name;
                      _destinationCoordinates = '$latitude,$longitude';
                    });
                  }
                },
              ),
              TextFormField(
                controller: _timestampController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 15.0),
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  labelText: 'Data',
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.left,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Selecione uma data!';
                  }
                  try {
                    _dateFormat.parse(_timestampController.text);
                  } catch (err) {
                    return 'Data inválida!';
                  }
                  return null;
                },
              ),
              FlatButton.icon(
                color: Colors.blueAccent,
                textColor: Colors.white,
                icon: Icon(Icons.calendar_today),
                label: Text('Selecionar Data'),
                onPressed: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    onConfirm: (date) {
                      setState(() {
                        _timestampController.text = _dateFormat.format(date);
                      });
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.pt
                  );
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
          if (_formKey.currentState.validate()) {
            if (_isCreating) {
              Trip trip = Trip();
              trip.name = _nameController.text;
              trip.destination = _destinationController.text;
              trip.destinationCoordinates = _destinationCoordinates;
              trip.timestamp = _dateFormat
                .parse(_timestampController.text)
                .millisecondsSinceEpoch;
              trip.id = await _dbHelper.insertTrip(trip);
              _eDispatcher.emit(EventDispatcher.eventTripAdded, { 'trip': trip});
            } else {
              widget.trip.name = _nameController.text;
              widget.trip.destination = _destinationController.text;
              widget.trip.destinationCoordinates = _destinationCoordinates;
              widget.trip.timestamp = _dateFormat
                .parse(_timestampController.text)
                .millisecondsSinceEpoch;
              await _dbHelper.updateTrip(widget.trip);
            }
            Navigator.pop(context);
          }
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
