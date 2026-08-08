import '../models/event.dart';

abstract class EventRepository {
  Future<List<Event>> getEventsByDate(DateTime date);
}