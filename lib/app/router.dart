import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_providers.dart';
import '../features/ai/presentation/ai_chat_page.dart';
import '../features/auth/presentation/sign_in_page.dart';
import '../features/auth/presentation/sign_up_page.dart';
import '../features/collection/collection_page.dart';
import '../features/history/history_page.dart';
import '../features/home/home_page.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/paywall/paywall_page.dart';
import '../features/profile/profile_page.dart';
import '../features/rankings/rankings_page.dart';
import '../features/result/result_page.dart';
import '../features/scan/scan_page.dart';
import '../features/shell/app_shell.dart';
import '../services/preferences/app_preferences.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Rebuilds the router's redirect logic whenever auth or onboarding state
/// changes.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
    ref.listen(onboardingCompleteProvider, (_, __) => notifyListeners());
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final onboardingDone = ref.read(onboardingCompleteProvider);
      final auth = ref.read(authStateProvider);
      final loggedIn = auth.valueOrNull != null;
      final loading = auth.isLoading;

      final loc = state.matchedLocation;
      final atOnboarding = loc == '/onboarding';
      final atAuth = loc == '/sign-in' || loc == '/sign-up';
      // The post-onboarding paywall is reachable before sign-in so new users
      // meet the free-trial offer straight away.
      final atPaywall = loc == '/paywall';
      // Replaying the intro from Profile — never gated.
      final atTutorial = loc == '/tutorial';

      if (atTutorial) return null;
      if (!onboardingDone) return atOnboarding ? null : '/onboarding';
      if (atOnboarding) return loggedIn ? '/' : '/paywall';

      if (loading) return null;
      if (!loggedIn) return (atAuth || atPaywall) ? null : '/sign-in';
      if (loggedIn && atAuth) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/tutorial',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const OnboardingPage(replay: true),
      ),
      GoRoute(path: '/sign-in', builder: (_, __) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (_, __) => const SignUpPage()),
      GoRoute(
        path: '/paywall',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const PaywallPage(),
      ),
      GoRoute(
        path: '/rankings',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const RankingsPage(),
      ),
      GoRoute(
        path: '/result/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => ResultPage(scanId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'assistant',
            parentNavigatorKey: _rootKey,
            builder: (_, state) =>
                AiChatPage(scanId: state.pathParameters['id']!),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/', builder: (_, __) => const HomePage())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/collection',
                  builder: (_, __) => const CollectionPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/scan', builder: (_, __) => const ScanPage())
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/history', builder: (_, __) => const HistoryPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/profile', builder: (_, __) => const ProfilePage()),
            ],
          ),
        ],
      ),
    ],
  );
});
