import 'dart:typed_data';

import '../../../core/utils/result.dart';
import 'coin_models.dart';

/// The standard (non-AI) identification pipeline described in product spec §7–9:
/// computer vision + OCR + structured database matching + confidence scoring.
/// Runs for every user, free or Premium. [PipelineIdentificationService] is the
/// on-device implementation; [HttpIdentificationService] is the backend one.
abstract interface class IdentificationService {
  /// [frontImage] / [backImage] are the raw encoded image bytes (works the
  /// same on mobile and web). [onStage] reports pipeline progress for the scan
  /// animation.
  Future<Result<CoinIdentification>> identify({
    required Uint8List frontImage,
    Uint8List? backImage,
    void Function(IdentificationStage stage)? onStage,
  });
}

enum IdentificationStage {
  detectingText('Detecting text'),
  identifyingCountry('Identifying country'),
  detectingYear('Detecting year'),
  searchingDatabase('Searching coin database'),
  calculatingValue('Calculating value');

  const IdentificationStage(this.label);
  final String label;
}
