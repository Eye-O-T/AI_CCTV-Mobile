import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app/features/events/presentation/event_history_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_notification_service.dart';

class FcmEventCoordinator {
  const FcmEventCoordinator(this.container);

  final ProviderContainer container;

  Future<void> handleForegroundMessage(RemoteMessage message) async {
    debugPrint('포그라운드 FCM 수신: ${message.messageId}');

    await LocalNotificationService.showForegroundMessage(message);
    refreshEventsIfSelectedDateMatches(message);
  }

  void refreshEventsIfSelectedDateMatches(RemoteMessage message) {
    final eventDate = _eventDate(message);

    if (eventDate == null) {
      return;
    }

    final selectedDate = container.read(selectedDateProvider);

    if (_isSameDay(eventDate, selectedDate)) {
      container.invalidate(eventsProvider);
    }
  }

  DateTime? _eventDate(RemoteMessage message) {
    final occurredAt = message.data['occurred_at'];

    if (occurredAt is! String || occurredAt.isEmpty) {
      return null;
    }

    return DateTime.tryParse(occurredAt);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
