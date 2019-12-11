import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/models/Checklist.dart';
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';

class ChecklistFormScreen extends StatefulWidget {
  final Checklist checklist;
  final int trip;

  ChecklistFormScreen({Key key, this.checklist, this.trip}) : super(key: key);

  @override
  _ChecklistFormScreenState createState() => _ChecklistFormScreenState();
}

class _ChecklistFormScreenState extends State<ChecklistFormScreen> {
  bool _isCreating = true;
  String _title = '';

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    if (widget.checklist == null) {
      _title = 'Criar Checklist';
    } else {
      _isCreating = false;
      _title = 'Editar Checklist - ${widget.checklist.title}';
      _titleController.text = widget.checklist.title;
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
              // TODO: implementar resetar
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.playlist_add_check,
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
            Checklist checklist = Checklist();
            checklist.trip = widget.trip;
            checklist.title = _titleController.text;
            checklist.id = await _dbHelper.insertChecklist(checklist);
            _eDispatcher.emit(EventDispatcher.eventChecklistAdded, { 'checklist': checklist });
          } else {
            widget.checklist.title = _titleController.text;
            await _dbHelper.updateChecklist(widget.checklist);
            _eDispatcher.emit('${EventDispatcher.eventChecklistEdited}_${widget.checklist.id}', { 'item': widget.checklist });
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
