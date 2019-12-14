class ChecklistItem {
  int id = 0;
  int checklist = 0;
  String title = '';
  bool isChecked = false;
  String coordinates = '';
  bool isPlace = false;

  ChecklistItem();

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
