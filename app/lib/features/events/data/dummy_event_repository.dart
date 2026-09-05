import 'package:app/features/events/data/dummy_events.dart';
import 'package:app/features/events/domain/event.dart';

import 'event_repository.dart';

class DummyEventRepository implements EventRepository {
  @override
  Future<List<Event>> getEventsByDate(DateTime date) async {
    return dummyEvents.where((event) {
      return event.occurredAt.year == date.year &&
          event.occurredAt.month == date.month &&
          event.occurredAt.day == date.day;
    }).toList();
  }
}
