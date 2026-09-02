import 'dart:typed_data';

import '../../../core/error/failure.dart';
import '../../../core/utils/result.dart';
import '../domain/catalog_entry.dart';
import '../domain/coin_models.dart';
import '../domain/condition_estimator.dart';
import '../domain/identification_service.dart';
import '../domain/ocr_service.dart';
import '../domain/value_estimation_service.dart';
import 'coin_catalog.dart';

/// On-device identification pipeline (product spec §7–9, §35 "verified data
/// first"):
///
///   OCR → token/country/year extraction → structured catalog match →
///   confidence score → condition estimate → value estimate
///
/// It relies on structured catalog data, not free-form guessing. When the best
/// match is weak it returns ranked alternatives instead of asserting one answer
/// (product spec §27).
class PipelineIdentificationService implements IdentificationService {
  PipelineIdentificationService({
    required OcrService ocr,
    required CoinCatalog catalog,
    required ConditionEstimator conditionEstimator,
    required ValueEstimationService valueEstimator,
  })  : _ocr = ocr,
        _catalog = catalog,
        _condition = conditionEstimator,
        _value = valueEstimator;

  final OcrService _ocr;
  final CoinCatalog _catalog;
  final ConditionEstimator _condition;
  final ValueEstimationService _value;

  @override
  Future<Result<CoinIdentification>> identify({
    required Uint8List frontImage,
    Uint8List? backImage,
    void Function(IdentificationStage stage)? onStage,
  }) async {
    try {
      onStage?.call(IdentificationStage.detectingText);
      final ocr = await _ocr.readText(frontImage);
      final backOcr =
          backImage != null ? await _ocr.readText(backImage) : null;
      final tokens = <String>{
        ...ocr.tokens,
        if (backOcr != null) ...backOcr.tokens,
      };
      final years = <int>{...ocr.detectedYears, ...?backOcr?.detectedYears};

      onStage?.call(IdentificationStage.identifyingCountry);
      final entries = await _catalog.all();

      onStage?.call(IdentificationStage.detectingYear);
      final year = years.isEmpty ? null : years.reduce((a, b) => a > b ? a : b);

      onStage?.call(IdentificationStage.searchingDatabase);
      final scored = entries
          .map((e) => _score(e, tokens, year))
          .where((s) => s.score > 0)
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      onStage?.call(IdentificationStage.calculatingValue);

      if (scored.isEmpty) {
        return Result.ok(_unidentified(year, entries));
      }

      final best = scored.first;
      final second = scored.length > 1 ? scored[1].score : 0.0;
      final confidence = _confidence(best, second);

      final conditionEstimate = await _condition.estimate(frontImage);
      final rarity = _rarityFor(best.entry, year);
      final mint = _detectMint(best.entry, tokens);
      final value = _value.estimate(
        entry: best.entry,
        year: year,
        condition: conditionEstimate.condition,
        rarity: rarity,
        mint: mint,
      );

      final alternatives = scored
          .take(3)
          .map((s) => CoinMatch(
                name: '${s.entry.name}${_matchYear(s.entry, year) != null ? ' (${_matchYear(s.entry, year)})' : ''}',
                confidence: _shareConfidence(s.score, scored),
              ))
          .toList();

      return Result.ok(CoinIdentification(
        coinName: _displayName(best.entry, year),
        country: best.entry.country,
        year: _matchYear(best.entry, year),
        denomination: best.entry.denomination,
        material: best.entry.material,
        condition: conditionEstimate.condition,
        rarity: rarity,
        confidence: confidence,
        value: value,
        mint: mint,
        diameterMm: best.entry.diameterMm,
        weightG: best.entry.weightG,
        alternativeMatches:
            confidence < CoinIdentification.lowConfidenceThreshold
                ? alternatives
                : const [],
      ));
    } catch (e) {
      return Result.err(UnknownFailure(cause: e));
    }
  }

  // --- scoring -------------------------------------------------------------

  _Scored _score(CatalogEntry entry, Set<String> tokens, int? year) {
    var matched = 0;
    var matchedWeight = 0.0;
    for (final keyword in entry.keywords) {
      final parts = keyword.split(' ');
      final hit = parts.every((p) => _tokenPresent(p, tokens));
      if (hit) {
        matched++;
        matchedWeight += parts.length; // multi-word legends count for more
      }
    }
    if (matched == 0) return _Scored(entry, 0);

    var score = matchedWeight;
    final inRange = entry.coversYear(year);
    if (inRange) score += 2.5;
    // Denomination digits present as a token (e.g. "500", "50").
    final denomDigits = RegExp(r'\d+').firstMatch(entry.denomination)?.group(0);
    if (denomDigits != null && tokens.contains(denomDigits)) score += 1.5;

    return _Scored(entry, score, matched: matched, yearInRange: inRange);
  }

  bool _tokenPresent(String needle, Set<String> tokens) {
    if (tokens.contains(needle)) return true;
    if (needle.length < 5) return false;
    for (final t in tokens) {
      if (t.length >= 5 &&
          (t.startsWith(needle) || needle.startsWith(t))) {
        return true;
      }
    }
    return false;
  }

  double _confidence(_Scored best, double secondScore) {
    var c = 0.34 + 0.11 * best.matched;
    if (best.yearInRange) c += 0.16;
    if (best.score >= 6) c += 0.08;
    if (secondScore > 0) {
      c *= (1 - 0.35 * (secondScore / best.score)).clamp(0.55, 1.0);
    }
    return c.clamp(0.2, 0.97);
  }

  double _shareConfidence(double score, List<_Scored> all) {
    final total = all.take(3).fold<double>(0, (s, e) => s + e.score);
    return total == 0 ? 0 : (score / total).clamp(0.05, 0.95);
  }

  // --- derived fields -----------------------------------------------------

  int? _matchYear(CatalogEntry entry, int? year) =>
      entry.coversYear(year) ? year : null;

  String _displayName(CatalogEntry entry, int? year) {
    final y = _matchYear(entry, year);
    return y != null ? '${entry.name} · $y' : entry.name;
  }

  String _unidentifiedName(int? year) =>
      'Unidentified coin${year != null ? ' ($year)' : ''}';

  CoinRarity _rarityFor(CatalogEntry entry, int? year) {
    if (entry.isKeyDate(year)) {
      // Bump one step for a key date.
      final next = entry.baseRarity.index + 1;
      return CoinRarity
          .values[next.clamp(0, CoinRarity.values.length - 1)];
    }
    return entry.baseRarity;
  }

  String? _detectMint(CatalogEntry entry, Set<String> tokens) {
    for (final m in entry.mintMarks) {
      if (tokens.contains(m)) return m;
    }
    return null;
  }

  CoinIdentification _unidentified(int? year, List<CatalogEntry> entries) {
    final guesses = entries.take(3).toList();
    return CoinIdentification(
      coinName: _unidentifiedName(year),
      country: 'Unknown',
      year: year,
      denomination: 'Unknown',
      material: 'Unknown',
      condition: CoinCondition.good,
      rarity: CoinRarity.common,
      confidence: 0.28,
      value: const ValueEstimate(min: 1, max: 8, typical: 3),
      alternativeMatches: [
        for (final g in guesses) CoinMatch(name: g.name, confidence: 0.2),
      ],
    );
  }
}

class _Scored {
  _Scored(this.entry, this.score, {this.matched = 0, this.yearInRange = false});
  final CatalogEntry entry;
  final double score;
  final int matched;
  final bool yearInRange;
}
