import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/utils/money_provider.dart';
import '../../core/widgets/state_views.dart';
import '../../l10n/app_localizations.dart';
import '../coin/domain/catalog_entry.dart';
import '../coin/presentation/widgets/coin_widgets.dart';
import 'rankings_providers.dart';
import 'widgets/ranking_detail_sheet.dart';

class RankingsPage extends ConsumerStatefulWidget {
  const RankingsPage({super.key});

  @override
  ConsumerState<RankingsPage> createState() => _RankingsPageState();
}

class _RankingsPageState extends ConsumerState<RankingsPage> {
  RankingCategory _category = RankingCategory.mostValuable;

  String _label(RankingCategory c, AppLocalizations l) => switch (c) {
        RankingCategory.mostValuable => l.rankMostValuable,
        RankingCategory.rarest => l.rankRarest,
        RankingCategory.keyDates => l.rankKeyDates,
      };

  String _subtitle(RankingCategory c, AppLocalizations l) => switch (c) {
        RankingCategory.mostValuable => l.rankMostValuableSub,
        RankingCategory.rarest => l.rankRarestSub,
        RankingCategory.keyDates => l.rankKeyDatesSub,
      };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ranking = ref.watch(rankingProvider(_category));
    final money = ref.watch(moneyFormatterProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.rankingsTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
            child: SegmentedButton<RankingCategory>(
              segments: [
                for (final c in RankingCategory.values)
                  ButtonSegment(value: c, label: Text(_label(c, l))),
              ],
              selected: {_category},
              onSelectionChanged: (s) => setState(() => _category = s.first),
              showSelectedIcon: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              _subtitle(_category, l),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ranking.when(
              loading: () => const LoadingView(),
              error: (_, __) => ErrorStateView(
                message: l.rankLoadError,
                onRetry: () => ref.refresh(rankingProvider(_category)),
              ),
              data: (entries) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) => _RankRow(
                  rank: i + 1,
                  entry: entries[i],
                  valueText: money.compact(entries[i].baseValueEur),
                  onTap: () => showRankingDetailSheet(context, entries[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.entry,
    required this.valueText,
    required this.onTap,
  });

  final int rank;
  final CatalogEntry entry;
  final String valueText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: rank <= 3
                  ? AppColors.gold.withValues(alpha: 0.4)
                  : AppColors.border,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '$rank',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: rank <= 3 ? 18 : 15,
                      fontWeight: FontWeight.w700,
                      color: rank <= 3
                          ? AppColors.gold
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const CoinThumb(size: 40),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        '${entry.country} · ${entry.yearFrom < 0 ? context.l10n.yearBc(-entry.yearFrom) : entry.yearFrom}'
                        '${entry.yearTo != entry.yearFrom ? '–${entry.yearTo}' : ''}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(valueText,
                        style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                    const SizedBox(height: 4),
                    RarityChip(rarity: entry.baseRarity),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
