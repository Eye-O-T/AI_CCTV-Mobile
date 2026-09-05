import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/config/api_config.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/features/events/data/api_event_repository.dart';
import 'package:app/features/events/data/event_repository.dart';
import 'package:app/features/events/domain/event.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return ApiEventRepository(apiClient: apiClient);
});

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  void selectDate(DateTime date) {
    state = date;
  }
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return repository.getEventsByDate(selectedDate);
});
