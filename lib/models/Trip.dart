import 'package:travel_checklist/models/Checklist.dart';

class Trip {
  int id = 0;
  String title = '';
  int timestamp = 0;
  String destination = '';
  List<Checklist> checklists = [];

  Trip();

  void addChecklist(Checklist checklist) {
    checklists.add(checklist);
  }
  
  Checklist getChecklist(int id) {
    return checklists.firstWhere((checklist) => checklist.id == id);
  }
  
  void removeChecklist(int id) {
    Checklist checklist = this.getChecklist(id);
    checklists.remove(checklist);
  }
}