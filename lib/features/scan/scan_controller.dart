import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/error/failure.dart';
import '../coin/domain/coin_models.dart';
import '../coin/domain/identification_service.dart';
import '../coin/presentation/coin_providers.dart';
import '../../services/analytics/analytics_service.dart';
import 'data/heuristic_image_quality_analyzer.dart';
import 'domain/image_quality.dart';

final imageQualityAnalyzerProvider = Provider<ImageQualityAnalyzer>(
  (ref) => const HeuristicImageQualityAnalyzer(),
);

/// UI state for a scan in progress.
class ScanState {
  const ScanState({
    this.frontImagePath,
    this.backImagePath,
    this.frontImageBytes,
    this.backImageBytes,
    this.frontReport,
    this.backReport,
    this.stage,
    this.isAnalyzing = false,
    this.resultId,
    this.failure,
  });

  final String? frontImagePath;
  final String? backImagePath;
  final Uint8List? frontImageBytes;
  final Uint8List? backImageBytes;
  final ImageQualityReport? frontReport;
  final ImageQualityReport? backReport;
  final IdentificationStage? stage;
  final bool isAnalyzing;
  final String? resultId;
  final Failure? failure;

  bool get hasFront => frontImagePath != null && frontImageBytes != null;

  ScanState copyWith({
    String? frontImagePath,
    String? backImagePath,
    Uint8List? frontImageBytes,
    Uint8List? backImageBytes,
    ImageQualityReport? frontReport,
    ImageQualityReport? backReport,
    IdentificationStage? stage,
    bool? isAnalyzing,
    String? resultId,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ScanState(
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      frontImageBytes: frontImageBytes ?? this.frontImageBytes,
      backImageBytes: backImageBytes ?? this.backImageBytes,
      frontReport: frontReport ?? this.frontReport,
      backReport: backReport ?? this.backReport,
      stage: stage ?? this.stage,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      resultId: resultId ?? this.resultId,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

class ScanController extends StateNotifier<ScanState> {
  ScanController(this._ref) : super(const ScanState());

  final Ref _ref;
  final _uuid = const Uuid();

  void setFront(String path, Uint8List bytes, {ImageQualityReport? report}) =>
      state = state.copyWith(
        frontImagePath: path,
        frontImageBytes: bytes,
        frontReport: report,
        clearFailure: true,
      );

  void setBack(String path, Uint8List bytes, {ImageQualityReport? report}) =>
      state = state.copyWith(
        backImagePath: path,
        backImageBytes: bytes,
        backReport: report,
      );

  void reset() => state = const ScanState();

  /// Runs the on-device quality gate. Returns `null` if the bytes cannot be
  /// decoded.
  Future<ImageQualityReport?> inspect(Uint8List bytes) async {
    try {
      return await _ref.read(imageQualityAnalyzerProvider).analyze(bytes);
    } catch (_) {
      return null;
    }
  }

  Future<void> analyze() async {
    final front = state.frontImageBytes;
    if (front == null || state.isAnalyzing) return;

    state = state.copyWith(isAnalyzing: true, clearFailure: true);
    await _ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvent.scanStarted);

    final result = await _ref.read(identificationServiceProvider).identify(
          frontImage: front,
          backImage: state.backImageBytes,
          onStage: (s) {
            if (mounted) state = state.copyWith(stage: s);
          },
        );

    await result.when(
      ok: (identification) async {
        final record = ScanRecord(
          id: _uuid.v4(),
          identification: identification,
          createdAt: DateTime.now(),
          frontImagePath: state.frontImagePath,
          backImagePath: state.backImagePath,
        );
        await _ref.read(scanRepositoryProvider).saveScan(record);
        _ref.invalidate(recentScansProvider);
        final analytics = _ref.read(analyticsServiceProvider);
        await analytics.logEvent(AnalyticsEvent.scanCompleted);
        await analytics.logEvent(AnalyticsEvent.coinIdentified, params: {
          'confidence': identification.confidence,
          'coin': identification.coinName,
        });
        if (mounted) {
          state = state.copyWith(isAnalyzing: false, resultId: record.id);
        }
      },
      err: (f) async {
        if (mounted) {
          state = state.copyWith(isAnalyzing: false, failure: f);
        }
      },
    );
  }
}

final scanControllerProvider =
    StateNotifierProvider<ScanController, ScanState>((ref) {
  return ScanController(ref);
});
