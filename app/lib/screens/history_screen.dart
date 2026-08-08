import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/event_provider.dart';
import '../widgets/event_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },

      error: (error, stackTrace) {
        return Center(
          child: Text('오류: $error'),
        );
      },

      data: (events) {
        if (events.isEmpty) {
          return const Center(
            child: Text('이벤트가 없습니다.'),
          );
        }

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