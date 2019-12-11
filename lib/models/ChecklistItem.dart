class ChecklistItem {
  int _id = 0;
  int _checklist = 0;
  String _title = '';
  bool _isChecked = false;

  ChecklistItem();

  set id(int id) => this._id = id;

  set checklist(int checklist) => this._checklist = checklist;

  set title(String title) => this._title = title;

  set isChecked(bool isChecked) => this._isChecked = isChecked;

  int get id => this._id;

  int get checklist => this._checklist;

  String get title => this._title;

  bool get isChecked => this._isChecked;

  void check() {
    this._isChecked = true;
  }

  void uncheck() {
    this._isChecked = false;
  }

  void toggle() {
    this._isChecked = !this._isChecked;
  }
}
