import 'catalog_entry.dart';
import 'coin_models.dart';

export 'coin_models.dart' show ValueFactor, ValueImpact;

/// Produces the estimated market value for an identified coin. The catalog
/// implementation is transparent and rule-based; a networked service using
/// live auction / sales data replaces it behind this interface.
abstract interface class ValueEstimationService {
  ValueEstimate estimate({
    required CatalogEntry entry,
    required int? year,
    required CoinCondition condition,
    required CoinRarity rarity,
    String? mint,
  });
}
