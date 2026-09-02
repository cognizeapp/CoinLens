import 'dart:typed_data';
import 'dart:ui' as ui;

import '../domain/image_quality.dart';

/// A pure-Dart, on-device image-quality gate. It decodes the photo at low
/// resolution and runs cheap classical checks:
///
///  * resolution      — original pixel dimensions
///  * exposure         — mean luminance
///  * glare            — fraction of blown-out pixels
///  * sharpness        — mean gradient energy (blur detector)
///  * subject / framing — foreground segmentation against the frame border,
///                        then connected-component analysis for "one coin,
///                        centred, large enough, and only one object"
///
/// This is deliberately conservative: it is a helpful pre-flight check, not a
/// substitute for the ML detector that the backend identification pipeline
/// runs (product spec §6, §9). All thresholds are named constants so they are
/// easy to tune against real captures.
class HeuristicImageQualityAnalyzer implements ImageQualityAnalyzer {
  const HeuristicImageQualityAnalyzer();

  static const int _sample = 200; // analysis raster is at most _sample²
  static const int _minOriginalDimension = 420;

  static const double _darkBelow = 0.20;
  static const double _brightAbove = 0.86;
  static const double _glareRatioMax = 0.06;

  /// Mean edge steepness below this reads as soft/out-of-focus. A crisp step
  /// edge scores ~0.25+, a visibly blurred one ~0.06.
  static const double _blurBelow = 0.12;
  static const double _minSubjectCoverage = 0.10;
  static const double _smallSubjectCoverage = 0.24;
  static const double _secondBlobMinCoverage = 0.03;

  @override
  Future<ImageQualityReport> analyze(Uint8List bytes) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final originalMinDim = descriptor.width < descriptor.height
        ? descriptor.width
        : descriptor.height;

    final scale = _sample / (descriptor.width > descriptor.height
        ? descriptor.width
        : descriptor.height);
    final targetW = (descriptor.width * scale).clamp(1, _sample).round();
    final targetH = (descriptor.height * scale).clamp(1, _sample).round();

    final codec = await descriptor.instantiateCodec(
      targetWidth: targetW,
      targetHeight: targetH,
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final data =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    codec.dispose();
    descriptor.dispose();
    buffer.dispose();

    if (data == null) {
      return const ImageQualityReport(
        issues: [ImageQualityIssue.lowResolution],
        blurScore: 0,
        brightness: 0,
        glareRatio: 0,
        subjectCoverage: 0,
      );
    }

    final w = image.width;
    final h = image.height;
    final rgba = data.buffer.asUint8List();
    final n = w * h;

    // --- luminance map ---
    final lum = Float32List(n);
    var sum = 0.0;
    var glare = 0;
    for (var i = 0; i < n; i++) {
      final o = i * 4;
      final l = (0.299 * rgba[o] + 0.587 * rgba[o + 1] + 0.114 * rgba[o + 2]) /
          255.0;
      lum[i] = l;
      sum += l;
      if (l > 0.96) glare++;
    }
    final brightness = sum / n;
    final glareRatio = glare / n;

    // --- sharpness: average steepness of the edges that exist ---
    // Flat regions are ignored; a blurred photo spreads each real edge over
    // more pixels, lowering its per-pixel gradient. Robust to plain
    // backgrounds, unlike a whole-frame gradient mean.
    const edgeEpsilon = 0.04;
    var edgeSum = 0.0;
    var edgeCount = 0;
    for (var y = 1; y < h - 1; y++) {
      for (var x = 1; x < w - 1; x++) {
        final i = y * w + x;
        final g = (lum[i + 1] - lum[i - 1]).abs() +
            (lum[i + w] - lum[i - w]).abs();
        if (g > edgeEpsilon) {
          edgeSum += g;
          edgeCount++;
        }
      }
    }
    final blurScore = edgeCount == 0 ? 1.0 : edgeSum / edgeCount;
    final hasEdges = edgeCount > n * 0.001;

    // --- foreground vs. border background ---
    final bg = _borderMeanColor(rgba, w, h);
    final mask = Uint8List(n);
    var subjectPixels = 0;
    for (var i = 0; i < n; i++) {
      final o = i * 4;
      final dr = (rgba[o] - bg.$1).abs();
      final dg = (rgba[o + 1] - bg.$2).abs();
      final db = (rgba[o + 2] - bg.$3).abs();
      if (dr + dg + db > 60) {
        mask[i] = 1;
        subjectPixels++;
      }
    }
    final foregroundCoverage = subjectPixels / n;
    final blobs = _largestBlobs(mask, w, h);
    final largest = blobs.isNotEmpty ? blobs[0] / n : 0.0;
    final secondLargest = blobs.length > 1 ? blobs[1] / n : 0.0;

    // --- assemble issues ---
    final issues = <ImageQualityIssue>[];
    if (originalMinDim < _minOriginalDimension) {
      issues.add(ImageQualityIssue.lowResolution);
    }
    if (brightness < _darkBelow) issues.add(ImageQualityIssue.tooDark);
    if (brightness > _brightAbove) issues.add(ImageQualityIssue.tooBright);
    if (hasEdges &&
        blurScore < _blurBelow &&
        !issues.contains(ImageQualityIssue.tooDark)) {
      issues.add(ImageQualityIssue.blurry);
    }
    if (glareRatio > _glareRatioMax) issues.add(ImageQualityIssue.glare);

    if (foregroundCoverage < _minSubjectCoverage ||
        largest < _minSubjectCoverage * 0.6) {
      issues.add(ImageQualityIssue.coinNotFound);
    } else {
      if (secondLargest > _secondBlobMinCoverage &&
          secondLargest > largest * 0.45) {
        issues.add(ImageQualityIssue.multipleCoins);
      }
      if (largest < _smallSubjectCoverage) {
        issues.add(ImageQualityIssue.coinTooSmall);
      }
    }

    issues.sort((a, b) => a.index.compareTo(b.index));

    return ImageQualityReport(
      issues: issues,
      blurScore: blurScore,
      brightness: brightness,
      glareRatio: glareRatio,
      subjectCoverage: largest,
    );
  }

