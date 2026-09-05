import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/utils/money_provider.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/state_views.dart';
import '../../l10n/app_localizations.dart';
import '../coin/domain/coin_models.dart';
import '../coin/presentation/coin_providers.dart';
import '../coin/presentation/widgets/coin_widgets.dart';
import '../../services/subscription/subscription_service.dart';

enum _View { grid, list }

enum _Sort { recent, valueHigh, rarity }

String _sortLabel(_Sort s, AppLocalizations l) => switch (s) {
      _Sort.recent => l.sortRecent,
      _Sort.valueHigh => l.sortValueHigh,
      _Sort.rarity => l.sortRarity,
    };

final _collectionViewProvider = StateProvider<_View>((_) => _View.grid);
final _collectionQueryProvider = StateProvider<String>((_) => '');
final _collectionSortProvider = StateProvider<_Sort>((_) => _Sort.recent);
final _collectionRarityProvider = StateProvider<CoinRarity?>((_) => null);
final _collectionCountryProvider = StateProvider<String?>((_) => null);

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final collection = ref.watch(collectionProvider);
    final view = ref.watch(_collectionViewProvider);
    final query = ref.watch(_collectionQueryProvider).toLowerCase();
    final sort = ref.watch(_collectionSortProvider);
    final rarityFilter = ref.watch(_collectionRarityProvider);
    final countryFilter = ref.watch(_collectionCountryProvider);
    final money = ref.watch(moneyFormatterProvider);
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandMark(size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text(l.collectionTitle),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(view == _View.grid
                ? Icons.view_list_rounded
                : Icons.grid_view_rounded),
            tooltip: l.collectionManage,
            onPressed: () => ref.read(_collectionViewProvider.notifier).state =
                view == _View.grid ? _View.list : _View.grid,
          ),
          IconButton(
            icon: const Icon(Icons.add_a_photo_rounded),
            tooltip: l.collectionAddCoin,
            onPressed: () => context.go('/scan'),
          ),
        ],
      ),
      body: collection.when(
        loading: () => const LoadingView(),
        error: (_, __) => ErrorStateView(
          message: l.collectionLoadError,
          onRetry: () => ref.refresh(collectionProvider),
        ),
        data: (all) {
          final countries =
              {for (final s in all) s.identification.country}.toList()..sort();
          final items = all.where((s) {
            final id = s.identification;
            if (query.isNotEmpty &&
                !id.coinName.toLowerCase().contains(query) &&
                !id.country.toLowerCase().contains(query)) {
              return false;
            }
            if (rarityFilter != null && id.rarity != rarityFilter) return false;
            if (countryFilter != null && id.country != countryFilter) {
              return false;
            }
            return true;
          }).toList();

          switch (sort) {
            case _Sort.recent:
              items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            case _Sort.valueHigh:
              items.sort((a, b) => b.identification.value.typical
                  .compareTo(a.identification.value.typical));
            case _Sort.rarity:
              items.sort((a, b) =>
                  b.identification.rarity.index -
                  a.identification.rarity.index);
          }

          if (all.isEmpty) {
            return EmptyStateView(
              title: l.collectionEmpty,
              subtitle: l.collectionEmptyBody,
              icon: Icons.grid_view_rounded,
              action: FilledButton(
                onPressed: () => context.go('/scan'),
                child: Text(l.scanACoin),
              ),
            );
          }

          return Column(
            children: [
              _PortfolioHeader(items: all, money: money),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
                child: TextField(
                  onChanged: (v) =>
                      ref.read(_collectionQueryProvider.notifier).state = v,
                  decoration: InputDecoration(
                    hintText: l.searchCoinCountry,
                    prefixIcon: const Icon(Icons.search_rounded),
                    isDense: true,
                  ),
                ),
              ),
              _FilterBar(
                sort: sort,
                rarity: rarityFilter,
                country: countryFilter,
                countries: countries,
                onSort: (s) =>
                    ref.read(_collectionSortProvider.notifier).state = s,
                onRarity: (r) =>
                    ref.read(_collectionRarityProvider.notifier).state = r,
                onCountry: (c) =>
                    ref.read(_collectionCountryProvider.notifier).state = c,
              ),
              if (isPremium) _CollectionInsights(items: all, money: money),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xs),
                child: Row(
                  children: [
                    const Icon(Icons.swipe_rounded,
                        size: 13, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        view == _View.list
                            ? l.collectionEditHintList
                            : l.collectionEditHintGrid,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? EmptyStateView(
                        title: l.noMatchFilters,
                        icon: Icons.filter_alt_off_rounded,
                      )
                    : view == _View.grid
                        ? _Grid(items: items, money: money)
                        : _List(items: items, money: money),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The "remove this coin from the collection?" confirmation dialog.
Future<bool> confirmRemoveCoin(BuildContext context, ScanRecord record) async {
  final l = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.collectionRemoveTitle),
      content: Text(l.collectionRemoveBody(record.identification.coinName)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.collectionRemoveAction),
        ),
      ],
    ),
  );
  return confirmed == true;
}

