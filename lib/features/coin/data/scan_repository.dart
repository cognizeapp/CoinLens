import '../../../core/utils/result.dart';
import '../domain/coin_models.dart';

/// Persists scans and the user's saved collection. Backed by a local mock in
/// Phase 1; Firestore + Firebase Storage from Phase 7.
abstract interface class ScanRepository {
  Future<Result<List<ScanRecord>>> recentScans({int limit = 20});
  Future<Result<ScanRecord>> scanById(String id);
  Future<Result<void>> saveScan(ScanRecord record);
  Future<Result<void>> deleteScan(String id);

  Future<Result<List<ScanRecord>>> collection();
  Future<Result<void>> addToCollection(String scanId);
  Future<Result<void>> removeFromCollection(String scanId);
}
