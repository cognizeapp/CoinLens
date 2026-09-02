import 'dart:typed_data';

/// Problems the image-quality gate can detect before a photo is sent for
/// identification (product spec §6). Ordered roughly by how much they hurt
/// identification.
enum ImageQualityIssue {
  lowResolution,
  tooDark,
  tooBright,
  blurry,
  glare,
  coinNotFound,
  coinTooSmall,
  multipleCoins;

  /// Actionable guidance shown to the user.
  String get feedback => switch (this) {
        ImageQualityIssue.lowResolution =>
          'This image is too small. Use your camera at full quality or pick a '
              'larger photo.',
        ImageQualityIssue.tooDark =>
          'The photo is too dark. Move to brighter, even lighting.',
        ImageQualityIssue.tooBright =>
          'The photo is overexposed. Reduce direct light or move out of glare.',
        ImageQualityIssue.blurry =>
          'The image is too blurry. Hold the phone still, tap to focus, and '
              'make sure the coin is sharp.',
        ImageQualityIssue.glare =>
          'There are strong reflections on the coin. Tilt it slightly or use '
              'softer, indirect light.',
        ImageQualityIssue.coinNotFound =>
          'We could not find a coin. Place a single coin on a plain background '
              'that fills most of the frame.',
        ImageQualityIssue.coinTooSmall =>
          'Move closer so the coin fills most of the circle.',
        ImageQualityIssue.multipleCoins =>
          'We detected more than one object. Scan a single coin at a time.',
      };

  String get shortLabel => switch (this) {
        ImageQualityIssue.lowResolution => 'Low resolution',
        ImageQualityIssue.tooDark => 'Too dark',
        ImageQualityIssue.tooBright => 'Overexposed',
        ImageQualityIssue.blurry => 'Blurry',
        ImageQualityIssue.glare => 'Reflections',
        ImageQualityIssue.coinNotFound => 'No coin detected',
        ImageQualityIssue.coinTooSmall => 'Coin too small',
        ImageQualityIssue.multipleCoins => 'Multiple objects',
      };
}

/// Result of analysing one capture. [issues] empty ⇒ good to submit. Blocking
/// issues stop submission; non-blocking ones are warnings the user can accept.
class ImageQualityReport {
  const ImageQualityReport({
    required this.issues,
    required this.blurScore,
    required this.brightness,
    required this.glareRatio,
    required this.subjectCoverage,
  });

  final List<ImageQualityIssue> issues;

  /// Normalised sharpness estimate (higher = sharper). ~<0.12 reads as blurry.
  final double blurScore;

  /// Mean luminance 0–1.
  final double brightness;

  /// Fraction of near-white blown-out pixels 0–1.
  final double glareRatio;

  /// Fraction of the frame the detected subject occupies 0–1.
  final double subjectCoverage;

  bool get passed => issues.isEmpty;

  static const _blocking = {
    ImageQualityIssue.lowResolution,
    ImageQualityIssue.coinNotFound,
    ImageQualityIssue.multipleCoins,
  };

  bool get hasBlockingIssue => issues.any(_blocking.contains);

  ImageQualityIssue? get primaryIssue => issues.isEmpty ? null : issues.first;

  String get summary => primaryIssue?.feedback ?? 'Looks good.';
}

abstract interface class ImageQualityAnalyzer {
  /// [bytes] is an encoded image (JPEG/PNG). Runs on-device, no network.
  Future<ImageQualityReport> analyze(Uint8List bytes);
}
