import 'package:coinsight/core/utils/formatters.dart';
import 'package:coinsight/features/coin/domain/coin_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MoneyFormatter', () {
    test('formats a whole-number range without decimals', () {
      const money = MoneyFormatter();
      expect(money.range(25, 60), '€25 – €60');
    });

    test('respects the configured currency', () {
      const money = MoneyFormatter(currencyCode: 'USD', locale: 'en_US');
      expect(money.single(40), '\$40');
    });
  });

  group('CoinIdentification', () {
    test('confidence below threshold is flagged as not confident', () {
      const id = CoinIdentification(
        coinName: 'Test',
        country: 'Testland',
        year: 2000,
        denomination: '1 Unit',
        material: 'Copper',
        condition: CoinCondition.fine,
        rarity: CoinRarity.common,
        confidence: 0.42,
        value: ValueEstimate(min: 1, max: 2, typical: 1),
      );
      expect(id.isConfident, isFalse);
    });

    test('toAiContext exposes the structured fields the AI engine expects', () {
      const id = CoinIdentification(
        coinName: 'Italian 500 Lire',
        country: 'Italy',
        year: 1958,
        denomination: '500 Lire',
        material: 'Silver',
        condition: CoinCondition.veryFine,
        rarity: CoinRarity.uncommon,
        confidence: 0.92,
        value: ValueEstimate(min: 25, max: 60, typical: 40),
      );
      final ctx = id.toAiContext();
      expect(ctx['coin_name'], 'Italian 500 Lire');
      expect(ctx['year'], 1958);
      expect(ctx['estimated_value_max'], 60);
    });
  });
}
