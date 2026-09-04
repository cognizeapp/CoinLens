import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../l10n/app_localizations.dart';
import 'domain/coin_face.dart';
import 'domain/image_quality.dart';
import 'presentation/camera_capture_page.dart';
import 'scan_controller.dart';
import 'widgets/analysis_overlay.dart';
import 'widgets/coin_capture_target.dart';
import 'widgets/quality_feedback_sheet.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  final _picker = ImagePicker();

  void _store(
      CoinFace face, String path, Uint8List bytes, ImageQualityReport? report) {
    final controller = ref.read(scanControllerProvider.notifier);
    if (face.isFront) {
      controller.setFront(path, bytes, report: report);
    } else {
      controller.setBack(path, bytes, report: report);
    }
  }

  Future<void> _fromCamera(CoinFace face) async {
    final result = await Navigator.of(context).push<CaptureResult>(
      MaterialPageRoute(builder: (_) => CameraCapturePage(face: face)),
    );
    if (result == null || !mounted) return;
    _store(face, result.path, result.bytes, result.report);
  }

  Future<void> _fromLibrary(CoinFace face) async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000,
        imageQuality: 90,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      final report =
          await ref.read(scanControllerProvider.notifier).inspect(bytes);
      if (!mounted) return;
      if (report != null && !report.passed) {
        final accepted = await showQualityFeedbackSheet(context, report);
        if (accepted != true) return;
      }
      if (mounted) _store(face, file.path, bytes, report);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.couldNotOpenImage)),
        );
      }
    }
  }

  void _sourceSheet(CoinFace face) {
    final l = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded,
                    color: AppColors.gold),
                title: Text(l.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _fromCamera(face);
                },
              ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: AppColors.gold),
              title: Text(l.uploadFromLibrary),
              onTap: () {
                Navigator.pop(context);
                _fromLibrary(face);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(scanControllerProvider);

    ref.listen(scanControllerProvider, (prev, next) {
      if (next.resultId != null && next.resultId != prev?.resultId) {
        context.push('/result/${next.resultId}');
        ref.read(scanControllerProvider.notifier).reset();
      }
      if (next.failure != null && next.failure != prev?.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.failure!.localized(l))),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l.scanTitle),
        actions: [
          if (state.hasFront)
            TextButton(
              onPressed: () => ref.read(scanControllerProvider.notifier).reset(),
              child: Text(l.scanReset),
            ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            children: [
              CoinCaptureTarget(
                label: state.hasFront ? l.scanFrontShort : l.scanFront,
                captured: state.hasFront,
                imagePath: state.frontImagePath,
                warning: _warningFor(state.frontReport, l),
                onTap: () => _sourceSheet(CoinFace.front),
              ),
              const SizedBox(height: AppSpacing.lg),
              CoinCaptureTarget(
                label: state.backImagePath != null
                    ? l.scanBackShort
                    : l.scanBack,
                captured: state.backImagePath != null,
                imagePath: state.backImagePath,
                warning: _warningFor(state.backReport, l),
                onTap: () => _sourceSheet(CoinFace.back),
              ),
              const SizedBox(height: AppSpacing.xl),
              const _Tips(),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: state.hasFront && !state.isAnalyzing
                    ? () => ref.read(scanControllerProvider.notifier).analyze()
                    : null,
                child: Text(l.identifyCoin),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '${l.valueDisclaimer}\n\n${l.gradingDisclaimer}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          if (state.isAnalyzing) AnalysisOverlay(stage: state.stage),
        ],
      ),
    );
  }

  String? _warningFor(ImageQualityReport? report, AppLocalizations l) {
    if (report == null || report.passed) return null;
    return report.primaryIssue?.localizedShort(l);
  }
}

class _Tips extends StatelessWidget {
  const _Tips();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final tips = [
      l.tipPlainBackground,
      l.tipWholeCoin,
      l.tipLighting,
      l.tipGlare,
    ];
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
          Text(l.forBestResult,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final t in tips)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline_rounded,
                      size: 16, color: AppColors.success),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                      child: Text(t,
                          style: Theme.of(context).textTheme.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
