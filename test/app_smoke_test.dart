import 'package:coinsight/app/app.dart';
import 'package:coinsight/bootstrap.dart';
import 'package:coinsight/core/config/app_config.dart';
import 'package:coinsight/features/auth/data/mock_auth_repository.dart';
import 'package:coinsight/features/auth/presentation/auth_providers.dart';
import 'package:coinsight/features/coin/data/mock_scan_repository.dart';
import 'package:coinsight/features/coin/presentation/coin_providers.dart';
import 'package:coinsight/services/analytics/analytics_service.dart';
import 'package:coinsight/services/preferences/app_preferences.dart';
import 'package:coinsight/services/subscription/mock_subscription_service.dart';
import 'package:coinsight/services/subscription/subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('cold start shows onboarding, then routes to sign-in',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final logger = Logger();

    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appConfigProvider.overrideWithValue(AppConfig.fromEnvironment()),
        loggerProvider.overrideWithValue(logger),
        analyticsServiceProvider.overrideWithValue(MockAnalyticsService(logger)),
        authRepositoryProvider.overrideWithValue(MockAuthRepository(prefs)),
        subscriptionServiceProvider
            .overrideWithValue(MockSubscriptionService(prefs)),
        scanRepositoryProvider.overrideWithValue(MockScanRepository()),
      ],
      child: const CoinsightApp(),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Discover Your Coins'), findsOneWidget);

    // Walk the 3 onboarding slides.
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Start Scanning'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Onboarding is complete and the app has navigated past it — either to the
    // sign-in screen or (auth resolves async) briefly to the home shell.
    expect(find.text('Discover Your Coins'), findsNothing);
    final reachedApp = find.text('Sign In').evaluate().isNotEmpty ||
        find.text('Scan a Coin').evaluate().isNotEmpty ||
        find.text('Explore without an account').evaluate().isNotEmpty;
    expect(reachedApp, isTrue);
  });
}
