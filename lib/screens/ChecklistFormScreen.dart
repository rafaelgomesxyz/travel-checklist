import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import '../models/Checklist.dart';

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
    if (widget.checklist != null) {
      this._isCreating = false;
      this._title = 'Editar - ${widget.checklist.title}';
      this._titleController.text = widget.checklist.title;
    } else {
      this._title = 'Criar Checklist';
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
                Icons.playlist_add_check,
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
          Map<String, dynamic> checklist = {
            DatabaseHelper.columnTitle: this._titleController.text,
            DatabaseHelper.tableTrip: widget.trip,
          };

          if (this._isCreating) {
            await this._dbHelper.insert(DatabaseHelper.tableChecklist, checklist);
          } else {
            checklist[DatabaseHelper.columnId] = widget.checklist.id;
            await this._dbHelper.update(DatabaseHelper.tableChecklist, checklist);
          }

          Navigator.pop(context);
          this._eDispatcher.emit(EventDispatcher.eventChecklist, true);
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
