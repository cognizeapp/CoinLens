import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../../core/error/failure.dart';
import '../../../core/utils/result.dart';
import '../domain/coin_models.dart';
import '../domain/identification_service.dart';

/// Cloud coin identification via Google's Gemini API (a multimodal model with
/// broad numismatic knowledge). Sends the coin photo(s) and asks for a
/// structured identification + realistic market-value estimate.
///
/// The API key is supplied at build time (`--dart-define=GEMINI_API_KEY=...`).
/// When the key is missing or a call fails/times out, [identify] returns an
/// error and the caller falls back to the on-device pipeline — the app is never
/// blocked on the network.
///
/// For a public release the key should move behind a proxy (e.g. a Firebase
/// Cloud Function); only the `_endpoint` and auth here would change.
class GeminiIdentificationService implements IdentificationService {
  GeminiIdentificationService({
    required String apiKey,
    String model = 'gemini-2.5-flash',
    http.Client? client,
    Duration timeout = const Duration(seconds: 25),
  })  : _apiKey = apiKey,
        _model = model,
        _client = client ?? http.Client(),
        _timeout = timeout;

  final String _apiKey;
  final String _model;
  final http.Client _client;
  final Duration _timeout;

  bool get isConfigured => _apiKey.isNotEmpty;

  Uri get _endpoint => Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/'
        '$_model:generateContent?key=$_apiKey',
      );

  static const _prompt = '''
You are an expert numismatist. Identify the coin in the photo(s) — the first
image is the front (obverse), a second image if present is the back (reverse).

Return ONLY a single minified JSON object, no markdown, with exactly these keys:
{
 "coin_name": string,               // e.g. "Italy 500 Lire (Caravelle)"
 "country": string,                 // "Unknown" if you cannot tell
 "year": integer or null,           // the year struck, if visible
 "denomination": string,
 "material": string,                // e.g. "Silver (.835)", "Copper-nickel"
 "mint": string or null,
 "diameter_mm": number or null,
 "weight_g": number or null,
 "condition": one of ["Poor","Fair","Good","Very Good","Fine","Very Fine","Extremely Fine","Uncirculated"],
 "rarity": one of ["Common","Uncommon","Rare","Very Rare","Extremely Rare"],
 "confidence": number 0..1,         // your confidence in the identification
 "value_eur": { "min": number, "typical": number, "max": number },
 "factors": [ { "label": string, "detail": string, "impact": "positive"|"neutral"|"negative" } ],
 "alternatives": [ { "name": string, "confidence": number } ],
 "notes": string
}

Value rules — be realistic and conservative:
- A common circulating coin in average condition is worth roughly its face
  value. Do NOT inflate it. Only key dates, mint errors, low mintages,
  precious-metal content or genuinely scarce types are worth a real premium.
- Base "typical" on actual recent collector-market prices for that exact
  type / year / grade, in euros.
- If you are not reasonably sure what the coin is, set "confidence" below 0.4,
  "country" to "Unknown", and keep the value near face value.
Give 2-4 short "factors" explaining the estimate. Provide up to 3
"alternatives" only when unsure.
''';

  @override
  Future<Result<CoinIdentification>> identify({
    required Uint8List frontImage,
    Uint8List? backImage,
    void Function(IdentificationStage stage)? onStage,
  }) async {
    if (!isConfigured) {
      return const Result.err(UnknownFailure());
    }
    onStage?.call(IdentificationStage.detectingText);

    final parts = <Map<String, dynamic>>[
      {'text': _prompt},
      {
        'inline_data': {
          'mime_type': 'image/jpeg',
          'data': base64Encode(frontImage),
        }
      },
      if (backImage != null)
        {
          'inline_data': {
            'mime_type': 'image/jpeg',
            'data': base64Encode(backImage),
          }
        },
    ];

    final body = jsonEncode({
      'contents': [
        {'parts': parts}
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'temperature': 0.2,
        'maxOutputTokens': 1024,
      },
    });

    try {
      onStage?.call(IdentificationStage.searchingDatabase);
      final res = await _client
          .post(_endpoint,
              headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(_timeout);

      if (res.statusCode != 200) {
        return const Result.err(UnknownFailure());
      }

      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      final text = (((decoded['candidates'] as List?)?.firstOrNull
              as Map<String, dynamic>?)?['content']
          as Map<String, dynamic>?)?['parts'] as List?;
      final raw =
          (text?.firstOrNull as Map<String, dynamic>?)?['text'] as String?;
      if (raw == null || raw.isEmpty) {
        return const Result.err(UnknownFailure());
      }

      onStage?.call(IdentificationStage.calculatingValue);
      return Result.ok(_parse(jsonDecode(raw) as Map<String, dynamic>));
    } on TimeoutException {
      return const Result.err(UnknownFailure());
    } catch (e) {
      return Result.err(UnknownFailure(cause: e));
    }
  }

  CoinIdentification _parse(Map<String, dynamic> j) {
    double d(Object? v, [double fallback = 0]) =>
        v is num ? v.toDouble() : (double.tryParse('$v') ?? fallback);

    final value = (j['value_eur'] as Map<String, dynamic>?) ?? const {};
    final typical = d(value['typical'], 1);
    final vmin = d(value['min'], typical * 0.6);
    final vmax = d(value['max'], typical * 1.6);

    final factors = <ValueFactor>[
      for (final f in (j['factors'] as List? ?? const []))
        if (f is Map<String, dynamic>)
          ValueFactor(
            label: '${f['label'] ?? ''}',
            detail: '${f['detail'] ?? ''}',
            impact: switch ('${f['impact']}') {
              'positive' => ValueImpact.positive,
              'negative' => ValueImpact.negative,
              _ => ValueImpact.neutral,
            },
          ),
    ];

    final alternatives = <CoinMatch>[
      for (final a in (j['alternatives'] as List? ?? const []))
        if (a is Map<String, dynamic>)
          CoinMatch(name: '${a['name'] ?? ''}', confidence: d(a['confidence'])),
    ];

    return CoinIdentification(
      coinName: '${j['coin_name'] ?? 'Unidentified coin'}',
      country: '${j['country'] ?? 'Unknown'}',
      year: j['year'] is int ? j['year'] as int : int.tryParse('${j['year']}'),
      denomination: '${j['denomination'] ?? 'Unknown'}',
      material: '${j['material'] ?? 'Unknown'}',
      condition: CoinCondition.fromName('${j['condition']}'),
      rarity: CoinRarity.fromName('${j['rarity']}'),
      confidence: d(j['confidence'], 0.5).clamp(0, 1),
      value: ValueEstimate(
        min: vmin,
        max: vmax,
        typical: typical,
        factors: factors,
      ),
      mint: (j['mint'] as String?)?.isNotEmpty == true
          ? j['mint'] as String
          : null,
      diameterMm: (j['diameter_mm'] as num?)?.toDouble(),
      weightG: (j['weight_g'] as num?)?.toDouble(),
      alternativeMatches: alternatives,
    );
  }
}
