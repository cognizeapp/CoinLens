import 'dart:math';

import '../domain/catalog_entry.dart';
import '../domain/coin_models.dart';
import '../domain/value_estimation_service.dart';

/// Transparent, rule-based value model:
///
///   typical ≈ base(Fine) × condition × rarity × keyDate × mint
///
/// with the spread widening for scarcer material. Every multiplier is exposed
/// as a [ValueFactor] so the result screen can explain the number instead of
/// just asserting it (product spec §8, §35).
class CatalogValueEstimator implements ValueEstimationService {
  const CatalogValueEstimator();

  static const Map<CoinCondition, double> _conditionMultiplier = {
    CoinCondition.poor: 0.25,
    CoinCondition.fair: 0.45,
    CoinCondition.good: 0.65,
    CoinCondition.veryGood: 0.82,
    CoinCondition.fine: 1.0,
    CoinCondition.veryFine: 1.7,
    CoinCondition.extremelyFine: 2.8,
    CoinCondition.uncirculated: 5.0,
  };

  static const Map<CoinRarity, double> _rarityMultiplier = {
    CoinRarity.common: 1.0,
    CoinRarity.uncommon: 1.35,
    CoinRarity.rare: 2.6,
    CoinRarity.veryRare: 5.5,
    CoinRarity.extremelyRare: 13.0,
  };

  @override
  ValueEstimate estimate({
    required CatalogEntry entry,
    required int? year,
    required CoinCondition condition,
    required CoinRarity rarity,
    String? mint,
  }) {
    final base = entry.baseValueEur;
    final condMul = _conditionMultiplier[condition] ?? 1.0;
    final rarMul = _rarityMultiplier[rarity] ?? 1.0;
    final isKey = entry.isKeyDate(year);
    final keyMul = isKey ? 3.2 : 1.0;
    final hasMint = mint != null && entry.mintMarks.contains(mint);
    final mintMul = hasMint ? 1.4 : 1.0;

    final typicalRaw = base * condMul * rarMul * keyMul * mintMul;
    final typical = _round(typicalRaw);

    // Spread: wider when the coin is scarce or a key date (thinner market).
    final spread = 0.35 + (rarMul - 1) * 0.06 + (isKey ? 0.25 : 0);
    final min = _round(max(0.5, typicalRaw * (1 - spread.clamp(0.2, 0.7))));
    final maxV = _round(typicalRaw * (1 + spread.clamp(0.3, 1.2)));

    final metal = entry.material.toLowerCase();
    final isPrecious = metal.contains('silver') ||
        metal.contains('gold') ||
        metal.contains('platinum');

    final factors = <ValueFactor>[
      ValueFactor(
        label: 'Metal',
        detail: isPrecious
            ? '${entry.material} content sets a firm price floor tied to bullion.'
            : '${entry.material} — no significant intrinsic metal value.',
        impact: isPrecious ? ValueImpact.positive : ValueImpact.neutral,
      ),
      ValueFactor(
        label: 'Condition',
        detail: 'Estimated ${condition.label}: '
            '${condMul >= 1.6 ? 'well above' : condMul >= 1.0 ? 'around' : 'below'} '
            'the baseline Fine grade (×${condMul.toStringAsFixed(2)}).',
        impact: condMul >= 1.2
            ? ValueImpact.positive
            : condMul < 0.9
                ? ValueImpact.negative
                : ValueImpact.neutral,
      ),
      ValueFactor(
        label: 'Rarity & demand',
        detail: rarity == CoinRarity.common
            ? 'Common type — plenty of supply for collector demand.'
            : '${rarity.label}: fewer examples reach the market than collectors want (×${rarMul.toStringAsFixed(1)}).',
        impact: rarMul > 1.2 ? ValueImpact.positive : ValueImpact.neutral,
      ),
      if (year != null)
        ValueFactor(
          label: 'Year${hasMint ? ' & mint' : ''}',
          detail: isKey
              ? '$year is a recognised key date for this type — a major premium.'
              : hasMint
                  ? '$year, $mint mint — a mintmark collectors seek.'
                  : '$year is a regular-issue date with normal mintage.',
          impact: (isKey || hasMint) ? ValueImpact.positive : ValueImpact.neutral,
        ),
      const ValueFactor(
        label: 'Authenticity',
        detail:
            'Estimate assumes a genuine, unaltered coin. Cleaning, damage or '
            'doubtful authenticity would lower it.',
        impact: ValueImpact.neutral,
      ),
    ];

    return ValueEstimate(
      min: min,
      max: maxV,
      typical: typical,
      factors: factors,
    );
  }

  double _round(double v) {
    if (v < 5) return (v * 2).round() / 2; // nearest 0.50
    if (v < 50) return v.roundToDouble();
    if (v < 500) return (v / 5).round() * 5;
    return (v / 25).round() * 25;
  }
}
