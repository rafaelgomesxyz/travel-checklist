import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/models/ChecklistItem.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/secrets.dart';

class ChecklistItemFormScreen extends StatefulWidget {
  final ChecklistItem item;
  final int checklist;

  ChecklistItemFormScreen({ Key key, this.item, this.checklist }) : super(key: key);

  @override
  _ChecklistItemFormScreenState createState() => _ChecklistItemFormScreenState();
}

class _ChecklistItemFormScreenState extends State<ChecklistItemFormScreen> {
  bool _isCreating = true;
  String _title = '';
  bool _isPlace = false;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _coordinatesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    if (widget.item == null) {
      _title = 'Criar Item';
    } else {
      _isCreating = false;
      _title = 'Editar Item - ${widget.item.title}';
      _isPlace = true;
      _titleController.text = widget.item.title;
      _coordinatesController.text = widget.item.coordinates;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // TODO: resetar campos
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget> [
              Icon(
                Icons.check_box,
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
              Row(
                children: <Widget> [
                  Checkbox(
                    onChanged: (bool isChecked) {
                      setState(() {
                        _isPlace = isChecked;
                      });
                    },
                    value: _isPlace,
                  ),
                  Text(
                    'O item é um lugar.',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Visibility(
                child: TextFormField(
                  controller: _coordinatesController,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 15.0),
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    labelText: 'Coordenadas',
                  ),
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.left,
                  validator: (value) {
                    if (_isPlace && value.isEmpty) {
                      return 'Você precisa escolher um lugar!';
                    }
                  },
                ),
                visible: _isPlace,
              ),
              Visibility(
                child: FlatButton.icon(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.location_on),
                  label: Text('Escolher Lugar'),
                  onPressed: () async {
                    double latitude = 0.0;
                    double longitude = 0.0;
                    if  (_isPlace && _coordinatesController.text.isNotEmpty) {
                      List<String> latlng = _coordinatesController.text.split(',');
                      latitude = double.parse(latlng[0]);
                      longitude = double.parse(latlng[1]);
                    }
                    LocationResult result = await LocationPicker.pickLocation(
                      context,
                      googleMapsApiKey,
                      initialCenter: _isPlace ? LatLng(latitude, longitude) : null,
                      requiredGPS: false,
                    );
                    latitude = result.latLng.latitude;
                    longitude = result.latLng.longitude;
                    setState(() {
                      _coordinatesController.text = '$latitude,$longitude';
                    });
                  },
                ),
                visible: _isPlace,
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
            ChecklistItem item = ChecklistItem();
            item.checklist = widget.checklist;
            item.title = _titleController.text;
            item.coordinates = _coordinatesController.text;
            item.isPlace = _isPlace;
            item.id = await _dbHelper.insertChecklistItem(item);
            _eDispatcher.emit(EventDispatcher.eventChecklistItemAdded, { 'item': item });
          } else {
            widget.item.title = _titleController.text;
            widget.item.coordinates = _coordinatesController.text;
            widget.item.isPlace = _isPlace;
            await _dbHelper.updateChecklistItem(widget.item);
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
