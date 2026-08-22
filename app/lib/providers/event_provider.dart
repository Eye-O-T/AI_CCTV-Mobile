import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/api_config.dart';
import '../models/event.dart';
import '../repositories/api_event_repository.dart';
import '../repositories/event_repository.dart';
import '../services/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiConfig.baseUrl,
  );
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return ApiEventRepository(
    apiClient: apiClient,
  );
});

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime(2026, 7, 25);
  }

  void selectDate(DateTime date) {
    state = date;
  }
}

final selectedDateProvider =
NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return repository.getEventsByDate(selectedDate);
});