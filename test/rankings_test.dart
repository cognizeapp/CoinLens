import 'package:coinsight/features/coin/data/coin_catalog.dart';
import 'package:coinsight/features/coin/domain/coin_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final catalog = AssetCoinCatalog();

  test('bundled catalog loads and has a broad set of coins', () async {
    final all = await catalog.all();
    expect(all.length, greaterThanOrEqualTo(40));
    // Every entry is well-formed.
    for (final e in all) {
      expect(e.id, isNotEmpty);
      expect(e.name, isNotEmpty);
      expect(e.country, isNotEmpty);
      expect(e.baseValueEur, greaterThan(0));
    }
    // Multiple countries represented.
    final countries = all.map((e) => e.country).toSet();
    expect(countries.length, greaterThanOrEqualTo(10));
  });

  test('most-valuable ordering surfaces the legendary rarities first',
      () async {
    final all = await catalog.all();
    final sorted = [...all]
      ..sort((a, b) => b.baseValueEur.compareTo(a.baseValueEur));
    expect(sorted.first.baseValueEur, greaterThan(1000000));
    expect(sorted.first.baseRarity, CoinRarity.extremelyRare);
  });

  test('key-date list only contains coins that actually have key dates',
      () async {
    final all = await catalog.all();
    final keyDated = all.where((e) => e.keyDates.isNotEmpty).toList();
    expect(keyDated, isNotEmpty);
    for (final e in keyDated) {
      expect(e.isKeyDate(e.keyDates.first), isTrue);
    }
  });

  test('rarity strings all map to a CoinRarity', () async {
    final all = await catalog.all();
    for (final e in all) {
      expect(CoinRarity.values.contains(e.baseRarity), isTrue);
    }
  });
}
