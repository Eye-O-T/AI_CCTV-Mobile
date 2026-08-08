import '../data/dummy_events.dart';
import '../models/event.dart';
import 'event_repository.dart';

class DummyEventRepository implements EventRepository {
  @override
  Future<List<Event>> getEvents() async {
    return dummyEvents;
  }
}