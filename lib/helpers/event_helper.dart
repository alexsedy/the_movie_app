import 'package:event_bus/event_bus.dart';

class EventHelper {
  static final EventBus _eventBus = EventBus();

  static EventBus get eventBus => _eventBus;
}