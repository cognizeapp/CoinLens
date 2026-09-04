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
  front('front'),
  back('back');

  const CoinFace(this.id);
  final String id;

  bool get isFront => this == CoinFace.front;
}
