import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../domain/image_quality.dart';

/// Shows the quality issues found in a capture. Returns `true` if the user
/// chooses to use the photo anyway (only offered when nothing is a hard
/// blocker), `false`/`null` to retake.
Future<bool?> showQualityFeedbackSheet(
  BuildContext context,
  ImageQualityReport report,
) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.backgroundSecondary,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (context) => _Sheet(report: report),
  );
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.report});
  final ImageQualityReport report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final blocking = report.hasBlockingIssue;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  blocking
                      ? Icons.error_outline_rounded
                      : Icons.info_outline_rounded,
                  color: blocking ? AppColors.danger : AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  blocking ? l.qualityRetakeNeeded : l.qualityCouldBeBetter,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ...report.issues.map(
              (issue) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  ',
                        style: TextStyle(color: AppColors.textSecondary)),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: '${issue.localizedShort(l)} — ',
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(text: issue.localizedFull(l)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.qualityRetake),
            ),
            if (!blocking) ...[
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l.qualityUseAnyway),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
