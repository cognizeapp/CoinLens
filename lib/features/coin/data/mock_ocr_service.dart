import 'dart:typed_data';

import '../domain/ocr_service.dart';

/// Deterministic stand-in for on-device OCR. It does **not** read the image;
/// instead it hashes the bytes and returns one of a handful of realistic
/// legend/token sets, so the same photo always yields the same identification
/// while different photos vary. Swap for a real OCR engine in production.
class MockOcrService implements OcrService {
  const MockOcrService();

  static const List<OcrResult> _fixtures = [
    OcrResult(
      tokens: ['REPVBBLICA', 'ITALIANA', 'L', '500', 'LIRE', 'CARAVELLE'],
      detectedYears: [1960],
    ),
    OcrResult(
      tokens: ['REPUBBLICA', 'ITALIANA', 'L', '100', 'MINERVA'],
      detectedYears: [1974],
    ),
    OcrResult(
      tokens: ['LIBERTY', 'IN', 'GOD', 'WE', 'TRUST', 'ONE', 'CENT',
        'UNITED', 'STATES', 'E', 'PLURIBUS', 'UNUM'],
      detectedYears: [1943],
    ),
    OcrResult(
      tokens: ['LIBERTY', 'E', 'PLURIBUS', 'UNUM', 'IN', 'GOD', 'WE', 'TRUST',
        'ONE', 'DOLLAR', 'UNITED', 'STATES', 'OF', 'AMERICA'],
      detectedYears: [1889],
    ),
    OcrResult(
      tokens: ['ELIZABETH', 'II', 'DEI', 'GRATIA', 'REGINA', 'F', 'D',
        'ONE', 'PENNY', 'BRITANNIA'],
      detectedYears: [1963],
    ),
    OcrResult(
      tokens: ['DEUTSCHES', 'REICH', 'EIN', 'MARK'],
      detectedYears: [1875],
    ),
    OcrResult(
      tokens: ['REPUBLIQUE', 'FRANCAISE', 'LIBERTE', 'EGALITE', 'FRATERNITE',
        '1', 'FRANC'],
      detectedYears: [1978],
    ),
    OcrResult(
      tokens: ['IMP', 'CAESAR', 'AVG', 'COS', 'TR', 'P', 'PONT', 'MAX'],
      detectedYears: [],
    ),
    // A deliberately weak read → low confidence, drives the "possible matches"
    // UI (product spec §27).
    OcrResult(tokens: ['LIBER', '19'], detectedYears: []),
  ];

  @override
  Future<OcrResult> readText(Uint8List imageBytes) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    var hash = 2166136261;
    final step = imageBytes.length < 4096 ? 1 : imageBytes.length ~/ 4096;
    for (var i = 0; i < imageBytes.length; i += step) {
      hash = (hash ^ imageBytes[i]) * 16777619 & 0x7fffffff;
    }
    return _fixtures[hash % _fixtures.length];
  }
}
