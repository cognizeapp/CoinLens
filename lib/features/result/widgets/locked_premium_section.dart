import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/l10n_extensions.dart';

/// The free-user upsell block on the result screen (product spec §13). Shows a
/// blurred preview of the Premium value so the user sees what they'd unlock.
class LockedPremiumSection extends StatelessWidget {
  const LockedPremiumSection({super.key, required this.onUnlock});
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final features = [
      ('🧠', l.aiFeatHistory),
      ('💎', l.aiFeatValue),
      ('📊', l.aiFeatRarity),
      ('🔎', l.aiFeatCondition),
      ('💰', l.aiFeatSelling),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Blurred "preview" text sitting behind the lock overlay.
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Text(
                  '${l.coinStory} · ${l.whyItHasValue} · ${l.rarityAnalysis} '
                  '· ${l.conditionEstimate} · ${l.sellingRecommendations} · '
                  '${l.collectorInsights}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          Container(
            color: AppColors.card.withValues(alpha: 0.72),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  const Icon(Icons.auto_awesome_rounded,
                      color: AppColors.gold, size: 28),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l.unlockAiTitle,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  ...features.map((f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(f.$1),
                            const SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: Text(f.$2,
                                  style:
                                      Theme.of(context).textTheme.bodyLarge),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: onUnlock,
                    child: Text(l.unlockPremium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
