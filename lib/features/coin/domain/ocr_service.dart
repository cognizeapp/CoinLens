import 'dart:typed_data';

/// Text read off a coin image.
class OcrResult {
  const OcrResult({required this.tokens, this.detectedYears = const []});

  /// Upper-cased word tokens from the legend / inscriptions.
  final List<String> tokens;

  /// Any 3–4 digit sequences that plausibly denote a year.
  final List<int> detectedYears;

  bool get isEmpty => tokens.isEmpty && detectedYears.isEmpty;
}

/// Optical character recognition over a coin photo. The production
/// implementation wraps an on-device OCR engine (e.g. ML Kit / Vision);
/// [MockOcrService] stands in until that native dependency is added.
abstract interface class OcrService {
  Future<OcrResult> readText(Uint8List imageBytes);
}
