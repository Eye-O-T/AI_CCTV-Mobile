import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';
import '../repositories/dummy_event_repository.dart';
import '../repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return DummyEventRepository();
});

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  final events = await repository.getEvents();

  return events.where((event) {
    return event.occurredAt.year == selectedDate.year &&
        event.occurredAt.month == selectedDate.month &&
        event.occurredAt.day == selectedDate.day;
  }).toList();
});
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime(2026, 7, 25); // 초기 날짜 설정
  }

  void selectDate(DateTime date) {
    state = date;
  }
}

final selectedDateProvider =
NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);