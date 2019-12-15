import 'dart:async';
import 'package:travel_checklist/enums.dart';

class EventDispatcher {
  Map<Event, StreamController<Map<String, dynamic>>> _streamControllers = {};

  EventDispatcher._privateConstructor(); // Singleton
  static final EventDispatcher instance = EventDispatcher._privateConstructor();

  StreamSubscription listen(Event event, void Function(Map<String, dynamic>) listener) {
    if (!this._streamControllers.containsKey(event)) {
      this._streamControllers[event] = StreamController<Map<String, dynamic>>.broadcast();
    }
    return this._streamControllers[event].stream.listen(listener);
  }

  void emit(Event event, Map<String, dynamic> data) {
    if (this._streamControllers.containsKey(event)) {
      this._streamControllers[event].sink.add(data);
    }
  }

  // Always call this when no longer using an instance to avoid memory leaks.
  void close(Event event) {
    if (this._streamControllers.containsKey(event)) {
      this._streamControllers[event].close();
    }
  }
}
