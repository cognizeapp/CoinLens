import 'dart:typed_data';

import 'coin_models.dart';

class ConditionEstimate {
  const ConditionEstimate({
    required this.condition,
    required this.confidence,
    required this.notes,
  });

  final CoinCondition condition;

  /// 0–1 — how sure the estimate is. Photo-based grading is inherently rough.
  final double confidence;

  /// Short observations that fed the estimate ("high points show wear",
  /// "fields are reflective").
  final List<String> notes;
}

/// Rough, photo-only wear/grade estimate. Always surfaced as approximate and
/// never as a professional grade (product spec §3.3, §26).
abstract interface class ConditionEstimator {
  Future<ConditionEstimate> estimate(Uint8List imageBytes);
}
