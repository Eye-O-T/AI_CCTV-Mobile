import 'package:flutter/material.dart';

import '../data/dummy_events.dart';
import '../widgets/event_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: dummyEvents.length,
      itemBuilder: (context, index) {
        return EventCard(
          event: dummyEvents[index],
        );
      },
    );
  }
}