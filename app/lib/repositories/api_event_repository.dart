import 'dart:convert';

import '../models/event.dart';
import '../services/api_client.dart';
import 'event_repository.dart';

class ApiEventRepository implements EventRepository {
  final ApiClient apiClient;

  ApiEventRepository({required this.apiClient});

  @override
  Future<List<Event>> getEventsByDate(DateTime date) async {
    final from = DateTime(date.year, date.month, date.day);

    final to = from.add(const Duration(days: 1));

    final response = await apiClient.get(
      '/events'
      '?from=${from.toIso8601String()}'
      '&to=${to.toIso8601String()}',
    );

    if (response.statusCode != 200) {
      throw Exception('이벤트 조회 실패: ${response.statusCode}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList
        .map((json) => Event.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
