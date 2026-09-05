import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static const AndroidNotificationChannel _eventChannel =
      AndroidNotificationChannel(
        'cctv_events',
        'CCTV Events',
        description: 'AI-CCTV event alerts',
        importance: Importance.high,
      );

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );

    await _notifications.initialize(settings: initializationSettings);

    final androidNotifications = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidNotifications?.createNotificationChannel(_eventChannel);
    await androidNotifications?.requestNotificationsPermission();
  }

  static Future<void> showForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? 'AI-CCTV 새 이벤트';
    final body =
        notification?.body ??
        _eventBodyFromData(message.data) ??
        '새 CCTV 이벤트가 감지되었습니다.';

    await _notifications.show(
      id: _notificationId(message),
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _eventChannelId,
          _eventChannelName,
          channelDescription: _eventChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      payload: message.data['event_id'],
    );
  }

  static const String _eventChannelId = 'cctv_events';
  static const String _eventChannelName = 'CCTV Events';
  static const String _eventChannelDescription = 'AI-CCTV event alerts';

  static String? _eventBodyFromData(Map<String, dynamic> data) {
    final cameraId = data['camera_id'];

    if (cameraId is String && cameraId.isNotEmpty) {
      return '$cameraId에서 이벤트가 감지되었습니다.';
    }

    return null;
  }

  static int _notificationId(RemoteMessage message) {
    final eventId = int.tryParse(message.data['event_id']?.toString() ?? '');

    if (eventId != null) {
      return eventId;
    }

    return DateTime.now().millisecondsSinceEpoch.remainder(2147483647);
  }
}
