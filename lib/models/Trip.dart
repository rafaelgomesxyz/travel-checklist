import 'package:travel_checklist/models/Checklist.dart';

class Trip {
  int id = 0;
  String name = '';
  String destination = '';
  String destinationCoordinates = '';
  int departureTimestamp = 0;
  int returnTimestamp = 0;
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