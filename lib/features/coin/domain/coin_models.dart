import 'package:equatable/equatable.dart';

/// Approximate grading scale (product spec §3.3). Always presented as an
/// estimate, never a professional grade.
enum CoinCondition {
  poor('Poor'),
  fair('Fair'),
  good('Good'),
  veryGood('Very Good'),
  fine('Fine'),
  veryFine('Very Fine'),
  extremelyFine('Extremely Fine'),
  uncirculated('Uncirculated');

  const CoinCondition(this.label);
  final String label;

  static CoinCondition fromName(String? name) => values.firstWhere(
        (c) => c.name == name || c.label == name,
        orElse: () => CoinCondition.good,
      );
}

enum CoinRarity {
  common('Common'),
  uncommon('Uncommon'),
  rare('Rare'),
  veryRare('Very Rare'),
  extremelyRare('Extremely Rare');

  const CoinRarity(this.label);
  final String label;

  static CoinRarity fromName(String? name) => values.firstWhere(
        (c) => c.name == name || c.label == name,
        orElse: () => CoinRarity.common,
      );
}

/// A single candidate match with a confidence weight (0–1).
class CoinMatch extends Equatable {
  const CoinMatch({required this.name, required this.confidence});
  final String name;
  final double confidence;

  @override
  List<Object?> get props => [name, confidence];
}

enum ValueImpact { positive, neutral, negative }

/// One driver of the estimate, shown in the free result as a short list and
/// expanded by the Premium "Why It Has Value" section (product spec §3.2, §14).
class ValueFactor extends Equatable {
  const ValueFactor({
    required this.label,
    required this.detail,
    required this.impact,
  });

  final String label;
  final String detail;
  final ValueImpact impact;

  @override
  List<Object?> get props => [label, detail, impact];
}

class ValueEstimate extends Equatable {
  const ValueEstimate({
    required this.min,
    required this.max,
    required this.typical,
    this.currency = 'EUR',
    this.factors = const [],
  });

  final double min;
  final double max;
  final double typical;
  final String currency;

  /// What moved the number; empty for the seeded fixtures.
  final List<ValueFactor> factors;

  @override
  List<Object?> get props => [min, max, typical, currency, factors];
}

/// The structured identification output. This is exactly the payload handed to
/// the Premium AI engine (product spec §9) — the AI explains it, it does not
/// re-derive it.
class CoinIdentification extends Equatable {
  const CoinIdentification({
    required this.coinName,
    required this.country,
    required this.year,
    required this.denomination,
    required this.material,
    required this.condition,
    required this.rarity,
    required this.confidence,
    required this.value,
    this.mint,
    this.diameterMm,
    this.weightG,
    this.alternativeMatches = const [],
  });

  final String coinName;
  final String country;
  final int? year;
  final String denomination;
  final String material;
  final CoinCondition condition;
  final CoinRarity rarity;

  /// 0–1. Below [lowConfidenceThreshold] the UI must show possible matches
  /// instead of asserting a single identification (product spec §27).
  final double confidence;
  final ValueEstimate value;
  final String? mint;
  final double? diameterMm;
  final double? weightG;
  final List<CoinMatch> alternativeMatches;

  static const double lowConfidenceThreshold = 0.7;
  bool get isConfident => confidence >= lowConfidenceThreshold;

  Map<String, Object?> toAiContext() => {
        'coin_name': coinName,
        'country': country,
        'year': year,
        'material': material,
        'estimated_condition': condition.label,
        'estimated_value_min': value.min,
        'estimated_value_max': value.max,
        'rarity': rarity.label,
        'mint': mint,
      };

  @override
  List<Object?> get props =>
      [coinName, country, year, denomination, material, condition, rarity, confidence, value];
}

/// A persisted scan: identification plus the captured images and metadata.
class ScanRecord extends Equatable {
  const ScanRecord({
    required this.id,
    required this.identification,
    required this.createdAt,
    this.frontImagePath,
    this.backImagePath,
    this.savedToCollection = false,
  });

  final String id;
  final CoinIdentification identification;
  final DateTime createdAt;
  final String? frontImagePath;
  final String? backImagePath;
  final bool savedToCollection;

  ScanRecord copyWith({bool? savedToCollection}) => ScanRecord(
        id: id,
        identification: identification,
        createdAt: createdAt,
        frontImagePath: frontImagePath,
        backImagePath: backImagePath,
        savedToCollection: savedToCollection ?? this.savedToCollection,
      );

  @override
  List<Object?> get props => [id, identification, createdAt, savedToCollection];
}
