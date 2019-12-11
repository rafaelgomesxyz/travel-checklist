import 'package:travel_checklist/models/ChecklistItem.dart';

class Checklist {
  int id = 0;
  int trip = 0;
  String title = '';
  int checkedItems = 0;
  int totalItems = 0;
  List<ChecklistItem> items = [];

  Checklist();

  void increaseCheckedItems() {
    checkedItems += 1;
  }

  void decreaseCheckedItems() {
    checkedItems -= 1;
  }

  void addItem(ChecklistItem item) {
    items.add(item);
    totalItems += 1;
  }

  ChecklistItem getItem(int id) {
    return items.firstWhere((item) => item.id == id);
  }

  void removeItem(int id) {
    ChecklistItem item = this.getItem(id);
    if (item.isChecked) {
      decreaseCheckedItems();
    }
    items.remove(item);
    totalItems -= 1;
  }
}