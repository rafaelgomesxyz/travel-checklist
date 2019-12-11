import 'dart:async';

class EventDispatcher {
  static final String eventChecklistItemAdded = 'checklist_item_added';
  static final String eventChecklistItemEdited = 'checklist_item_edited';
  static final String eventChecklistItemChecked = 'checklist_item_checked';
  static final String eventChecklistItemRemoved = 'checklist_item_removed';
  static final String eventChecklistAdded = 'checklist_added';
  static final String eventChecklistEdited = 'checklist_edited';
  static final String eventChecklistRemoved = 'checklist_removed';
  static final String eventTripAdded = 'trip_added';
  static final String eventTripEdited = 'trip_edited';
  static final String eventTripRemoved = 'trip_removed';

  Map<String, StreamController<Map<String, dynamic>>> _streamControllers = {};

  EventDispatcher._privateConstructor(); // Singleton
  static final EventDispatcher instance = EventDispatcher._privateConstructor();

  StreamSubscription listen(String name, void Function(Map<String, dynamic>) listener) {
    if (!this._streamControllers.containsKey(name)) {
      this._streamControllers[name] = StreamController<Map<String, dynamic>>.broadcast();
    }
    return this._streamControllers[name].stream.listen(listener);
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
