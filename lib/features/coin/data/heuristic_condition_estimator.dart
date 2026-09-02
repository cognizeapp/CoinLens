import 'dart:typed_data';
import 'dart:ui' as ui;

import '../domain/coin_models.dart';
import '../domain/condition_estimator.dart';

/// Photo-only wear estimate. It measures how much fine surface detail survives
/// (worn coins go smooth) and how much specular highlight is present (mint
/// luster), then maps a composite score onto the grading scale. This is a
/// heuristic proxy, deliberately conservative, and always presented as
/// approximate — not a substitute for professional grading.
class HeuristicConditionEstimator implements ConditionEstimator {
  const HeuristicConditionEstimator();

  static const int _sample = 220;

  @override
  Future<ConditionEstimate> estimate(Uint8List bytes) async {
    final ui.Image image;
    try {
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: _sample,
        targetHeight: _sample,
      );
      image = (await codec.getNextFrame()).image;
      codec.dispose();
    } catch (_) {
      return const ConditionEstimate(
        condition: CoinCondition.good,
        confidence: 0.25,
        notes: ['Could not analyse the image clearly.'],
      );
    }

    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final w = image.width;
    final h = image.height;
    image.dispose();
    if (data == null) {
      return const ConditionEstimate(
        condition: CoinCondition.good,
        confidence: 0.25,
        notes: ['Could not analyse the image clearly.'],
      );
    }

    final rgba = data.buffer.asUint8List();
    final n = w * h;
    final lum = Float32List(n);
    var bright = 0.0;
    var highlights = 0;
    for (var i = 0; i < n; i++) {
      final o = i * 4;
      final l =
          (0.299 * rgba[o] + 0.587 * rgba[o + 1] + 0.114 * rgba[o + 2]) / 255.0;
      lum[i] = l;
      bright += l;
      if (l > 0.85) highlights++;
    }
    final meanLum = bright / n;

    // Fine-detail density: strong local gradients inside the central disc.
    final cx = w / 2, cy = h / 2;
    final r = (w < h ? w : h) * 0.42;
    final r2 = r * r;
    var detailPixels = 0;
    var discPixels = 0;
    for (var y = 1; y < h - 1; y++) {
      for (var x = 1; x < w - 1; x++) {
        final dx = x - cx, dy = y - cy;
        if (dx * dx + dy * dy > r2) continue;
        discPixels++;
        final i = y * w + x;
        final g = (lum[i + 1] - lum[i - 1]).abs() +
            (lum[i + w] - lum[i - w]).abs();
        if (g > 0.06) detailPixels++;
      }
    }
    final detailRatio = discPixels == 0 ? 0.0 : detailPixels / discPixels;
    final highlightRatio = highlights / n;

    // Composite 0..1: detail carries most of the weight; a little luster bonus.
    final score = (detailRatio * 2.4).clamp(0.0, 1.0) * 0.8 +
        (highlightRatio * 6).clamp(0.0, 1.0) * 0.2;

    final condition = switch (score) {
      >= 0.82 => CoinCondition.uncirculated,
      >= 0.68 => CoinCondition.extremelyFine,
      >= 0.54 => CoinCondition.veryFine,
      >= 0.40 => CoinCondition.fine,
      >= 0.28 => CoinCondition.veryGood,
      >= 0.16 => CoinCondition.good,
      _ => CoinCondition.fair,
    };

    final notes = <String>[
      if (detailRatio > 0.25)
        'Fine design detail is largely intact.'
      else if (detailRatio > 0.12)
        'Moderate wear on the raised details.'
      else
        'Heavy, even wear — most fine detail is smoothed.',
      if (highlightRatio > 0.06)
        'Reflective fields suggest original surface / luster.'
      else
        'Surfaces look matte, consistent with circulation.',
      if (meanLum < 0.28) 'Dark toning or grime may be hiding detail.',
    ];

    // Confidence is capped low: this is a photo estimate.
    final confidence =
        (0.45 + detailRatio.clamp(0.0, 0.3)).clamp(0.3, 0.7).toDouble();

    return ConditionEstimate(
      condition: condition,
      confidence: confidence,
      notes: notes,
    );
  }
}
