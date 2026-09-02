import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/coin_models.dart';

Color rarityColor(CoinRarity r) => switch (r) {
      CoinRarity.common => AppColors.rarityCommon,
      CoinRarity.uncommon => AppColors.rarityUncommon,
      CoinRarity.rare => AppColors.rarityRare,
      CoinRarity.veryRare => AppColors.rarityVeryRare,
      CoinRarity.extremelyRare => AppColors.rarityExtremelyRare,
    };

class RarityChip extends StatelessWidget {
  const RarityChip({super.key, required this.rarity});
  final CoinRarity rarity;

  @override
  Widget build(BuildContext context) {
    final color = rarityColor(rarity);
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        rarity.label,
        style: TextStyle(
            color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class ConfidenceBadge extends StatelessWidget {
  const ConfidenceBadge({super.key, required this.confidence});
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final low = confidence < CoinIdentification.lowConfidenceThreshold;
    final color = low ? AppColors.warning : AppColors.success;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(low ? Icons.help_outline_rounded : Icons.verified_rounded,
            size: 15, color: color),
        const SizedBox(width: 5),
        Text(
          '${formatConfidence(confidence)} confidence',
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class CoinThumb extends StatelessWidget {
  const CoinThumb({super.key, this.imagePath, this.size = 52});
  final String? imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.border),
        gradient: const RadialGradient(
          colors: [Color(0xFF2A2F3A), AppColors.backgroundSecondary],
        ),
      ),
      child: const Icon(Icons.paid_rounded, color: AppColors.gold),
    );
  }
}

/// Compact scan row for History / Collection lists.
class ScanListTile extends StatelessWidget {
  const ScanListTile({
    super.key,
    required this.record,
    required this.money,
    this.onTap,
  });

  final ScanRecord record;
  final MoneyFormatter money;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final id = record.identification;
    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 6),
      leading: CoinThumb(imagePath: record.frontImagePath),
      title: Text(id.coinName,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        '${id.country}${id.year != null ? ' • ${id.year}' : ''}  ·  ${formatScanDate(record.createdAt)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(money.range(id.value.min, id.value.max),
              style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
          const SizedBox(height: 3),
          Text(id.rarity.label,
              style: TextStyle(color: rarityColor(id.rarity), fontSize: 11)),
        ],
      ),
    );
  }
}
