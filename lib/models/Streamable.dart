import 'dart:async';

abstract class Streamable<T> {
  // ignore: close_sinks
  StreamController<T> _streamController;

  Streamable() {
    this._streamController = StreamController<T>();
  }

  Streamable.broadcast() {
    this._streamController = StreamController<T>.broadcast();
  }

  void listenToStream(void Function(T) listener) {
    this._streamController.stream.listen(listener);
  }

  void emitToStream(T value) {
    this._streamController.add(value);
  }

  // Always call this method when no longer using an instance to avoid memory leak.
  void closeStream() {
    this._streamController.close();
  }
}