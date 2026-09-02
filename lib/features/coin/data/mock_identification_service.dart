import 'dart:math';
import 'dart:typed_data';

import '../../../core/utils/result.dart';
import '../domain/coin_models.dart';
import '../domain/identification_service.dart';

/// Returns a plausible identification from a small fixture set, cycling through
/// samples so repeated scans look different. A test/fallback double — it does
/// not look at the image. The real default is [PipelineIdentificationService].
class MockIdentificationService implements IdentificationService {
  int _cursor = 0;
  final _rng = Random();

  static const _fixtures = <CoinIdentification>[
    CoinIdentification(
      coinName: 'Italian 500 Lire',
      country: 'Italy',
      year: 1958,
      denomination: '500 Lire',
      material: 'Silver (.835)',
      condition: CoinCondition.veryFine,
      rarity: CoinRarity.uncommon,
      confidence: 0.92,
      mint: 'Rome (R)',
      diameterMm: 29.3,
      weightG: 11.0,
      value: ValueEstimate(min: 25, max: 60, typical: 40),
    ),
    CoinIdentification(
      coinName: 'United Kingdom One Penny',
      country: 'United Kingdom',
      year: 1967,
      denomination: '1 Penny',
      material: 'Bronze',
      condition: CoinCondition.fine,
      rarity: CoinRarity.common,
      confidence: 0.86,
      value: ValueEstimate(min: 1, max: 4, typical: 2),
    ),
    CoinIdentification(
      coinName: 'German Empire 1 Mark',
      country: 'Germany',
      year: 1875,
      denomination: '1 Mark',
      material: 'Silver (.900)',
      condition: CoinCondition.veryGood,
      rarity: CoinRarity.rare,
      confidence: 0.68,
      mint: 'Berlin (A)',
      value: ValueEstimate(min: 18, max: 140, typical: 55),
      alternativeMatches: [
        CoinMatch(name: 'German Empire 1 Mark (1875 A)', confidence: 0.68),
        CoinMatch(name: 'German Empire 1 Mark (1874 B)', confidence: 0.24),
      ],
    ),
  ];

  @override
  Future<Result<CoinIdentification>> identify({
    required Uint8List frontImage,
    Uint8List? backImage,
    void Function(IdentificationStage stage)? onStage,
  }) async {
    for (final stage in IdentificationStage.values) {
      onStage?.call(stage);
      await Future<void>.delayed(
          Duration(milliseconds: 350 + _rng.nextInt(300)));
    }
    final pick = _fixtures[_cursor % _fixtures.length];
    _cursor++;
    return Result.ok(pick);
  }
}
