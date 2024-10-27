import 'dart:async';

class ListUpdateEventBus {
  static final ListUpdateEventBus _instance = ListUpdateEventBus._internal();
  factory ListUpdateEventBus() => _instance;
  ListUpdateEventBus._internal();

  final _controller = StreamController<ListUpdateEvent>.broadcast();

  Stream<ListUpdateEvent> get onListUpdate => _controller.stream;

  void updateList(int listId, int newCount) {
    _controller.add(ListUpdateEvent(listId, newCount));
  }

  void dispose() {
    _controller.close();
  }
}

class ListUpdateEvent {
  final int listId;
  final int newCount;

  ListUpdateEvent(this.listId, this.newCount);
}