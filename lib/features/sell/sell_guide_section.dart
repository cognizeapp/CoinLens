import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/l10n_extensions.dart';
import 'sell_guide.dart';

/// "Where to sell this coin" — a curated marketplace directory plus a
/// realistic private-sale estimate from our own value model. Free users see
/// the estimate and the top two venues; Premium unlocks the full list with
/// notes and the value-tier selling tips.
class SellGuideSection extends StatelessWidget {
  const SellGuideSection({
    super.key,
    required this.typicalValueEur,
    required this.money,
    required this.isPremium,
    required this.onUnlock,
  });

  final double typicalValueEur;
  final MoneyFormatter money;
  final bool isPremium;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final guide = SellGuide.forValue(typicalValueEur);
    final visible =
        isPremium ? guide.marketplaces : guide.marketplaces.take(2).toList();
    final hidden = guide.marketplaces.length - visible.length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sell_outlined, color: AppColors.gold, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(l.sellGuideTitle,
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              color: AppColors.backgroundSecondary,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.sellGuideResaleLabel,
                    style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 2),
                Text(
                  money.range(guide.resaleLowEur, guide.resaleHighEur),
                  style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(l.sellGuideResaleNote,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline_rounded,
                  size: 15, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(guide.tierAdvice(l),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final m in visible)
            _MarketplaceRow(marketplace: m, showBlurb: isPremium),
          if (!isPremium && hidden > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            InkWell(
              onTap: onUnlock,
              child: Row(
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 15, color: AppColors.gold),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l.sellGuideUnlock(hidden),
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(l.sellGuideDisclaimer,
              style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _MarketplaceRow extends StatelessWidget {
  const _MarketplaceRow({required this.marketplace, required this.showBlurb});
  final Marketplace marketplace;
  final bool showBlurb;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final url = marketplace.url;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(marketplace.icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(marketplace.name(l),
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    if (url != null) ...[
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication),
                        child: const Icon(Icons.open_in_new_rounded,
                            size: 13, color: AppColors.blue),
                      ),
                    ],
                  ],
                ),
                if (showBlurb)
                  Text(marketplace.blurb(l),
                      style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
