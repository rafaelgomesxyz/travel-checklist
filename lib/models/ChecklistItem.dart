import 'package:travel_checklist/models/Streamable.dart';

class ChecklistItem {
  int _id = 0;
  String _title = '';
  bool _isChecked = false;

  final Streamable<bool> _stream = Streamable<bool>();

  ChecklistItem(int id) {
    this._id = id;
  }

  int get id => this._id;

  set title(String title) => this._title = title;

  String get title => this._title;

  set isChecked(bool isChecked) {
    this._isChecked = isChecked;
    this._stream.emit(this._isChecked);
  }

  bool get isChecked => this._isChecked;

  Streamable<bool> get stream => this._stream;

  void check() {
    this._isChecked = true;
    this._stream.emit(this._isChecked);
  }

  void uncheck() {
    this._isChecked = false;
    this._stream.emit(this._isChecked);
  }

  void toggle() {
    this._isChecked = !this._isChecked;
    this._stream.emit(this._isChecked);
  }
}
