import 'dart:typed_data';

import 'image_quality.dart';

/// What a capture screen hands back: the accepted image (path for display +
/// bytes for the pipeline) plus the quality report shown to the user.
class CaptureResult {
  const CaptureResult(this.path, this.bytes, this.report);
  final String path;
  final Uint8List bytes;
  final ImageQualityReport? report;
}

enum CoinFace {
  front('front', 'Scan the front of your coin'),
  back('back', 'Scan the back of your coin');

  const CoinFace(this.id, this.prompt);
  final String id;
  final String prompt;

  bool get isFront => this == CoinFace.front;
}
