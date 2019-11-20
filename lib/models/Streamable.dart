import 'dart:async';

class Streamable<T> {
  // ignore: close_sinks
  StreamController<T> _streamController;

  Streamable() {
    this._streamController = StreamController<T>();
  }

  Streamable.broadcast() {
    this._streamController = StreamController<T>.broadcast();
  }

  void listen(void Function(T) listener) {
    this._streamController.stream.listen(listener);
  }

  void emit(T value) {
    this._streamController.add(value);
  }

  // Always call this method when no longer using an instance to avoid memory leak.
  void close() {
    this._streamController.close();
  }
}