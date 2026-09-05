import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/catalog_value_estimator.dart';
import '../data/coin_catalog.dart';
import '../data/heuristic_condition_estimator.dart';
import '../data/mock_ocr_service.dart';
import '../data/mock_scan_repository.dart';
import '../data/pipeline_identification_service.dart';
import '../data/scan_repository.dart';
import '../domain/condition_estimator.dart';
import '../domain/coin_models.dart';
import '../domain/identification_service.dart';
import '../domain/ocr_service.dart';
import '../domain/value_estimation_service.dart';

/// Overridden in `bootstrap()` (mock now, Firestore-backed in Phase 7).
final scanRepositoryProvider = Provider<ScanRepository>(
  (ref) => MockScanRepository(),
);

// --- identification pipeline building blocks ------------------------------

final coinCatalogProvider = Provider<CoinCatalog>((ref) => AssetCoinCatalog());

/// Mock OCR by default; overridden with an on-device engine when available.
final ocrServiceProvider =
    Provider<OcrService>((ref) => const MockOcrService());

final conditionEstimatorProvider = Provider<ConditionEstimator>(
  (ref) => const HeuristicConditionEstimator(),
);

final valueEstimationServiceProvider = Provider<ValueEstimationService>(
  (ref) => const CatalogValueEstimator(),
);

/// The default identification service: the on-device pipeline. `bootstrap()`
/// overrides this with [HttpIdentificationService] when a backend is configured.
final identificationServiceProvider = Provider<IdentificationService>((ref) {
  return PipelineIdentificationService(
    ocr: ref.watch(ocrServiceProvider),
    catalog: ref.watch(coinCatalogProvider),
    conditionEstimator: ref.watch(conditionEstimatorProvider),
    valueEstimator: ref.watch(valueEstimationServiceProvider),
  );
});

// --- scan data -----------------------------------------------------------

final recentScansProvider = FutureProvider<List<ScanRecord>>((ref) async {
  final result = await ref.watch(scanRepositoryProvider).recentScans();
  return result.when(ok: (v) => v, err: (f) => throw f);
});

final collectionProvider = FutureProvider<List<ScanRecord>>((ref) async {
  final result = await ref.watch(scanRepositoryProvider).collection();
  return result.when(ok: (v) => v, err: (f) => throw f);
});

final scanByIdProvider =
    FutureProvider.family<ScanRecord, String>((ref, id) async {
  final result = await ref.watch(scanRepositoryProvider).scanById(id);
  return result.when(ok: (v) => v, err: (f) => throw f);
});