/// Drops a coin from the saved collection (its scan stays in History) and
/// shows an Undo. Assumes the caller already confirmed.
Future<void> applyRemoveCoin(
  BuildContext context,
  WidgetRef ref,
  ScanRecord record,
) async {
  final l = context.l10n;
  final repo = ref.read(scanRepositoryProvider);
  final result = await repo.removeFromCollection(record.id);
  if (!context.mounted) return;
  result.when(
    ok: (_) {
      HapticFeedback.mediumImpact();
      ref.invalidate(collectionProvider);
      ref.invalidate(recentScansProvider);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.collectionRemovedToast),
          action: SnackBarAction(
            label: l.actionUndo,
            onPressed: () async {
              await repo.addToCollection(record.id);
              ref.invalidate(collectionProvider);
              ref.invalidate(recentScansProvider);
            },
          ),
        ));
    },
    err: (f) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(f.localized(context.l10n)))),
  );
}

/// Confirm + remove, for the grid long-press sheet.
Future<void> removeCoinFromCollection(
  BuildContext context,
  WidgetRef ref,
  ScanRecord record,
) async {
  if (!await confirmRemoveCoin(context, record)) return;
  if (context.mounted) await applyRemoveCoin(context, ref, record);
}

/// Long-press menu for a collected coin: open its result, or remove it.
void _showCoinActions(BuildContext context, WidgetRef ref, ScanRecord record) {
  final l = context.l10n;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.backgroundSecondary,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text(record.identification.coinName,
                      style: Theme.of(ctx).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.open_in_new_rounded, color: AppColors.gold),
            title: Text(l.actionOpen),
            onTap: () {
              Navigator.pop(ctx);
              context.push('/result/${record.id}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded,
                color: AppColors.danger),
            title: Text(l.collectionRemoveAction,
                style: const TextStyle(color: AppColors.danger)),
            onTap: () {
              Navigator.pop(ctx);
              removeCoinFromCollection(context, ref, record);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    ),
  );
}

