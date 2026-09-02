import '../../core/utils/result.dart';
import '../coin/domain/coin_models.dart';

/// The Premium AI output (product spec §3). Generated from the structured
/// [CoinIdentification] — the engine explains and interprets, it does not
/// invent facts or prices (product spec §35).
class CoinIntelligence {
  const CoinIntelligence({
    required this.historicalContext,
    required this.valueAnalysis,
    required this.rarityExplanation,
    required this.conditionExplanation,
    required this.collectorInsights,
    required this.sellingStrategy,
  });

  final String historicalContext;
  final String valueAnalysis;
  final String rarityExplanation;
  final String conditionExplanation;
  final String collectorInsights;
  final SellingStrategy sellingStrategy;
}

class SellingStrategy {
  const SellingStrategy({
    required this.estimatedSaleRange,
    required this.suggestedListPrice,
    required this.minimumPrice,
    required this.recommendedPlatforms,
    required this.auctionAdvice,
    required this.appraisalAdvice,
    required this.cleaningWarning,
  });

  final String estimatedSaleRange;
  final String suggestedListPrice;
  final String minimumPrice;
  final String recommendedPlatforms;
  final String auctionAdvice;
  final String appraisalAdvice;
  final String cleaningWarning;
}

/// A single follow-up exchange with the AI coin assistant (product spec §12).
class AiMessage {
  const AiMessage({required this.fromUser, required this.text});
  final bool fromUser;
  final String text;
}

abstract interface class CoinIntelligenceService {
  /// Runs only for active subscribers, on explicit request (product spec §32).
  Future<Result<CoinIntelligence>> analyze(CoinIdentification identification);

  /// The assistant already knows [context]; the user does not re-explain it.
  Future<Result<String>> ask({
    required CoinIdentification context,
    required List<AiMessage> history,
    required String question,
  });
}
