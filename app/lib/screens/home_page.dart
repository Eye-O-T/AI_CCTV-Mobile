import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  final Widget child;

  const HomePage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;

    switch (location) {
      case '/history':
        currentIndex = 1;
        break;

      case '/settings':
        currentIndex = 2;
        break;

      default:
        currentIndex = 0;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/live');
              break;
            case 1:
              context.go('/history');
              break;
            case 2:
              context.go('/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: '실시간',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '히스토리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}