/// The "coin portfolio" summary — total estimated value plus counts, shown to
/// everyone at the top of the collection. Individual coin values live on each
/// tile below.
class _PortfolioHeader extends StatelessWidget {
  const _PortfolioHeader({required this.items, required this.money});
  final List<ScanRecord> items;
  final MoneyFormatter money;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final total =
        items.fold<double>(0, (s, r) => s + r.identification.value.typical);
    final countries = items.map((r) => r.identification.country).toSet().length;
    final top = items.isEmpty
        ? null
        : items.reduce((a, b) =>
            a.identification.value.typical >= b.identification.value.typical
                ? a
                : b);

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1E08), AppColors.card],
        ),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.portfolioLabel,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.gold, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(
            money.single(total),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _PortfolioStat(value: '${items.length}', label: l.portfolioCoins),
              Container(
                width: 1,
                height: 30,
                color: AppColors.border,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              ),
              _PortfolioStat(value: '$countries', label: l.portfolioCountries),
              if (top != null) ...[
                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                ),
                _PortfolioStat(
                  value: money.compact(top.identification.value.typical),
                  label: l.portfolioTopCoin,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PortfolioStat extends StatelessWidget {
  const _PortfolioStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _CollectionInsights extends StatelessWidget {
  const _CollectionInsights({required this.items, required this.money});
  final List<ScanRecord> items;
  final MoneyFormatter money;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final l = context.l10n;
    final total =
        items.fold<double>(0, (sum, s) => sum + s.identification.value.typical);
    final mostValuable = items.reduce((a, b) =>
        a.identification.value.typical > b.identification.value.typical
            ? a
            : b);
    final rarest = items.reduce((a, b) =>
        a.identification.rarity.index >= b.identification.rarity.index ? a : b);

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Row(children: [
            _Stat(label: l.statCoins, value: '${items.length}'),
            _Stat(label: l.statEstValue, value: money.single(total)),
            _Stat(
                label: l.statMostValuable,
                value: money.single(mostValuable.identification.value.typical)),
          ]),
          const Divider(height: AppSpacing.xl),
          Row(
            children: [
              const Icon(Icons.diamond_outlined,
                  size: 16, color: AppColors.gold),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l.rarestLabel(rarest.identification.coinName,
                      rarest.identification.rarity.localizedLabel(l)),
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.sort,
    required this.rarity,
    required this.country,
    required this.countries,
    required this.onSort,
    required this.onRarity,
    required this.onCountry,
  });

  final _Sort sort;
  final CoinRarity? rarity;
  final String? country;
  final List<String> countries;
  final ValueChanged<_Sort> onSort;
  final ValueChanged<CoinRarity?> onRarity;
  final ValueChanged<String?> onCountry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          for (final s in _Sort.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(_sortLabel(s, l)),
                selected: sort == s,
                onSelected: (_) => onSort(s),
              ),
            ),
          const _Sep(),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              label: Text(rarity?.localizedLabel(l) ?? l.filterRarity),
              selected: rarity != null,
              onSelected: (_) async {
                final picked = await showModalBottomSheet<CoinRarity?>(
                  context: context,
                  backgroundColor: AppColors.backgroundSecondary,
                  builder: (_) => _PickerSheet<CoinRarity>(
                    title: l.filterByRarity,
                    options: CoinRarity.values,
                    labelOf: (r) => r.localizedLabel(l),
                    current: rarity,
                  ),
                );
                onRarity(picked);
              },
            ),
          ),
          if (countries.length > 1)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: FilterChip(
                label: Text(country ?? l.filterCountry),
                selected: country != null,
                onSelected: (_) async {
                  final picked = await showModalBottomSheet<String?>(
                    context: context,
                    backgroundColor: AppColors.backgroundSecondary,
                    builder: (_) => _PickerSheet<String>(
                      title: l.filterByCountry,
                      options: countries,
                      labelOf: (c) => c,
                      current: country,
                    ),
                  );
                  onCountry(picked);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Sep extends StatelessWidget {
  const _Sep();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: VerticalDivider(width: 1),
      );
}

class _PickerSheet<T> extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.options,
    required this.labelOf,
    required this.current,
  });

  final String title;
  final List<T> options;
  final String Function(T) labelOf;
  final T? current;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          ListTile(
            title: Text(context.l10n.filterAll),
            trailing: current == null
                ? const Icon(Icons.check_rounded, color: AppColors.gold)
                : null,
            onTap: () => Navigator.pop<T?>(context, null),
          ),
          for (final o in options)
            ListTile(
              title: Text(labelOf(o)),
              trailing: current == o
                  ? const Icon(Icons.check_rounded, color: AppColors.gold)
                  : null,
              onTap: () => Navigator.pop<T?>(context, o),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _Grid extends ConsumerWidget {
  const _Grid({required this.items, required this.money});
  final List<ScanRecord> items;
  final MoneyFormatter money;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.82,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final s = items[i];
        final id = s.identification;
        return InkWell(
          onTap: () => context.push('/result/${s.id}'),
          onLongPress: () => _showCoinActions(context, ref, s),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CoinThumb(
                    size: 56,
                    imagePath: s.frontImagePath,
                    material: id.material,
                    rarity: id.rarity,
                    label: shortDenomination(id.denomination),
                    seed: id.coinName,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(id.coinName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(money.range(id.value.min, id.value.max),
                    style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                const SizedBox(height: 4),
                RarityChip(rarity: id.rarity),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.items, required this.money});
  final List<ScanRecord> items;
  final MoneyFormatter money;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) {
        final record = items[i];
        return Dismissible(
          key: ValueKey('collection-${record.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            color: AppColors.danger.withValues(alpha: 0.15),
            padding: const EdgeInsets.only(right: AppSpacing.xl),
            child: const Icon(Icons.delete_outline_rounded,
                color: AppColors.danger),
          ),
          confirmDismiss: (_) => confirmRemoveCoin(context, record),
          onDismissed: (_) => applyRemoveCoin(context, ref, record),
          child: ScanListTile(
            record: record,
            money: money,
            onTap: () => context.push('/result/${record.id}'),
          ),
        );
      },
    );
  }
}
