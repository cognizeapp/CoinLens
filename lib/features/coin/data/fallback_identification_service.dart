import 'dart:typed_data';

import '../../../core/utils/result.dart';
import '../domain/coin_models.dart';
import '../domain/identification_service.dart';

/// Tries [primary] (e.g. the cloud model); if it returns an error, falls back
/// to [fallback] (the on-device pipeline) so a scan always produces a result.
class FallbackIdentificationService implements IdentificationService {
  FallbackIdentificationService({
    required this.primary,
    required this.fallback,
  });

  final IdentificationService primary;
  final IdentificationService fallback;

  @override
  Future<Result<CoinIdentification>> identify({
    required Uint8List frontImage,
    Uint8List? backImage,
    void Function(IdentificationStage stage)? onStage,
  }) async {
    final result = await primary.identify(
      frontImage: frontImage,
      backImage: backImage,
      onStage: onStage,
    );
    return result.when(
      ok: Result.ok,
      err: (_) => fallback.identify(
        frontImage: frontImage,
        backImage: backImage,
        onStage: onStage,
      ),
    );
  }
}
