import 'ChecklistItem.dart';
import 'Progress.dart';
import 'Streamable.dart';

class Checklist extends Streamable<bool> {
  int _id = 0;
  String _title = '';
  final List<ChecklistItem> _items = [];
  final Progress _progress = Progress(0, 0);

  Checklist(int id) {
    this._id = id;
  }

  int get id => this._id;

  set title(String title) => this._title = title;

  String get title => this._title;

  Progress get progress => this._progress;

  void _updateProgress(bool isItemChecked) {
    if (isItemChecked) {
      this._progress.increaseCurrent();
    } else {
      this._progress.decreaseCurrent();
    }
    this.emitToStream(isItemChecked);
  }

  void addItem(ChecklistItem item) {
    item.listenToStream(this._updateProgress);
    this._progress.increaseTotal();
    this._items.add(item);
  }

  ChecklistItem getItem(int id) {
    return this._items.firstWhere((item) => item.id == id);
  }

  void removeItem(int id) {
    ChecklistItem item = this.getItem(id);
    item.closeStream();
    if (item.isChecked) {
      this._progress.decreaseCurrent();
    }
    this._progress.decreaseTotal();
    this._items.remove(item);
  }
}