import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/place_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/AppDrawer.dart';
import 'package:travel_checklist/models/Trip.dart';
import 'package:travel_checklist/screens/MapScreen.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/enums.dart';
import 'package:travel_checklist/services/NotificationManager.dart';
import 'package:travel_checklist/services/WillPopDialogs.dart';

class TripFormScreen extends StatefulWidget {
  final Trip trip;
  final Template template;

  TripFormScreen({Key key, this.trip, this.template}) : super(key: key);

  @override
  _TripFormScreenState createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  bool _hasModified = false;
  DateFormat _dateFormat;
  bool _isCreating = true;
  String _title = '';
  String _destinationCoordinates = '';
  DateTime _departureDate;
  DateTime _returnDate;
  DateTime _notificationDate;
  bool _doNotify = false;
  Template _template = Template.Outro;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _departureTimestampController = TextEditingController();
  TextEditingController _returnTimestampController = TextEditingController();
  TextEditingController _notificationHoursController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    _dateFormat = DateFormat.yMd('pt_BR').add_Hm();
    _resetFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _departureTimestampController.dispose();
    _returnTimestampController.dispose();
    _notificationHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _resetFields();
              },
            ),
          ],
        ),
        drawer: AppDrawer(currentScreen: Screen.TripForm),
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
                  onChanged: (String text) {
                    _hasModified = true;
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
                  onChanged: (String text) {
                    _hasModified = true;
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
                      _hasModified = true;
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
                  controller: _departureTimestampController,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 15.0),
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    labelText: 'Data de Ida',
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
                      _dateFormat.parse(_departureTimestampController.text);
                    } catch (err) {
                      return 'Data inválida!';
                    }
                    return null;
                  },
                  onChanged: (String text) {
                    _hasModified = true;
                  },
                ),
                FlatButton.icon(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.calendar_today),
                  label: Text('Selecionar Data'),
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      currentTime: _departureDate.millisecondsSinceEpoch <= now.millisecondsSinceEpoch ? now.add(Duration(minutes: 1)) : _departureDate,
                      locale: LocaleType.pt,
                      minTime: now,
                      onConfirm: (date) {
                        _hasModified = true;
                        setState(() {
                          _departureDate = date;
                          _departureTimestampController.text = _dateFormat.format(_departureDate);
                          if (_returnDate.millisecondsSinceEpoch <= _departureDate.millisecondsSinceEpoch) {
                            _returnDate = _departureDate.add(Duration(minutes: 2));
                          }
                        });
                      },
                      showTitleActions: true,
                    );
                  },
                ),
                TextFormField(
                  controller: _returnTimestampController,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 15.0),
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    labelText: 'Data de Volta',
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
                      _dateFormat.parse(_returnTimestampController.text);
                    } catch (err) {
                      return 'Data inválida!';
                    }
                    return null;
                  },
                  onChanged: (String text) {
                    _hasModified = true;
                  },
                ),
                FlatButton.icon(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.calendar_today),
                  label: Text('Selecionar Data'),
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      currentTime: _returnDate,
                      locale: LocaleType.pt,
                      minTime: _departureDate.add(Duration(minutes: 1)),
                      onConfirm: (date) {
                        _hasModified = true;
                        setState(() {
                          _returnDate = date;
                          _returnTimestampController.text = _dateFormat.format(_returnDate);
                        });
                      },
                      showTitleActions: true,
                    );
                  },
                ),
                Row(
                  children: <Widget> [
                    Checkbox(
                      onChanged: (bool isChecked) {
                        _hasModified = true;
                        setState(() {
                          _doNotify = isChecked;
                        });
                      },
                      value: _doNotify,
                    ),
                    Text(
                      'Mostrar notificação.',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  child: Container(
                    child: Text('Quantas horas antes da viagem deseja receber a notificação?'),
                  ),
                  visible: _doNotify,
                ),
                Visibility(
                  child: TextFormField(
                    controller: _notificationHoursController,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 15.0),
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      labelText: 'Horas',
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.left,
                    validator: (value) {
                      if (!_doNotify) {
                        return null;
                      }
                      if (value.isEmpty) {
                        return 'Digite as horas!';
                      }
                      try {
                        int value = int.parse(_notificationHoursController.text);
                        if (value <= 0) {
                          return 'Horas inválidas!';
                        }
                        _notificationDate = _departureDate.subtract(Duration(hours: value));
                        if (_notificationDate.millisecondsSinceEpoch <= DateTime.now().millisecondsSinceEpoch) {
                          return 'A data da notificação deve estar no futuro.';
                        }
                      } catch (err) {
                        return 'Horas inválidas!';
                      }
                      return null;
                    },
                    onChanged: (String text) {
                      _hasModified = true;
                    },
                  ),
                  visible: _doNotify,
                ),
                _buildButton(),
              ],
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
            key: _formKey,
          ),
          padding: EdgeInsets.all(20.0),
        ),
      ),
      onWillPop: () => WillPopDialogs.instance.onWillPopForm(context, _hasModified),
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
              trip.departureTimestamp = _departureDate.millisecondsSinceEpoch;
              trip.returnTimestamp = _returnDate.millisecondsSinceEpoch;
              trip.notificationHours = _doNotify ? int.parse(_notificationHoursController.text) : 0;
              trip.id = await _dbHelper.insertTrip(trip, _template);
              _eDispatcher.emit(Event.TripAdded, { 'trip': trip});

              // Schedule notification.
              if (_doNotify) {
                await NotificationManager.instance.scheduleNotification(
                  trip.id,
                  'Tudo pronto para ${trip.name}?',
                  'Sua viagem começa em ${trip.notificationHours} hora${trip.notificationHours > 1 ? 's' : ''}!',
                  _notificationDate,
                );
              }
            } else {
              widget.trip.name = _nameController.text;
              widget.trip.destination = _destinationController.text;
              widget.trip.destinationCoordinates = _destinationCoordinates;
              widget.trip.departureTimestamp = _departureDate.millisecondsSinceEpoch;
              widget.trip.returnTimestamp = _returnDate.millisecondsSinceEpoch;
              widget.trip.notificationHours = _doNotify ? int.parse(_notificationHoursController.text) : 0;
              await _dbHelper.updateTrip(widget.trip);

              // Cancel previous notification and schedule new one.
              await NotificationManager.instance.cancelNotification(widget.trip.id);
              if (_doNotify) {
                await NotificationManager.instance.scheduleNotification(
                  widget.trip.id,
                  'Tudo pronto para ${widget.trip.name}?',
                  'Sua viagem começa em ${widget.trip.notificationHours} hora${widget.trip.notificationHours > 1 ? 's' : ''}!',
                  _notificationDate,
                );
              }
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

  void _resetFields() {
    _hasModified = false;
    setState(() {
      if (widget.trip == null) {
        _isCreating = true;
        if (widget.template != null) {
          _template = widget.template;
          _title = 'Criar Viagem - ${_template.toString().split('.').last}';
        } else {
          _template = Template.Outro;
          _title = 'Criar Viagem';
        }
        _nameController.text = '';
        _destinationController.text = '';
        _destinationCoordinates = '';
        _departureDate = DateTime.now().add(Duration(minutes: 1));
        _returnDate = _departureDate.add(Duration(minutes: 2));
        _departureTimestampController.text = '';
        _returnTimestampController.text = '';
        _notificationHoursController.text = '';
        _doNotify = false;
      } else {
        _isCreating = false;
        _template = Template.Outro;
        _title = 'Editar Viagem - ${widget.trip.name}';
        _nameController.text = widget.trip.name;
        _destinationController.text = widget.trip.destination;
        _destinationCoordinates = widget.trip.destinationCoordinates;
        _departureDate = DateTime.fromMillisecondsSinceEpoch(widget.trip.departureTimestamp);
        _returnDate = DateTime.fromMillisecondsSinceEpoch(widget.trip.returnTimestamp);
        _departureTimestampController.text = _dateFormat.format(_departureDate);
        _returnTimestampController.text = _dateFormat.format(_returnDate);
        _notificationHoursController.text = widget.trip.notificationHours.toString();
        _doNotify = widget.trip.notificationHours > 0;
      }
    });
  }
}
