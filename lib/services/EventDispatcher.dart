import 'package:travel_checklist/models/Streamable.dart';

class EventDispatcher {
  Map<String, Streamable> _streams = Map<String, Streamable>();

  static final String eventTrip = "trip";

  EventDispatcher._privateConstructor(); // classe Singleton
  static final EventDispatcher instance = EventDispatcher._privateConstructor();

  void listen(String name, void Function(dynamic) listener) {
    if (!this._streams.containsKey(name)) {
      this._streams[name] = Streamable.broadcast();
    }
    this._streams[name].listen(listener);
  }

  void emit(String name, dynamic value) {
    if (this._streams.containsKey(name)) {
      this._streams[name].emit(value);
    }
  }

  void close(String name) {
    if (this._streams.containsKey(name)) {
      this._streams[name].close();
    }
  }
}
