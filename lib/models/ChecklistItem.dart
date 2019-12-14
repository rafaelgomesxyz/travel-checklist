class ChecklistItem {
  int id = 0;
  int checklist = 0;
  String name = '';
  String coordinates = '';
  bool isChecked = false;

  ChecklistItem();

  get isPlace => coordinates.isNotEmpty;

  void check() {
    isChecked = true;
  }

  void uncheck() {
    isChecked = false;
  }

  void toggle() {
    isChecked = !isChecked;
  }
}
