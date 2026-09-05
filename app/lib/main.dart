import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/config/api_config.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/notifications/fcm_event_coordinator.dart';
import 'package:app/core/notifications/local_notification_service.dart';
import 'package:app/core/router/app_router.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('백그라운드 FCM 수신: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await LocalNotificationService.initialize();

  final container = ProviderContainer();

  await setupFcm(container);

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

Future<void> setupFcm(ProviderContainer container) async {
  final messaging = FirebaseMessaging.instance;
  final coordinator = FcmEventCoordinator(container);

  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint('알림 권한: ${settings.authorizationStatus}');

  final token = await messaging.getToken();

  debugPrint('FCM Token: $token');

  if (token != null) {
    await registerFcmToken(token);
  }

  messaging.onTokenRefresh.listen(registerFcmToken);

  FirebaseMessaging.onMessage.listen(coordinator.handleForegroundMessage);
}

Future<void> registerFcmToken(String token) async {
  final apiClient = ApiClient(baseUrl: ApiConfig.baseUrl);

  try {
    final response = await apiClient.postJson('/device-tokens', {
      'token': token,
      'platform': defaultTargetPlatform.name,
    });

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('FCM 토큰 서버 등록 실패: ${response.statusCode}');
    }
  } catch (error) {
    debugPrint('FCM 토큰 서버 등록 오류: $error');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
