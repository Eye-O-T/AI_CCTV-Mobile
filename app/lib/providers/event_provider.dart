import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';
import '../repositories/dummy_event_repository.dart';
import '../repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return DummyEventRepository();
});

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);

  return repository.getEvents();
});