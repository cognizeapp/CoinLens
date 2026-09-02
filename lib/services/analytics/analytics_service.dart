import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Product analytics events (product spec §29). Names are stable — treat this
/// enum as the analytics contract.
enum AnalyticsEvent {
  appOpened('app_opened'),
  onboardingCompleted('onboarding_completed'),
  signInStarted('sign_in_started'),
  signInCompleted('sign_in_completed'),
  scanStarted('scan_started'),
  scanCompleted('scan_completed'),
  coinIdentified('coin_identified'),
  valueResultViewed('value_result_viewed'),
  premiumPreviewViewed('premium_preview_viewed'),
  paywallViewed('paywall_viewed'),
  subscriptionStarted('subscription_started'),
  subscriptionCompleted('subscription_completed'),
  collectionItemSaved('collection_item_saved'),
  aiAnalysisStarted('ai_analysis_started'),
  aiAnalysisCompleted('ai_analysis_completed');

  const AnalyticsEvent(this.name);
  final String name;
}

abstract interface class AnalyticsService {
  Future<void> logEvent(AnalyticsEvent event, {Map<String, Object?>? params});
  Future<void> setUserId(String? id);
  Future<void> setUserProperty(String name, String? value);
}

/// Console-only implementation used in dev and whenever Firebase is disabled.
class MockAnalyticsService implements AnalyticsService {
  MockAnalyticsService(this._log);
  final Logger _log;

  @override
  Future<void> logEvent(AnalyticsEvent event,
      {Map<String, Object?>? params}) async {
    if (kDebugMode) {
      _log.d('analytics › ${event.name} ${params ?? ''}');
    }
  }

  @override
  Future<void> setUserId(String? id) async {}

  @override
  Future<void> setUserProperty(String name, String? value) async {}
}

final loggerProvider = Provider<Logger>((ref) => Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        dateTimeFormat: DateTimeFormat.none,
      ),
    ));

/// Overridden in `main()` with the Firebase-backed implementation when enabled.
final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => MockAnalyticsService(ref.watch(loggerProvider)),
);
