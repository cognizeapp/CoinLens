import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/utils/money_provider.dart';
import '../../coin/domain/catalog_entry.dart';
import '../../coin/presentation/widgets/coin_widgets.dart';

Future<void> showRankingDetailSheet(BuildContext context, CatalogEntry entry) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.backgroundSecondary,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => _Sheet(entry: entry),
  );
}

class _Sheet extends ConsumerWidget {
  const _Sheet({required this.entry});
  final CatalogEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final money = ref.watch(moneyFormatterProvider);
    final base = entry.baseValueEur;
    // A representative spread around the Fine anchor (see CatalogValueEstimator).
    final low = money.compact(base * 0.7);
    final high = money.compact(base * 3.0);

    final rows = <(String, String)>[
      (l.detailCountry, entry.country),
      (
        l.rankYears,
        '${entry.yearFrom < 0 ? l.yearBc(-entry.yearFrom) : entry.yearFrom}'
            '${entry.yearTo != entry.yearFrom ? ' – ${entry.yearTo}' : ''}'
      ),
      (l.detailDenomination, entry.denomination),
      (l.detailMaterial, entry.material),
      if (entry.diameterMm != null) (l.detailDiameter, '${entry.diameterMm} mm'),
      if (entry.weightG != null) (l.detailWeight, '${entry.weightG} g'),
      if (entry.keyDates.isNotEmpty)
        (l.rankKeyDatesLabel, entry.keyDates.join(', ')),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CoinThumb(
                  size: 72,
                  material: entry.material,
                  rarity: entry.baseRarity,
                  label: shortDenomination(entry.denomination),
                  seed: entry.id,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 2),
                      RarityChip(rarity: entry.baseRarity),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border:
                    Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1B10), AppColors.card],
                ),
              ),
              child: Column(
                children: [
                  Text(l.typicalRange,
                      style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Text('$low – $high',
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 24,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final (k, v) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(k, style: Theme.of(context).textTheme.bodyMedium),
                    Flexible(
                      child: Text(v,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ],
                ),
              ),
            if (entry.notes != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(entry.notes!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/scan');
              },
              icon: const Icon(Icons.center_focus_strong_rounded),
              label: Text(l.scanYoursToCheck),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l.valueDisclaimer,
                style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
