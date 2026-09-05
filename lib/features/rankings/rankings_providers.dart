import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
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

final rankingProvider =
    FutureProvider.family<List<CatalogEntry>, RankingCategory>(
  (ref, category) async {
    final all = await ref.watch(_catalogEntriesProvider.future);
    final list = [...all];
    switch (category) {
      case RankingCategory.mostValuable:
        list.sort((a, b) => b.baseValueEur.compareTo(a.baseValueEur));
        return list;
      case RankingCategory.rarest:
        final rare = list
            .where((e) => e.baseRarity.index >= CoinRarity.rare.index)
            .toList()
          ..sort((a, b) {
            final r = b.baseRarity.index - a.baseRarity.index;
            return r != 0 ? r : b.baseValueEur.compareTo(a.baseValueEur);
          });
        return rare;
      case RankingCategory.keyDates:
        final keys = list.where((e) => e.keyDates.isNotEmpty).toList()
          ..sort((a, b) => b.baseValueEur.compareTo(a.baseValueEur));
        return keys;
    }
  },
);

/// Distinct countries present in the catalog, alphabetised, for the Rankings
/// filter chips.
final rankingCountriesProvider = FutureProvider<List<String>>((ref) async {
  final all = await ref.watch(_catalogEntriesProvider.future);
  final countries = all.map((e) => e.country).toSet().toList()..sort();
  return countries;
});

/// Search text + optional country filter applied on top of [rankingProvider],
/// capped to a page of 25 for a fast, scannable list.
class RankingFilter extends Equatable {
  const RankingFilter({this.query = '', this.country});
  final String query;
  final String? country;

  RankingFilter copyWith({String? query, String? Function()? country}) =>
      RankingFilter(
        query: query ?? this.query,
        country: country != null ? country() : this.country,
      );

  bool get isActive => query.isNotEmpty || country != null;

  @override
  List<Object?> get props => [query, country];
}

final rankingFilterProvider =
    StateProvider.family<RankingFilter, RankingCategory>(
        (ref, category) => const RankingFilter());

final filteredRankingProvider =
    FutureProvider.family<List<CatalogEntry>, RankingCategory>(
        (ref, category) async {
  final all = await ref.watch(rankingProvider(category).future);
  final filter = ref.watch(rankingFilterProvider(category));
  var list = all;
  if (filter.country != null) {
    list = list.where((e) => e.country == filter.country).toList();
  }
  if (filter.query.isNotEmpty) {
    final q = filter.query.toLowerCase();
    list = list
        .where((e) =>
            e.name.toLowerCase().contains(q) ||
            e.country.toLowerCase().contains(q) ||
            e.denomination.toLowerCase().contains(q))
        .toList();
  }
  return list.take(25).toList();
});

final catalogEntryByIdProvider =
    FutureProvider.family<CatalogEntry?, String>((ref, id) async {
  final all = await ref.watch(_catalogEntriesProvider.future);
  return all.firstWhereOrNull((e) => e.id == id);
});
