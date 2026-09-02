import 'package:equatable/equatable.dart';

import 'coin_models.dart';

/// One coin type in the structured reference catalog. The identification
/// pipeline matches OCR + visual signals against these; the value engine uses
/// [baseValueEur] as the anchor for a Fine-condition example.
class CatalogEntry extends Equatable {
  const CatalogEntry({
    required this.id,
    required this.name,
    required this.country,
    required this.denomination,
    required this.yearFrom,
    required this.yearTo,
    required this.material,
    required this.keywords,
    required this.baseValueEur,
    required this.baseRarity,
    this.diameterMm,
    this.weightG,
    this.mintMarks = const [],
    this.keyDates = const [],
    this.notes,
  });

  final String id;
  final String name;
  final String country;
  final String denomination;
  final int yearFrom;
  final int yearTo;
  final String material;

  /// Legend / design tokens expected on the coin, upper-cased (e.g. "LIRE",
  /// "REPVBBLICA", "LIBERTY", "ELIZABETH").
  final List<String> keywords;

  /// Typical retail value in EUR for a problem-free Fine example.
  final double baseValueEur;
  final CoinRarity baseRarity;

  final double? diameterMm;
  final double? weightG;
  final List<String> mintMarks;

  /// Years that carry a strong premium (key dates, low mintages, error years).
  final List<int> keyDates;
  final String? notes;

  bool coversYear(int? year) =>
      year != null && year >= yearFrom && year <= yearTo;

  bool isKeyDate(int? year) => year != null && keyDates.contains(year);

  factory CatalogEntry.fromJson(Map<String, dynamic> json) => CatalogEntry(
        id: json['id'] as String,
        name: json['name'] as String,
        country: json['country'] as String,
        denomination: json['denomination'] as String,
        yearFrom: json['year_from'] as int,
        yearTo: json['year_to'] as int,
        material: json['material'] as String,
        keywords: (json['keywords'] as List<dynamic>).cast<String>(),
        baseValueEur: (json['base_value_eur'] as num).toDouble(),
        baseRarity: CoinRarity.fromName(json['rarity'] as String?),
        diameterMm: (json['diameter_mm'] as num?)?.toDouble(),
        weightG: (json['weight_g'] as num?)?.toDouble(),
        mintMarks:
            (json['mint_marks'] as List<dynamic>?)?.cast<String>() ?? const [],
        keyDates:
            (json['key_dates'] as List<dynamic>?)?.cast<int>() ?? const [],
        notes: json['notes'] as String?,
      );

  @override
  List<Object?> get props => [id];
}
