import 'package:travel_checklist/models/Checklist.dart';

class Trip {
  int _id = 0;
  String _title = '';
  int _timestamp = 0;
  String _destination = '';

  final List<Checklist> _checklists = [];

  Trip(int id) {
    this._id = id;
  }

  set title(String title) => this._title = title;

  set timestamp(int timestamp) => this._timestamp = timestamp;

  set destination(String destination) => this._destination = destination;

  int get id => this._id;

  String get title => this._title;

  int get timestamp => this._timestamp;

  String get destination => this._destination;

  void addChecklist(Checklist checklist) {
    this._checklists.add(checklist);
  }
  
  Checklist getChecklist(int id) {
    return this._checklists.firstWhere((checklist) => checklist.id == id);
  }
  
  void removeChecklist(int id) {
    Checklist checklist = this.getChecklist(id);
    this._checklists.remove(checklist);
  }
}