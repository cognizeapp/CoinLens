import 'dart:typed_data';

import '../../../core/error/failure.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import '../domain/coin_models.dart';
import '../domain/identification_service.dart';

/// Backend identification. Uploads the images to `POST /identify`; the server
/// runs the heavy CV + OCR + catalog + pricing work and returns the same
/// structured [CoinIdentification] the on-device pipeline produces, so the rest
/// of the app is unchanged.
///
/// INTEGRATION POINT — enable by setting `API_BASE_URL` (see `.env.example`).
/// The expected response shape is documented in `_parse` below.
class HttpIdentificationService implements IdentificationService {
  HttpIdentificationService(this._api);

  final ApiClient _api;

  @override
  Future<Result<CoinIdentification>> identify({
    required Uint8List frontImage,
    Uint8List? backImage,
    void Function(IdentificationStage stage)? onStage,
  }) async {
    onStage?.call(IdentificationStage.detectingText);
    try {
      final json = await _api.postImages(
        '/identify',
        front: frontImage,
        back: backImage,
      );
      onStage?.call(IdentificationStage.calculatingValue);
      return Result.ok(_parse(json));
    } on Failure catch (f) {
      return Result.err(f);
    } catch (e) {
      return Result.err(UnknownFailure(cause: e));
    }
  }

  /// Expected JSON:
  /// {
  ///   "coin_name": str, "country": str, "year": int?, "denomination": str,
  ///   "material": str, "mint": str?, "diameter_mm": num?, "weight_g": num?,
  ///   "condition": str, "rarity": str, "confidence": 0..1,
  ///   "value": { "min": num, "max": num, "typical": num,
  ///              "factors": [{"label":str,"detail":str,"impact":str}] },
  ///   "alternatives": [{ "name": str, "confidence": 0..1 }]
  /// }
  CoinIdentification _parse(Map<String, dynamic> j) {
    final v = (j['value'] as Map).cast<String, dynamic>();
    return CoinIdentification(
      coinName: j['coin_name'] as String,
      country: j['country'] as String,
      year: j['year'] as int?,
      denomination: j['denomination'] as String? ?? 'Unknown',
      material: j['material'] as String? ?? 'Unknown',
      mint: j['mint'] as String?,
      diameterMm: (j['diameter_mm'] as num?)?.toDouble(),
      weightG: (j['weight_g'] as num?)?.toDouble(),
      condition: CoinCondition.fromName(j['condition'] as String?),
      rarity: CoinRarity.fromName(j['rarity'] as String?),
      confidence: (j['confidence'] as num).toDouble(),
      value: ValueEstimate(
        min: (v['min'] as num).toDouble(),
        max: (v['max'] as num).toDouble(),
        typical: (v['typical'] as num).toDouble(),
        factors: ((v['factors'] as List?) ?? const [])
            .cast<Map<String, dynamic>>()
            .map((f) => ValueFactor(
                  label: f['label'] as String,
                  detail: f['detail'] as String,
                  impact: ValueImpact.values.firstWhere(
                    (i) => i.name == f['impact'],
                    orElse: () => ValueImpact.neutral,
                  ),
                ))
            .toList(),
      ),
      alternativeMatches: ((j['alternatives'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map((a) => CoinMatch(
                name: a['name'] as String,
                confidence: (a['confidence'] as num).toDouble(),
              ))
          .toList(),
    );
  }
}
