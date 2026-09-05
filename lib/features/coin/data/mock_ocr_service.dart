import 'dart:typed_data';

import '../domain/ocr_service.dart';

/// Deterministic stand-in for on-device OCR. It does **not** read the image;
/// it hashes the bytes and returns a legend/token set, so the same photo
/// always yields the same identification while different photos vary.
///
/// Because it cannot actually see the coin, most hashes deliberately resolve
/// to a *weak* read: the pipeline then reports low confidence and the result
/// screen asks the user to confirm the coin, so the value shown is anchored to
/// a coin the user actually verified rather than a confident guess. Swap for a
/// real OCR / vision engine in production (see `HttpIdentificationService`).
class MockOcrService implements OcrService {
  const MockOcrService();

  /// Ambiguous reads — return "unidentified, please confirm" from the pipeline.
  static const List<OcrResult> _weak = [
    OcrResult(tokens: ['LIBER', '19'], detectedYears: []),
    OcrResult(tokens: ['EURO', 'CENT'], detectedYears: []),
    OcrResult(tokens: ['20'], detectedYears: []),
    OcrResult(tokens: [], detectedYears: []),
  ];

  /// Clear reads — kept to a handful of unmistakable, low-value circulation
  /// types so a confident guess is never wildly off. Anything scarcer or
  /// pricier is left to the user's confirmation.
  static const List<OcrResult> _strong = [
    OcrResult(
      tokens: ['REPVBBLICA', 'ITALIANA', 'L', '500', 'LIRE', 'CARAVELLE'],
      detectedYears: [1960],
    ),
    OcrResult(
      tokens: ['REPUBBLICA', 'ITALIANA', 'L', '100', 'MINERVA'],
      detectedYears: [1974],
    ),
    OcrResult(
      tokens: [
        'LIBERTY',
        'IN',
        'GOD',
        'WE',
        'TRUST',
        'ONE',
        'CENT',
        'UNITED',
        'STATES',
        'E',
        'PLURIBUS',
        'UNUM',
      ],
      detectedYears: [1951],
    ),
    OcrResult(
      tokens: [
        'ELIZABETH',
        'II',
        'DEI',
        'GRATIA',
        'REGINA',
        'F',
        'D',
        'ONE',
        'PENNY',
        'BRITANNIA',
      ],
      detectedYears: [1963],
    ),
    OcrResult(
      tokens: [
        'REPUBLIQUE',
        'FRANCAISE',
        'LIBERTE',
        'EGALITE',
        'FRATERNITE',
        '1',
        'FRANC',
      ],
      detectedYears: [1978],
    ),
  ];

  @override
  Future<OcrResult> readText(Uint8List imageBytes) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    var hash = 2166136261;
    final step = imageBytes.length < 4096 ? 1 : imageBytes.length ~/ 4096;
    for (var i = 0; i < imageBytes.length; i += step) {
      hash = (hash ^ imageBytes[i]) * 16777619 & 0x7fffffff;
    }
    // About half of reads are weak → the result screen asks the user to
    // confirm the coin instead of asserting a possibly-wrong identification.
    if (hash % 100 < 50) {
      return _weak[hash % _weak.length];
    }
    return _strong[hash % _strong.length];
  }
}
