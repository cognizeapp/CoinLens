import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../coin/domain/catalog_entry.dart';
import '../coin/domain/coin_models.dart';
import '../coin/presentation/coin_providers.dart';

/// The three ranking lists shown on the Rankings screen. Driven entirely by the
/// reference catalog — no scan data, no personalisation.
enum RankingCategory { mostValuable, rarest, keyDates }

extension RankingCategoryX on RankingCategory {
  String get titleKey => switch (this) {
        RankingCategory.mostValuable => 'rankingsMostValuable',
        RankingCategory.rarest => 'rankingsRarest',
        RankingCategory.keyDates => 'rankingsKeyDates',
      };
}

final _catalogEntriesProvider = FutureProvider<List<CatalogEntry>>((ref) {
  return ref.watch(coinCatalogProvider).all();
});

final rankingProvider = FutureProvider.family<List<CatalogEntry>, RankingCategory>(
  (ref, category) async {
    final all = await ref.watch(_catalogEntriesProvider.future);
    final list = [...all];
    switch (category) {
      case RankingCategory.mostValuable:
        list.sort((a, b) => b.baseValueEur.compareTo(a.baseValueEur));
        return list.take(25).toList();
      case RankingCategory.rarest:
        final rare = list
            .where((e) => e.baseRarity.index >= CoinRarity.rare.index)
            .toList()
          ..sort((a, b) {
            final r = b.baseRarity.index - a.baseRarity.index;
            return r != 0 ? r : b.baseValueEur.compareTo(a.baseValueEur);
          });
        return rare.take(25).toList();
      case RankingCategory.keyDates:
        final keys = list.where((e) => e.keyDates.isNotEmpty).toList()
          ..sort((a, b) => b.baseValueEur.compareTo(a.baseValueEur));
        return keys.take(25).toList();
    }
  },
);

final catalogEntryByIdProvider =
    FutureProvider.family<CatalogEntry?, String>((ref, id) async {
  final all = await ref.watch(_catalogEntriesProvider.future);
  return all.firstWhereOrNull((e) => e.id == id);
});
