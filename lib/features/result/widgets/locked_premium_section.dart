import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// The free-user upsell block on the result screen (product spec §13). Shows a
/// blurred preview of the Premium value so the user sees what they'd unlock.
class LockedPremiumSection extends StatelessWidget {
  const LockedPremiumSection({super.key, required this.onUnlock});
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    const features = [
      ('🧠', 'The complete history'),
      ('💎', 'Why collectors value it'),
      ('📊', 'Rarity analysis'),
      ('🔎', 'Condition insights'),
      ('💰', 'How to sell it'),
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
                  'This coin was issued during a period of post-war monetary '
                  'reform, when the mint reintroduced silver circulation '
                  'coinage for the first time in years. Collectors value it '
                  'for…',
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
                  Text('Unlock AI Coin Intelligence',
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
                    child: const Text('Unlock Premium'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
