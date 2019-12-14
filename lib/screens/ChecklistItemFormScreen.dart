import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/models/ChecklistItem.dart';
import 'package:travel_checklist/screens/MapScreen.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

class ChecklistItemFormScreen extends StatefulWidget {
  final ChecklistItem item;
  final int checklist;
  final String coordinates;

  ChecklistItemFormScreen({ Key key, this.item, this.checklist, this.coordinates }) : super(key: key);

  @override
  _ChecklistItemFormScreenState createState() => _ChecklistItemFormScreenState();
}

class _ChecklistItemFormScreenState extends State<ChecklistItemFormScreen> {
  bool _isCreating = true;
  String _title = '';
  String _coordinates = '';
  bool _isPlace = false;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    if (widget.item == null) {
      _title = 'Criar Item';
      _coordinates = widget.coordinates;
    } else {
      _isCreating = false;
      _title = 'Editar Item - ${widget.item.name}';
      _nameController.text = widget.item.name;
      _coordinates = widget.item.coordinates;
      _isPlace = _coordinates.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
                    if (_isPlace) {
                      return 'Selecione um lugar!';
                    } else {
                      return 'O nome não pode ser vazio!';
                    }
                  }
                  return null;
                },
              ),
              Row(
                children: <Widget> [
                  Checkbox(
                    onChanged: (bool isChecked) {
                      setState(() {
                        _isPlace = isChecked;
                        _nameController.text = '';
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
                child: FlatButton.icon(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.location_on),
                  label: Text('Selecionar Lugar'),
                  onPressed: () async {
                    double latitude = 0.0;
                    double longitude = 0.0;
                    if  (_isPlace && _coordinates.isNotEmpty) {
                      List<String> latlng = _coordinates.split(',');
                      latitude = double.parse(latlng[0]);
                      longitude = double.parse(latlng[1]);
                    }
                    LocationResult result = await Navigator.push(context, MaterialPageRoute(
                      builder: (_context) => MapScreen(
                        initialLocation: _isPlace && _coordinates.isNotEmpty ? LatLng(latitude, longitude) : null,
                      ),
                    ));
                    if (result != null) {
                      latitude = result.latLng.latitude;
                      longitude = result.latLng.longitude;
                      setState(() {
                        _nameController.text = result.name;
                        _coordinates = '$latitude,$longitude';
                      });
                    }
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
          if (_formKey.currentState.validate()) {
            if (_isCreating) {
              ChecklistItem item = ChecklistItem();
              item.checklist = widget.checklist;
              item.name = _nameController.text;
              item.coordinates = _coordinates;
              item.id = await _dbHelper.insertChecklistItem(item);
              _eDispatcher.emit(EventDispatcher.eventChecklistItemAdded, { 'item': item});
            } else {
              widget.item.name = _nameController.text;
              widget.item.coordinates = _coordinates;
              await _dbHelper.updateChecklistItem(widget.item);
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
