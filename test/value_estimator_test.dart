import 'package:coinsight/features/coin/data/catalog_value_estimator.dart';
import 'package:coinsight/features/coin/domain/catalog_entry.dart';
import 'package:coinsight/features/coin/domain/coin_models.dart';
import 'package:flutter_test/flutter_test.dart';

const _entry = CatalogEntry(
  id: 'test',
  name: 'Test Coin',
  country: 'Testland',
  denomination: '1 Unit',
  yearFrom: 1900,
  yearTo: 2000,
  material: 'Silver (.900)',
  keywords: ['TEST'],
  baseValueEur: 20,
  baseRarity: CoinRarity.common,
  mintMarks: ['D'],
  keyDates: [1916],
);

void main() {
  const estimator = CatalogValueEstimator();

  test('better condition yields a higher typical value', () {
    final fine = estimator.estimate(
      entry: _entry,
      year: 1950,
      condition: CoinCondition.fine,
      rarity: CoinRarity.common,
    );
    final unc = estimator.estimate(
      entry: _entry,
      year: 1950,
      condition: CoinCondition.uncirculated,
      rarity: CoinRarity.common,
    );
    expect(unc.typical, greaterThan(fine.typical));
  });

  test('a key date carries a large premium and widens the range', () {
    final regular = estimator.estimate(
      entry: _entry,
      year: 1950,
      condition: CoinCondition.veryFine,
      rarity: CoinRarity.common,
    );
    final key = estimator.estimate(
      entry: _entry,
      year: 1916,
      condition: CoinCondition.veryFine,
      rarity: CoinRarity.common,
    );
    expect(key.typical, greaterThan(regular.typical * 2));
    expect(key.max - key.min, greaterThan(regular.max - regular.min));
  });

  test('estimate always exposes explanatory factors', () {
    final e = estimator.estimate(
      entry: _entry,
      year: 1950,
      condition: CoinCondition.fine,
      rarity: CoinRarity.rare,
      mint: 'D',
    );
    expect(e.factors, isNotEmpty);
    expect(e.factors.map((f) => f.label), contains('Metal'));
    expect(e.min, lessThan(e.typical));
    expect(e.max, greaterThan(e.typical));
  });
}
