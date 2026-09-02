import 'package:coinlens/core/theme/app_theme.dart';
import 'package:coinlens/features/result/result_page.dart';
import 'package:coinlens/services/analytics/analytics_service.dart';
import 'package:coinlens/services/preferences/app_preferences.dart';
import 'package:coinlens/services/subscription/mock_subscription_service.dart';
import 'package:coinlens/services/subscription/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _host(Widget child, List<Override> overrides) {
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, __) => child),
    GoRoute(path: '/paywall', builder: (_, __) => const Text('PAYWALL')),
    GoRoute(
        path: '/result/:id/assistant',
        builder: (_, __) => const Text('ASSISTANT')),
  ]);
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
  );
}

Future<List<Override>> _overrides({bool premium = false}) async {
  SharedPreferences.setMockInitialValues(
      premium ? {'mock_is_premium': true} : {});
  final prefs = await SharedPreferences.getInstance();
  final logger = Logger();
  return [
    sharedPreferencesProvider.overrideWithValue(prefs),
    loggerProvider.overrideWithValue(logger),
    analyticsServiceProvider.overrideWithValue(MockAnalyticsService(logger)),
    subscriptionServiceProvider
        .overrideWithValue(MockSubscriptionService(prefs)),
  ];
}

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  final list = find.descendant(
    of: find.byType(ResultPage),
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(target, 200, scrollable: list.first,
      maxScrolls: 60);
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('free result shows value + locked premium, not the AI analysis',
      (tester) async {
    await tester
        .pumpWidget(_host(const ResultPage(scanId: 's1'), await _overrides()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Italian 500 Lire'), findsOneWidget);
    expect(find.text('ESTIMATED MARKET VALUE'), findsOneWidget);

    await _scrollTo(tester, find.text('Unlock AI Coin Intelligence'));
    expect(find.text('Unlock AI Coin Intelligence'), findsOneWidget);
    expect(find.text('Coin Story'), findsNothing);
  });

  testWidgets('premium result exposes the AI analysis behind an explicit tap',
      (tester) async {
    await tester.pumpWidget(_host(
        const ResultPage(scanId: 's1'), await _overrides(premium: true)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Coin Story'), findsNothing);
    await _scrollTo(tester, find.text('Generate AI analysis'));
    expect(find.text('Generate AI analysis'), findsOneWidget);

    await tester.tap(find.text('Generate AI analysis'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    await _scrollTo(tester, find.text('Coin Story'));
    expect(find.text('Coin Story'), findsOneWidget);
    await _scrollTo(tester, find.text('Selling Recommendations'));
    expect(find.text('Selling Recommendations'), findsOneWidget);
    expect(find.textContaining('Do not clean this coin'), findsOneWidget);
  });
}
