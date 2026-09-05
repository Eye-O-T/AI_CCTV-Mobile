import 'package:go_router/go_router.dart';

import 'package:app/features/events/presentation/history_screen.dart';
import 'package:app/features/live/presentation/live_screen.dart';
import 'package:app/features/settings/presentation/settings_screen.dart';

import 'home_page.dart';

final appRouter = GoRouter(
  initialLocation: "/live",

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomePage(child: child);
      },

      routes: [
        GoRoute(path: "/live", builder: (context, state) => const LiveScreen()),

        GoRoute(
          path: "/history",
          builder: (context, state) => const HistoryScreen(),
        ),

        GoRoute(
          path: "/settings",
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
