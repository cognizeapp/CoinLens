import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'captured_image.dart';

/// The circular framing target used to position a coin. Shows a pulsing gold
/// ring until an image is captured, then the captured image with an optional
/// quality warning badge.
class CoinCaptureTarget extends StatefulWidget {
  const CoinCaptureTarget({
    super.key,
    required this.label,
    required this.captured,
    required this.onTap,
    this.imagePath,
    this.warning,
  });

  final String label;
  final bool captured;
  final VoidCallback onTap;
  final String? imagePath;

  /// Short quality-issue label; when set, a warning chip is shown.
  final String? warning;

  @override
  State<CoinCaptureTarget> createState() => _CoinCaptureTargetState();
}

class _CoinCaptureTargetState extends State<CoinCaptureTarget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.imagePath != null;
    final ringColor = widget.warning != null
        ? AppColors.warning
        : widget.captured
            ? AppColors.success
            : AppColors.gold;

    return GestureDetector(
      onTap: widget.onTap,
      child: AspectRatio(
        aspectRatio: 1.9,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (hasImage)
                Opacity(
                    opacity: 0.9,
                    child: CapturedImage(path: widget.imagePath!)),
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, _) {
                  final t =
                      widget.captured ? 1.0 : (0.85 + _pulse.value * 0.15);
                  return Container(
                    width: 108 * t,
                    height: 108 * t,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasImage
                          ? null
                          : AppColors.background.withValues(alpha: 0.2),
                      border: Border.all(
                        color: widget.captured
                            ? ringColor
                            : AppColors.gold
                                .withValues(alpha: 0.5 + _pulse.value * 0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      widget.captured
                          ? (widget.warning != null
                              ? Icons.priority_high_rounded
                              : Icons.check_rounded)
                          : Icons.add_a_photo_outlined,
                      color: widget.captured ? ringColor : AppColors.gold,
                    ),
                  );
                },
              ),
              if (widget.warning != null)
                Positioned(
                  top: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      'Tap to retake · ${widget.warning}',
                      style: const TextStyle(
                          color: AppColors.warning,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              Positioned(
                bottom: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(widget.label,
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
