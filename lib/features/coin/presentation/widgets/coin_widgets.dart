import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/l10n_extensions.dart';
import '../../data/reference_coin_images.dart';
import '../../domain/coin_models.dart';
import 'coin_mockup.dart';

/// Shortens a denomination string ("20 Dollars", "1 Lira") to a compact
/// engraving glyph ("20", "1") for the generated coin mockup.
String shortDenomination(String denomination) {
  final match = RegExp(r'^[\p{Sc}]?\s*[\d.,/]+', unicode: true)
      .firstMatch(denomination);
  final token = (match?.group(0) ?? denomination).trim();
  return token.length > 5 ? token.substring(0, 5) : token;
}

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
        rarity.localizedLabel(context.l10n),
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
          context.l10n.confidenceValue(formatConfidence(confidence)),
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// A coin's visual, in priority order: the user's own photo framed as a coin,
/// a bundled real reference photo for well-known catalog coins, a generated
/// metallic mockup from [material]/[rarity], or (nothing available) a plain
/// placeholder disc.
class CoinThumb extends StatelessWidget {
  const CoinThumb({
    super.key,
    this.imagePath,
    this.material,
    this.rarity,
    this.label,
    this.seed = '',
    this.size = 52,
    this.referenceImageAsset,
  });

  final String? imagePath;
  final String? material;
  final CoinRarity? rarity;
  final String? label;
  final String seed;
  final double size;

  /// Bundled asset path (see [referenceCoinImageAsset]) for a real,
  /// openly-licensed photo of this coin type — used on Rankings, where every
  /// entry is a well-known catalog coin rather than the user's own capture.
  final String? referenceImageAsset;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      final file = File(imagePath!);
      if (file.existsSync()) {
        return CoinPhotoMockup(
          image: FileImage(file),
          rarity: rarity,
          size: size,
        );
      }
    }
    if (referenceImageAsset != null) {
      return CoinPhotoMockup(
        image: AssetImage(referenceImageAsset!),
        rarity: rarity,
        size: size,
        alignment: referenceCoinImageAlignment(referenceImageAsset!),
      );
    }
    if (material != null && rarity != null) {
      return CoinMockup(
        material: material!,
        rarity: rarity!,
        label: label,
        seed: seed,
        size: size,
      );
    }
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
      leading: CoinThumb(
        imagePath: record.frontImagePath,
        material: id.material,
        rarity: id.rarity,
        label: shortDenomination(id.denomination),
        seed: id.coinName,
      ),
      title: Text(id.coinName,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        '${id.country}${id.year != null ? ' • ${id.year}' : ''}  ·  ${formatScanDate(record.createdAt, context.l10n)}',
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
          Text(id.rarity.localizedLabel(context.l10n),
              style: TextStyle(color: rarityColor(id.rarity), fontSize: 11)),
        ],
      ),
    );
  }
}
