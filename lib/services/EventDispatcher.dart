import 'dart:async';

class EventDispatcher {
  static final String eventChecklistItem = 'checklist_item';
  static final String eventChecklist = 'checklist';
  static final String eventTrip = 'trip';

  Map<String, StreamController<Map<String, dynamic>>> _streamControllers = {};

  EventDispatcher._privateConstructor(); // Singleton
  static final EventDispatcher instance = EventDispatcher._privateConstructor();

  void listen(String name, void Function(Map<String, dynamic>) listener) {
    if (!this._streamControllers.containsKey(name)) {
      this._streamControllers[name] = StreamController<Map<String, dynamic>>.broadcast();
    }
    this._streamControllers[name].stream.listen(listener);
  }

  void emit(String name, Map<String, dynamic> data) {
    if (this._streamControllers.containsKey(name)) {
      this._streamControllers[name].add(data);
    }
  }

  // Always call this when no longer using an instance to avoid memory leaks.
  void close(String name) {
    if (this._streamControllers.containsKey(name)) {
      this._streamControllers[name].close();
    }
  }
}
