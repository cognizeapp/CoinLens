import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:coinlens/features/coin/data/catalog_value_estimator.dart';
import 'package:coinlens/features/coin/data/coin_catalog.dart';
import 'package:coinlens/features/coin/data/pipeline_identification_service.dart';
import 'package:coinlens/features/coin/domain/catalog_entry.dart';
import 'package:coinlens/features/coin/domain/coin_models.dart';
import 'package:coinlens/features/coin/domain/condition_estimator.dart';
import 'package:coinlens/features/coin/domain/ocr_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOcr implements OcrService {
  _FakeOcr(this.result);
  final OcrResult result;
  @override
  Future<OcrResult> readText(Uint8List imageBytes) async => result;
}

class _FixedCondition implements ConditionEstimator {
  @override
  Future<ConditionEstimate> estimate(Uint8List imageBytes) async =>
      const ConditionEstimate(
        condition: CoinCondition.veryFine,
        confidence: 0.5,
        notes: [],
      );
}

class _MemCatalog implements CoinCatalog {
  _MemCatalog(this._entries);
  final List<CatalogEntry> _entries;
  @override
  Future<List<CatalogEntry>> all() async => _entries;
  @override
  Future<CatalogEntry?> byId(String id) async =>
      _entries.where((e) => e.id == id).firstOrNull;
}

const _lira = CatalogEntry(
  id: 'it-500',
  name: 'Italy 500 Lire',
  country: 'Italy',
  denomination: '500 Lire',
  yearFrom: 1958,
  yearTo: 1967,
  material: 'Silver (.835)',
  keywords: ['REPVBBLICA', 'ITALIANA', 'LIRE', 'CARAVELLE'],
  baseValueEur: 12,
  baseRarity: CoinRarity.uncommon,
);

const _cent = CatalogEntry(
  id: 'us-cent',
  name: 'United States Lincoln Cent',
  country: 'United States',
  denomination: '1 Cent',
  yearFrom: 1909,
  yearTo: 1958,
  material: 'Bronze',
  keywords: ['LIBERTY', 'ONE CENT', 'UNITED STATES'],
  baseValueEur: 0.6,
  baseRarity: CoinRarity.common,
);

Future<Uint8List> _blankPng() async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(const Rect.fromLTWH(0, 0, 40, 40),
      Paint()..color = const Color(0xFF888888));
  final img = await recorder.endRecording().toImage(40, 40);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  PipelineIdentificationService build(OcrResult ocr) =>
      PipelineIdentificationService(
        ocr: _FakeOcr(ocr),
        catalog: _MemCatalog(const [_lira, _cent]),
        conditionEstimator: _FixedCondition(),
        valueEstimator: const CatalogValueEstimator(),
      );

  test('strong legend + year in range gives a confident match', () async {
    final bytes = await _blankPng();
    final res = await build(const OcrResult(
      tokens: ['REPVBBLICA', 'ITALIANA', 'LIRE', 'CARAVELLE', '500'],
      detectedYears: [1960],
    )).identify(frontImage: bytes);

    final id = res.valueOrNull!;
    expect(id.country, 'Italy');
    expect(id.year, 1960);
    expect(id.denomination, '500 Lire');
    expect(id.isConfident, isTrue);
    expect(id.value.typical, greaterThan(0));
  });

  test('a weak read is low-confidence and returns possible matches', () async {
    final bytes = await _blankPng();
    final res = await build(const OcrResult(tokens: ['LIBERTY']))
        .identify(frontImage: bytes);

    final id = res.valueOrNull!;
    expect(id.isConfident, isFalse);
    expect(id.alternativeMatches, isNotEmpty);
  });

  test('no recognisable text → unidentified with guesses', () async {
    final bytes = await _blankPng();
    final res = await build(const OcrResult(tokens: ['ZZZZ', 'QXQX']))
        .identify(frontImage: bytes);

    final id = res.valueOrNull!;
    expect(id.country, 'Unknown');
    expect(id.confidence, lessThan(0.5));
    expect(id.alternativeMatches, isNotEmpty);
  });
}
