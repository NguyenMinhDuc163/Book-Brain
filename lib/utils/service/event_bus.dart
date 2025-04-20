import 'dart:async';

class EventBus {
  // Singleton pattern
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final StreamController _streamController = StreamController.broadcast();

  Stream get stream => _streamController.stream;

  void fire(event) {
    _streamController.sink.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}

// Định nghĩa sự kiện cập nhật yêu thích
class FavoriteUpdatedEvent {
  FavoriteUpdatedEvent();
}