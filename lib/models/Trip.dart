import 'Checklist.dart';
import 'Progress.dart';

class Trip {
  int _id = 0;
  String _title = '';
  int _timestamp = 0;
  String _destination = '';
  final List<Checklist> _checklists = [];
  final Progress _progress = Progress(0, 0);

  Trip(int id) {
    this._id = id;
  }

  int get id => this._id;

  set title(String title) => this._title = title;

  String get title => this._title;

  set timestamp(int timestamp) => this._timestamp = timestamp;

  int get timestamp => this._timestamp;

  set destination(String destination) => this._destination = destination;

  String get destination => this._destination;

  Progress get progress => this._progress;

  void _updateProgress(bool isItemChecked) {
    if (isItemChecked) {
      this._progress.increaseCurrent();
    } else {
      this._progress.decreaseCurrent();
    }
  }

  void addChecklist(Checklist checklist) {
    checklist.listenToStream(this._updateProgress);
    this._progress.total += checklist.progress.total;
    this._checklists.add(checklist);
  }
  
  Checklist getChecklist(int id) {
    return this._checklists.firstWhere((checklist) => checklist.id == id);
  }
  
  void removeChecklist(int id) {
    Checklist checklist = this.getChecklist(id);
    checklist.closeStream();
    this._progress.current -= checklist.progress.current;
    this._progress.total -= checklist.progress.total;
    this._checklists.remove(checklist);
  }
}