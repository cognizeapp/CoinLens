import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../coin/domain/identification_service.dart';

/// Full-screen "Analyzing coin…" animation (product spec §19). Reveals each
/// pipeline stage with a check as it completes.
class AnalysisOverlay extends StatelessWidget {
  const AnalysisOverlay({super.key, required this.stage});

  final IdentificationStage? stage;

  @override
  Widget build(BuildContext context) {
    const stages = IdentificationStage.values;
    final currentIndex = stage == null ? 0 : stages.indexOf(stage!);

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: AppColors.background.withValues(alpha: 0.86),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ScanningCoin(),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Text('Analyzing coin…',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: AppSpacing.xl),
              for (var i = 0; i < stages.length; i++)
                _StageRow(
                  label: stages[i].label,
                  done: i < currentIndex,
                  active: i == currentIndex,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow(
      {required this.label, required this.done, required this.active});
  final String label;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = done
        ? AppColors.success
        : active
            ? AppColors.gold
            : AppColors.textTertiary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: done
                ? const Icon(Icons.check_rounded,
                    size: 18, color: AppColors.success)
                : active
                    ? const CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.gold)
                    : const Icon(Icons.circle_outlined,
                        size: 16, color: AppColors.textTertiary),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _ScanningCoin extends StatefulWidget {
  const _ScanningCoin();

  @override
  State<_ScanningCoin> createState() => _ScanningCoinState();
}

class _ScanningCoinState extends State<_ScanningCoin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120,
        height: 120,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 2),
                    gradient: const RadialGradient(colors: [
                      AppColors.goldSoft,
                      AppColors.background,
                    ]),
                  ),
                ),
                Positioned(
                  top: 12 + _c.value * 84,
                  left: 8,
                  right: 8,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.7),
                            blurRadius: 8),
                      ],
                    ),
                  ),
                ),
                const Icon(Icons.paid_rounded,
                    size: 44, color: AppColors.gold),
              ],
            );
          },
        ),
      ),
    );
  }
}
