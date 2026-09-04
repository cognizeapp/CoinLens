import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:coinsight/features/scan/data/heuristic_image_quality_analyzer.dart';
import 'package:coinsight/features/scan/domain/image_quality.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders a [size]×[size] PNG: a [background] field with an optional filled
/// circle of [coinColor] and [coinRadius] at the centre (plus an optional
/// second circle to simulate two coins).
Future<Uint8List> _png({
  int size = 900,
  Color background = const Color(0xFF9AA0A6),
  Color? coinColor,
  double coinRadius = 0,
  Offset? secondCoinCenter,
  double blurSigma = 0,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final rect =
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());
  canvas.drawRect(rect, Paint()..color = background);
  if (coinColor != null && coinRadius > 0) {
    final paint = Paint()..color = coinColor;
    if (blurSigma > 0) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    }
    canvas.drawCircle(Offset(size / 2, size / 2), coinRadius, paint);
    if (secondCoinCenter != null) {
      canvas.drawCircle(secondCoinCenter, coinRadius,
          Paint()..color = coinColor);
    }
  }
  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const analyzer = HeuristicImageQualityAnalyzer();

  test('a well-framed single coin on a plain background passes', () async {
    final bytes = await _png(
      background: const Color(0xFF8A8F94),
      coinColor: const Color(0xFF3B3B3B),
      coinRadius: 320,
    );
    final report = await analyzer.analyze(bytes);
    expect(report.passed, isTrue, reason: report.issues.toString());
  });

  test('a heavily blurred coin edge reports blurry', () async {
    final bytes = await _png(
      background: const Color(0xFF8A8F94),
      coinColor: const Color(0xFF3B3B3B),
      coinRadius: 300,
      blurSigma: 40,
    );
    final report = await analyzer.analyze(bytes);
    expect(report.issues, contains(ImageQualityIssue.blurry));
  });

  test('an empty plain frame reports no coin', () async {
    final bytes = await _png(coinRadius: 0);
    final report = await analyzer.analyze(bytes);
    expect(report.issues, contains(ImageQualityIssue.coinNotFound));
    expect(report.hasBlockingIssue, isTrue);
  });

  test('a near-black frame reports too dark', () async {
    final bytes = await _png(background: const Color(0xFF060606));
    final report = await analyzer.analyze(bytes);
    expect(report.issues, contains(ImageQualityIssue.tooDark));
  });

  test('a tiny subject reports coin too small', () async {
    final bytes = await _png(
      coinColor: const Color(0xFF2E2E2E),
      coinRadius: 70,
    );
    final report = await analyzer.analyze(bytes);
    expect(
      report.issues.any((i) =>
          i == ImageQualityIssue.coinTooSmall ||
          i == ImageQualityIssue.coinNotFound),
      isTrue,
    );
  });

  test('a low-resolution image is rejected', () async {
    final bytes = await _png(
      size: 200,
      coinColor: const Color(0xFF303030),
      coinRadius: 70,
    );
    final report = await analyzer.analyze(bytes);
    expect(report.issues, contains(ImageQualityIssue.lowResolution));
  });

  test('two separate subjects report multiple coins', () async {
    final bytes = await _png(
      size: 900,
      coinColor: const Color(0xFF303030),
      coinRadius: 150,
      secondCoinCenter: const Offset(200, 200),
    );
    final report = await analyzer.analyze(bytes);
    expect(report.issues, contains(ImageQualityIssue.multipleCoins));
  });
}
