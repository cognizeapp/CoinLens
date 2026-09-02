import '../../core/utils/result.dart';
import '../coin/domain/coin_models.dart';
import 'coin_intelligence.dart';

/// Deterministic, template-driven analysis derived from the structured
/// identification. No network, no real model — a development stand-in for the
/// Phase 6 backend AI engine. It never asserts a price the identification did
/// not already contain.
class MockCoinIntelligenceService implements CoinIntelligenceService {
  @override
  Future<Result<CoinIntelligence>> analyze(CoinIdentification id) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final yearText = id.year != null ? 'in ${id.year}' : 'in an unrecorded year';
    final mintText = id.mint != null ? ' at the ${id.mint} mint' : '';

    return Result.ok(CoinIntelligence(
      historicalContext:
          'The ${id.coinName} was issued by ${id.country} $yearText$mintText. '
          'Coins of this type circulated as everyday currency and their design '
          'reflects the national iconography of the period. Surviving examples '
          'are studied today for what they reveal about the economy and '
          'politics of their time.',
      valueAnalysis:
          'The estimate reflects several factors working together: the '
          '${id.material.toLowerCase()} content sets a metal floor, the '
          '${id.year ?? 'issue'} date and ${id.mint ?? 'mint'} determine how '
          'many were struck, and the estimated ${id.condition.label} condition '
          'places it in the mid part of the collector demand curve. Errors, '
          'limited editions and strong eye appeal can push individual examples '
          'well above the typical figure.',
      rarityExplanation:
          'Rated ${id.rarity.label}. This weighs original mintage, estimated '
          'survival rate, and how often examples appear at auction and in '
          'dealer inventories relative to collector demand.',
      conditionExplanation:
          'Estimated ${id.condition.label} from the submitted images: visible '
          'wear on the highest points of the design with the main details '
          'still clear. This is an approximate estimate from photos, not a '
          'professional grade — a certified grade may differ.',
      collectorInsights:
          'This coin is of moderate interest to collectors of ${id.country} '
          'issues and to type-set builders. It is worth preserving as-is in a '
          'non-PVC holder. Consider professional authentication before any '
          'high-value sale, and check reference catalogues for known die '
          'varieties of this date.',
      sellingStrategy: SellingStrategy(
        estimatedSaleRange:
            '${_eur(id.value.min)} – ${_eur(id.value.max * 0.9)}',
        suggestedListPrice: _eur(id.value.max),
        minimumPrice: _eur(id.value.min * 0.8),
        recommendedPlatforms:
            'Specialist numismatic marketplaces and established coin auction '
            'houses. General marketplaces work for lower-value pieces.',
        auctionAdvice: id.value.typical >= 100
            ? 'An auction is reasonable — competitive bidding tends to help '
                'scarcer coins in this value band.'
            : 'A fixed-price listing is usually simpler at this value; an '
                'auction adds fees without much upside.',
        appraisalAdvice: id.value.typical >= 150 || id.rarity.index >= 2
            ? 'Recommended before selling — a professional opinion protects '
                'both value and buyer trust.'
            : 'Optional at this value; useful mainly if authenticity is in '
                'question.',
        cleaningWarning:
            'Do not clean this coin before consulting an expert. Cleaning can '
            'significantly reduce collector value.',
      ),
    ));
  }

  @override
  Future<Result<String>> ask({
    required CoinIdentification context,
    required List<AiMessage> history,
    required String question,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return Result.ok(
      'About your ${context.coinName}: $question\n\n'
      'Based on the identification (${context.country}, '
      '${context.year ?? 'year unknown'}, ${context.material}, estimated '
      '${context.condition.label}, ${context.rarity.label}), the estimated '
      'value range is ${_eur(context.value.min)}–${_eur(context.value.max)}. '
      'For a firm answer on authenticity or grade, a professional appraisal is '
      'the next step. (Demo assistant — Phase 6 connects the real model.)',
    );
  }

  String _eur(num v) => '€${v.round()}';
}
