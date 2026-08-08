import 'package:flutter/material.dart';

import '../models/event.dart';
import '../repositories/dummy_event_repository.dart';
import '../widgets/event_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = DummyEventRepository();

    return FutureBuilder<List<Event>>(
      future: repository.getEvents(),
      builder: (context, snapshot) {
        // 로딩 중
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 에러 발생
        if (snapshot.hasError) {
          return Center(
            child: Text('오류: ${snapshot.error}'),
          );
        }

        // 데이터 가져오기
        final events = snapshot.data ?? [];

        // 데이터 없음
        if (events.isEmpty) {
          return const Center(
            child: Text('이벤트가 없습니다.'),
          );
        }

        // 정상
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return EventCard(
              event: events[index],
            );
          },
        );
      },
    );
  }
}