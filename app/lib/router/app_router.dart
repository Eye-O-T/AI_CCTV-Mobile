import 'package:go_router/go_router.dart';

import '../screens/history_screen.dart';
import '../screens/home_page.dart';
import '../screens/live_screen.dart';
import '../screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: "/live",

  routes: [

    ShellRoute(

      builder: (context, state, child) {
        return HomePage(child: child);
      },

      routes: [

        GoRoute(
          path: "/live",
          builder: (context, state) => const LiveScreen(),
        ),

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