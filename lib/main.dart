import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rafiq/core/theme/app_theme.dart';
import 'package:rafiq/features/daily_prayer/presentation/daily_prayer_screen.dart';
import 'package:rafiq/features/qada_debt/presentation/qada_debt_screen.dart';
import 'package:rafiq/features/quran_hadith/presentation/quran_hadith_screen.dart';
import 'package:rafiq/features/azkar/presentation/azkar_screen.dart';
import 'package:rafiq/features/overview/presentation/overview_screen.dart';
import 'package:rafiq/features/settings/presentation/settings_screen.dart';
import 'package:rafiq/features/onboarding/presentation/onboarding_screen.dart';
import 'package:rafiq/features/pin/presentation/pin_screen.dart';
import 'package:rafiq/core/services/pin_service.dart';
import 'package:rafiq/core/widgets/double_back_to_exit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: RafiqApp()));
}

final _router = GoRouter(
  initialLocation: '/daily-prayer',
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingCompleted =
        prefs.getBool('onboarding_completed') ?? false;
    print(
      'Redirect Check: Onboarding=$onboardingCompleted, Path=${state.uri.path}',
    );

    // PIN Check
    final hasPin = prefs.containsKey('app_pin');
    if (hasPin && !PinService.isVerified && state.uri.path != '/pin') {
      return '/pin';
    }

    if (!onboardingCompleted && state.uri.path != '/onboarding') {
      return '/onboarding';
    }
    if (onboardingCompleted && state.uri.path == '/onboarding') {
      return '/daily-prayer';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/pin',
      builder:
          (context, state) => PinScreen(
            onSuccess: () {
              PinService.isVerified = true;
              context.go('/daily-prayer');
            },
          ),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return DoubleBackToExit(child: ScaffoldWithNavBar(child: child));
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
          routes: [
            GoRoute(
              path: 'surah/:surahNumber',
              builder: (context, state) {
                final surahNumber = int.parse(
                  state.pathParameters['surahNumber']!,
                );
                final verse =
                    state.uri.queryParameters['verse'] != null
                        ? int.parse(state.uri.queryParameters['verse']!)
                        : null;
                return SurahDetailScreen(
                  surahNumber: surahNumber,
                  initialVerse: verse,
                );
              },
            ),
          ],
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

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;
  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final index = _calculateSelectedIndex(context);
    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.jumpToPage(index);
    } else if (!_pageController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(index);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant ScaffoldWithNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final index = _calculateSelectedIndex(context);
    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => _onItemTapped(index, context),
        children: const [
          DailyPrayerScreen(),
          QadaDebtScreen(),
          QuranHadithScreen(),
          AzkarScreen(),
          OverviewScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int index) {
          _onItemTapped(index, context);
          _pageController.jumpToPage(index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home, color: Colors.blue.shade300),
            selectedIcon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history, color: Colors.orange.shade300),
            selectedIcon: Icon(Icons.history, color: Colors.orange),
            label: 'Qada',
          ),
          NavigationDestination(
            icon: Icon(Icons.book, color: Colors.green.shade300),
            selectedIcon: Icon(Icons.book, color: Colors.green),
            label: 'Quran',
          ),
          NavigationDestination(
            icon: Icon(Icons.filter_vintage, color: Colors.purple.shade300),
            selectedIcon: Icon(Icons.filter_vintage, color: Colors.purple),
            label: 'Azkar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.teal.shade300),
            selectedIcon: Icon(Icons.person, color: Colors.teal),
            label: 'Overview',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
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
        context.go('/daily-prayer');
        break;
      case 1:
        context.go('/qada-debt');
        break;
      case 2:
        context.go('/quran-hadith');
        break;
      case 3:
        context.go('/azkar');
        break;
      case 4:
        context.go('/overview');
        break;
    }
  }
}
