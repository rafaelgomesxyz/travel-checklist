import 'package:travel_checklist/models/ChecklistItem.dart';

class Checklist {
  int _id = 0;
  int _trip = 0;
  String _title = '';
  int _currentItems = 0;
  int _totalItems = 0;

  final List<ChecklistItem> _items = [];

  Checklist(int id, int trip) {
    this._id = id;
    this._trip = trip;
  }

  set title(String title) => this._title = title;

  set currentItems(int currentItems) => this._currentItems = currentItems;

  set totalItems(int totalItems) => this._totalItems = totalItems;

  int get id => this._id;

  int get trip => this._trip;

  String get title => this._title;

  int get currentItems => this._currentItems;

  int get totalItems => this._totalItems;

  void addItem(ChecklistItem item) {
    this._items.add(item);
    this._totalItems += 1;
  }

  ChecklistItem getItem(int id) {
    return this._items.firstWhere((item) => item.id == id);
  }

  void removeItem(int id) {
    ChecklistItem item = this.getItem(id);
    if (item.isChecked) {
      this._currentItems -= 1;
    }
    this._items.remove(item);
    this._totalItems -= 1;
  }
}