import 'package:event_bus/event_bus.dart';

class Events {
  static final EventBus _eventBus = EventBus();

  static EventBus get eventBus => _eventBus;
}