import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/coin_face.dart';
import '../scan_controller.dart';
import '../widgets/coin_frame_overlay.dart';
import '../widgets/quality_feedback_sheet.dart';

/// Live camera capture for one coin face. Pops with a [CaptureResult], or
/// `null` if the user backs out.
class CameraCapturePage extends ConsumerStatefulWidget {
  const CameraCapturePage({super.key, required this.face});

  final CoinFace face;

  @override
  ConsumerState<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends ConsumerState<CameraCapturePage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initFuture;
  bool _busy = false;
  bool _permissionDenied = false;
  bool _unavailable = false;
  FlashMode _flash = FlashMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setup();
  }

  Future<void> _setup() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _unavailable = true);
        return;
      }
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _controller = controller;
      _initFuture = controller.initialize();
      await _initFuture;
      if (mounted) setState(() {});
    } on CameraException catch (e) {
      final denied = e.code == 'CameraAccessDenied' ||
          e.code == 'CameraAccessDeniedWithoutPrompt' ||
          e.code == 'CameraAccessRestricted';
      setState(() {
        _permissionDenied = denied;
        _unavailable = !denied;
      });
    } catch (_) {
      setState(() => _unavailable = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _setup();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null) return;
    final next = switch (_flash) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.torch,
      _ => FlashMode.off,
    };
    await controller.setFlashMode(next);
    setState(() => _flash = next);
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || _busy || !controller.value.isInitialized) return;
    setState(() => _busy = true);
    try {
      final shot = await controller.takePicture();
      final bytes = await shot.readAsBytes();
      final report =
          await ref.read(scanControllerProvider.notifier).inspect(bytes);

      if (!mounted) return;
      if (report != null && !report.passed) {
        final accepted = await showQualityFeedbackSheet(context, report);
        if (accepted != true) {
          setState(() => _busy = false);
          return; // stay on camera for a retake
        }
      }
      if (mounted) {
        Navigator.of(context).pop(CaptureResult(shot.path, bytes, report));
      }
    } on CameraException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not take the photo. Try again.')),
        );
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(widget.face.prompt),
        actions: [
          if (_controller?.value.isInitialized ?? false)
            IconButton(
              onPressed: _toggleFlash,
              icon: Icon(switch (_flash) {
                FlashMode.off => Icons.flash_off_rounded,
                FlashMode.auto => Icons.flash_auto_rounded,
                _ => Icons.flash_on_rounded,
              }),
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_permissionDenied) {
      return _CameraMessage(
        icon: Icons.no_photography_rounded,
        title: 'Camera access is off',
        message:
            'Enable camera access for Coinsight in your device Settings, then '
            'come back to scan. You can also upload a photo instead.',
        actionLabel: 'Use a photo instead',
        onAction: () => Navigator.of(context).pop(),
      );
    }
    if (_unavailable) {
      return _CameraMessage(
        icon: Icons.videocam_off_rounded,
        title: 'No camera available',
        message: 'This device has no usable camera. Upload a photo instead.',
        actionLabel: 'Upload a photo',
        onAction: () => Navigator.of(context).pop(),
      );
    }

    final controller = _controller;
    if (controller == null || _initFuture == null) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.gold));
    }

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done ||
            !controller.value.isInitialized) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.gold));
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.previewSize?.height ?? 1,
                height: controller.value.previewSize?.width ?? 1,
                child: CameraPreview(controller),
              ),
            ),
            CoinFrameOverlay(active: !_busy),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _CaptureBar(busy: _busy, onCapture: _capture),
            ),
          ],
        );
      },
    );
  }
}

class _CaptureBar extends StatelessWidget {
  const _CaptureBar({required this.busy, required this.onCapture});
  final bool busy;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Fill the circle · plain background · steady hands',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.lg),
          GestureDetector(
            onTap: busy ? null : onCapture,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: busy ? 0.4 : 1),
                border: Border.all(color: AppColors.gold, width: 4),
              ),
              child: busy
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.gold),
                    )
                  : const Icon(Icons.camera_alt_rounded,
                      color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraMessage extends StatelessWidget {
  const _CameraMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white54, size: 46),
            const SizedBox(height: AppSpacing.lg),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
