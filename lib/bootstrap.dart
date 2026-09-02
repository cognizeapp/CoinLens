import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'features/ai/ai_providers.dart';
import 'features/ai/data/http_coin_intelligence_service.dart';
import 'features/auth/data/mock_auth_repository.dart';
import 'features/auth/presentation/auth_providers.dart';
import 'features/coin/data/http_identification_service.dart';
import 'features/coin/data/mock_scan_repository.dart';
import 'features/coin/presentation/coin_providers.dart';
import 'services/analytics/analytics_service.dart';
import 'services/preferences/app_preferences.dart';
import 'services/subscription/mock_subscription_service.dart';
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

  // if (config.enableFirebase) { await Firebase.initializeApp(...); }

  final analytics = MockAnalyticsService(logger);
  final authRepository = MockAuthRepository(prefs);
  final subscriptions = MockSubscriptionService(prefs);
  final scanRepository = MockScanRepository();

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

  runApp(ProviderScope(overrides: overrides, child: const CoinLensApp()));
}
