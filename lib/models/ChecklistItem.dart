import 'Streamable.dart';

class ChecklistItem extends Streamable<bool> {
  int _id = 0;
  String _title = '';
  bool _isChecked = false;

  ChecklistItem(int id) {
    this._id = id;
  }

  int get id => this._id;

  set title(String title) => this._title = title;

  String get title => this._title;

  set isChecked(bool isChecked) {
    this._isChecked = isChecked;
    this.emitToStream(this._isChecked);
  }

  bool get isChecked => this._isChecked;

  void check() {
    this._isChecked = true;
    this.emitToStream(this._isChecked);
  }

  void uncheck() {
    this._isChecked = false;
    this.emitToStream(this._isChecked);
  }

  void toggle() {
    this._isChecked = !this._isChecked;
    this.emitToStream(this._isChecked);
  }
}
