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

  testWidgets('cold start shows onboarding, then routes to the paywall',
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

    // Onboarding is on screen (the Skip affordance is unique to it).
    expect(find.text('Skip'), findsOneWidget);

    // Walk the 4 onboarding slides: 3 "Continue" taps, then the final CTA.
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    // Onboarding is complete and the app has navigated to the paywall.
    expect(find.text('Skip'), findsNothing);
    expect(find.text('Restore purchases'), findsOneWidget);
  });
}
