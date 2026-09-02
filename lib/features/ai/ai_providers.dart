import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../coin/domain/coin_models.dart';
import '../../services/analytics/analytics_service.dart';
import 'coin_intelligence.dart';
import 'mock_coin_intelligence_service.dart';

/// Overridden in `bootstrap()` with the backend-backed implementation when a
/// backend is configured.
final coinIntelligenceServiceProvider = Provider<CoinIntelligenceService>(
  (ref) => MockCoinIntelligenceService(),
);

/// Whether the user has explicitly asked for the AI analysis of a given scan.
/// The analysis provider is only watched once this is true, so an expensive AI
/// call never runs automatically (product spec §32).
final aiAnalysisRequestedProvider =
    StateProvider.family<bool, String>((ref, scanId) => false);

/// On-demand AI analysis for a given identification. `.family` keeps one result
/// per coin; `autoDispose` frees it when the result screen closes.
final coinIntelligenceProvider = FutureProvider.autoDispose
    .family<CoinIntelligence, CoinIdentification>((ref, id) async {
  final analytics = ref.watch(analyticsServiceProvider);
  await analytics.logEvent(AnalyticsEvent.aiAnalysisStarted);
  final result = await ref.watch(coinIntelligenceServiceProvider).analyze(id);
  return result.when(
    ok: (ci) {
      analytics.logEvent(AnalyticsEvent.aiAnalysisCompleted);
      return ci;
    },
    err: (f) => throw f,
  );
});
