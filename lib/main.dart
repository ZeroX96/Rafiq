import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rafiq/core/theme/app_theme.dart';
import 'package:rafiq/features/daily_prayer/presentation/daily_prayer_screen.dart';
import 'package:rafiq/features/qada_debt/presentation/qada_debt_screen.dart';
import 'package:rafiq/features/quran_hadith/presentation/quran_hadith_screen.dart';
import 'package:rafiq/features/azkar/presentation/azkar_screen.dart';
import 'package:rafiq/features/overview/presentation/overview_screen.dart';

void main() {
  runApp(const ProviderScope(child: RafiqApp()));
}

final _router = GoRouter(
  initialLocation: '/daily-prayer',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/daily-prayer',
          builder: (context, state) => const DailyPrayerScreen(),
        ),
        GoRoute(
          path: '/qada-debt',
          builder: (context, state) => const QadaDebtScreen(),
        ),
        GoRoute(
          path: '/quran-hadith',
          builder: (context, state) => const QuranHadithScreen(),
        ),
        GoRoute(
          path: '/azkar',
          builder: (context, state) => const AzkarScreen(),
        ),
        GoRoute(
          path: '/overview',
          builder: (context, state) => const OverviewScreen(),
        ),
      ],
    ),
  ],
);

class RafiqApp extends StatelessWidget {
  const RafiqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rafiq',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.access_time),
            label: 'Prayers',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'Qada'),
          NavigationDestination(icon: Icon(Icons.book), label: 'Quran'),
          NavigationDestination(
            icon: Icon(Icons.filter_vintage),
            label: 'Azkar',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Overview'),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/daily-prayer')) return 0;
    if (location.startsWith('/qada-debt')) return 1;
    if (location.startsWith('/quran-hadith')) return 2;
    if (location.startsWith('/azkar')) return 3;
    if (location.startsWith('/overview')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/daily-prayer');
        break;
      case 1:
        GoRouter.of(context).go('/qada-debt');
        break;
      case 2:
        GoRouter.of(context).go('/quran-hadith');
        break;
      case 3:
        GoRouter.of(context).go('/azkar');
        break;
      case 4:
        GoRouter.of(context).go('/overview');
        break;
    }
  }
}
