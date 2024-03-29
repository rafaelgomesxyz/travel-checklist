import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/AppDrawer.dart';
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import 'package:travel_checklist/enums.dart';
import 'package:travel_checklist/services/WillPopDialogs.dart';

class ChecklistFormScreen extends StatefulWidget {
  final Checklist checklist;
  final int trip;

  ChecklistFormScreen({Key key, this.checklist, this.trip}) : super(key: key);

  @override
  _ChecklistFormScreenState createState() => _ChecklistFormScreenState();
}

class _ChecklistFormScreenState extends State<ChecklistFormScreen> {
  bool _hasModified = false;
  bool _isCreating = true;
  String _title = '';
  bool _forPlaces = false;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    _resetFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _resetFields();
              }
            ),
          ],
        ),
        drawer: AppDrawer(currentScreen: Screen.ChecklistForm),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.playlist_add_check,
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
                Visibility(
                  child: Row(
                    children: <Widget> [
                      Checkbox(
                        onChanged: (bool isChecked) {
                          _hasModified = true;
                          setState(() {
                            _forPlaces = isChecked;
                          });
                        },
                        value: _forPlaces,
                      ),
                      Text(
                        'Criar checklist para lugares.',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  visible: _isCreating,
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
              Checklist checklist = Checklist();
              checklist.trip = widget.trip;
              checklist.name = _nameController.text;
              checklist.forPlaces = _forPlaces;
              checklist.id = await _dbHelper.insertChecklist(checklist);
              _eDispatcher.emit(Event.ChecklistAdded, { 'checklist': checklist });
            } else {
              widget.checklist.name = _nameController.text;
              widget.checklist.forPlaces = _forPlaces;
              await _dbHelper.updateChecklist(widget.checklist);
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
      if (widget.checklist == null) {
        _isCreating = true;
        _title = 'Criar Checklist';
        _nameController.text = '';
        _forPlaces = false;
      } else {
        _isCreating = false;
        _title = 'Editar Checklist - ${widget.checklist.name}';
        _nameController.text = widget.checklist.name;
        _forPlaces = widget.checklist.forPlaces;
      }
    });
  }
}