  /// Mean RGB of the outer 8% frame — a robust proxy for the background.
  (int, int, int) _borderMeanColor(Uint8List rgba, int w, int h) {
    final bx = (w * 0.08).ceil();
    final by = (h * 0.08).ceil();
    var r = 0, g = 0, b = 0, c = 0;
    for (var y = 0; y < h; y++) {
      final edgeRow = y < by || y >= h - by;
      for (var x = 0; x < w; x++) {
        if (!edgeRow && x >= bx && x < w - bx) continue;
        final o = (y * w + x) * 4;
        r += rgba[o];
        g += rgba[o + 1];
        b += rgba[o + 2];
        c++;
      }
    }
    if (c == 0) return (0, 0, 0);
    return (r ~/ c, g ~/ c, b ~/ c);
  }

  /// Sizes of the largest connected components in [mask] (4-connectivity),
  /// descending. Iterative flood fill to avoid deep recursion.
  List<int> _largestBlobs(Uint8List mask, int w, int h) {
    final visited = Uint8List(mask.length);
    final sizes = <int>[];
    final stack = <int>[];
    for (var start = 0; start < mask.length; start++) {
      if (mask[start] == 0 || visited[start] == 1) continue;
      var size = 0;
      stack
        ..clear()
        ..add(start);
      visited[start] = 1;
      while (stack.isNotEmpty) {
        final p = stack.removeLast();
        size++;
        final x = p % w;
        final y = p ~/ w;
        if (x > 0 && mask[p - 1] == 1 && visited[p - 1] == 0) {
          visited[p - 1] = 1;
          stack.add(p - 1);
        }
        if (x < w - 1 && mask[p + 1] == 1 && visited[p + 1] == 0) {
          visited[p + 1] = 1;
          stack.add(p + 1);
        }
        if (y > 0 && mask[p - w] == 1 && visited[p - w] == 0) {
          visited[p - w] = 1;
          stack.add(p - w);
        }
        if (y < h - 1 && mask[p + w] == 1 && visited[p + w] == 0) {
          visited[p + w] = 1;
          stack.add(p + w);
        }
      }
      sizes.add(size);
    }
    sizes.sort((a, b) => b.compareTo(a));
    return sizes;
  }
}
