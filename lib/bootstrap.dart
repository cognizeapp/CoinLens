import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'features/ai/ai_providers.dart';
import 'features/ai/data/http_coin_intelligence_service.dart';
import 'features/auth/data/firebase_auth_repository.dart';
import 'features/auth/data/mock_auth_repository.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/presentation/auth_providers.dart';
import 'features/coin/data/http_identification_service.dart';
import 'features/coin/data/mock_scan_repository.dart';
import 'features/coin/presentation/coin_providers.dart';
import 'services/analytics/analytics_service.dart';
import 'services/preferences/app_preferences.dart';
import 'services/subscription/mock_subscription_service.dart';
import 'services/subscription/revenuecat_subscription_service.dart';
import 'services/subscription/subscription_service.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider not overridden'),
);

/// Composition root. Chooses concrete implementations based on [AppConfig] and
/// installs them as Riverpod overrides. Everything above this line is
/// implementation-agnostic.
///
/// To go live:
///  * set `API_BASE_URL` → identification + AI switch to the backend
///  * set `ENABLE_FIREBASE=true` + configure FlutterFire → swap the auth /
///    scan-repository / analytics overrides for the Firebase ones
///  * set `ENABLE_REVENUECAT=true` → swap the subscription override
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  final prefs = await SharedPreferences.getInstance();
  final logger = Logger();

  // Firebase (project: coinsights-eabc4) reads its config from the native
  // google-services.json / GoogleService-Info.plist, so no explicit
  // FirebaseOptions are needed on iOS/Android. Web has no registered app yet,
  // so it keeps running on mocks.
  var firebaseReady = false;
  if (config.enableFirebase && !kIsWeb) {
    try {
      await Firebase.initializeApp();
      firebaseReady = true;
    } catch (e, st) {
      logger.e('Firebase.initializeApp failed — falling back to mock auth.',
          error: e, stackTrace: st);
    }
  }

  final analytics = MockAnalyticsService(logger);
  final AuthRepository authRepository =
      firebaseReady ? FirebaseAuthRepository() : MockAuthRepository(prefs);
  final scanRepository = MockScanRepository();

  // RevenueCat only if a platform key is configured; otherwise the app keeps
  // using the dev-only mock (which supports `debugSetPremium`).
  final revenueCatKey =
      defaultTargetPlatform == TargetPlatform.iOS
          ? config.revenueCatKeyIos
          : config.revenueCatKeyAndroid;
  SubscriptionService subscriptions;
  if (config.enableRevenueCat && revenueCatKey.isNotEmpty) {
    final rc = RevenueCatSubscriptionService(
      apiKey: revenueCatKey,
      entitlementId: 'premium',
    );
    await rc.init();
    if (firebaseReady) {
      await rc.identify(authRepository.currentUser?.id);
    }
    subscriptions = rc;
  } else {
    subscriptions = MockSubscriptionService(prefs);
  }

  final overrides = <Override>[
    sharedPreferencesProvider.overrideWithValue(prefs),
    appConfigProvider.overrideWithValue(config),
    loggerProvider.overrideWithValue(logger),
    analyticsServiceProvider.overrideWithValue(analytics),
    authRepositoryProvider.overrideWithValue(authRepository),
    subscriptionServiceProvider.overrideWithValue(subscriptions),
    scanRepositoryProvider.overrideWithValue(scanRepository),
  ];

  // Backend wiring: when an API base URL is configured, identification and AI
  // run server-side. Otherwise the on-device pipeline / template mock are used.
  if (!config.useMockBackend) {
    final api = ApiClient(baseUrl: config.apiBaseUrl);
    overrides.addAll([
      identificationServiceProvider
          .overrideWith((ref) => HttpIdentificationService(api)),
      coinIntelligenceServiceProvider
          .overrideWith((ref) => HttpCoinIntelligenceService(api)),
    ]);
  }

  await analytics.logEvent(AnalyticsEvent.appOpened, params: {
    'flavor': config.flavor.name,
    'mock_backend': config.useMockBackend,
  });

  runApp(ProviderScope(overrides: overrides, child: const CoinsightApp()));
}
