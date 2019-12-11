import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/services/DatabaseHelper.dart';
import 'package:travel_checklist/services/EventDispatcher.dart';
import '../models/ChecklistItem.dart';

class ChecklistItemFormScreen extends StatefulWidget {
  final ChecklistItem item;
  final int checklist;

  ChecklistItemFormScreen({Key key, this.item, this.checklist}) : super(key: key);

  @override
  _ChecklistItemFormScreenState createState() => _ChecklistItemFormScreenState();
}

class _ChecklistItemFormScreenState extends State<ChecklistItemFormScreen> {
  bool _isCreating = true;
  String _title = '';
  int _checklist = 0;

  final _dbHelper = DatabaseHelper.instance;
  final _eDispatcher = EventDispatcher.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      this._isCreating = false;
      this._title = 'Editar - ${widget.item.title}';
      this._titleController.text = widget.item.title;
    } else {
      this._title = 'Criar ChecklistItem';
    }
    this._checklist = widget.checklist;
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
                Icons.check_box,
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
          Map<String, dynamic> item = {
            DatabaseHelper.columnTitle: this._titleController.text,
          };
          Map<String, dynamic> checklistItem = {
            DatabaseHelper.tableChecklist: this._checklist,
            DatabaseHelper.columnIsChecked: false,
          };

          if (this._isCreating) {
            int itemId = await this._dbHelper.insert(DatabaseHelper.tableItem, item);
            checklistItem[DatabaseHelper.tableItem] = itemId;
            await this._dbHelper.insert(DatabaseHelper.tableChecklistItem, checklistItem);
          } else {
            item[DatabaseHelper.columnId] = widget.item.id;
            await this._dbHelper.update(DatabaseHelper.tableItem, item);
          }

          Navigator.pop(context);
          this._eDispatcher.emit(EventDispatcher.eventChecklistItem, true);
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
