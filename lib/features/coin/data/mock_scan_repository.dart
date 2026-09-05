import '../../../core/error/failure.dart';
import '../../../core/utils/result.dart';
import '../domain/coin_models.dart';
import 'scan_repository.dart';

/// In-memory sample data so Home / History / Collection render realistically
/// during Phase 1. Replaced by a Firestore-backed implementation in Phase 7.
class MockScanRepository implements ScanRepository {
  MockScanRepository() {
    _scans.addAll(_seed());
  }

  final List<ScanRecord> _scans = [];

  List<ScanRecord> _seed() {
    final now = DateTime.now();
    return [
      ScanRecord(
        id: 's1',
        createdAt: now.subtract(const Duration(hours: 3)),
        savedToCollection: true,
        identification: const CoinIdentification(
          coinName: 'Italian 500 Lire',
          country: 'Italy',
          year: 1958,
          denomination: '500 Lire',
          material: 'Silver (.835)',
          condition: CoinCondition.veryFine,
          rarity: CoinRarity.uncommon,
          confidence: 0.92,
          mint: 'Rome (R)',
          diameterMm: 29.3,
          weightG: 11.0,
          value: ValueEstimate(min: 25, max: 60, typical: 40),
        ),
      ),
      ScanRecord(
        id: 's2',
        createdAt: now.subtract(const Duration(days: 1, hours: 5)),
        savedToCollection: true,
        identification: const CoinIdentification(
          coinName: 'Roman Denarius — Trajan',
          country: 'Roman Empire',
          year: 107,
          denomination: 'Denarius',
          material: 'Silver',
          condition: CoinCondition.fine,
          rarity: CoinRarity.rare,
          confidence: 0.74,
          mint: 'Rome',
          value: ValueEstimate(min: 120, max: 320, typical: 190),
        ),
      ),
      ScanRecord(
        id: 's3',
        createdAt: now.subtract(const Duration(days: 4)),
        identification: const CoinIdentification(
          coinName: 'US Lincoln Wheat Cent',
          country: 'United States',
          year: 1943,
          denomination: '1 Cent',
          material: 'Zinc-coated steel',
          condition: CoinCondition.extremelyFine,
          rarity: CoinRarity.uncommon,
          confidence: 0.88,
          value: ValueEstimate(min: 3, max: 18, typical: 7),
        ),
      ),
      ScanRecord(
        id: 's4',
        createdAt: now.subtract(const Duration(days: 9)),
        identification: const CoinIdentification(
          coinName: 'Unidentified — possible French Franc',
          country: 'Unknown',
          year: null,
          denomination: 'Unknown',
          material: 'Copper-nickel',
          condition: CoinCondition.good,
          rarity: CoinRarity.common,
          confidence: 0.41,
          value: ValueEstimate(min: 1, max: 6, typical: 2),
          alternativeMatches: [
            CoinMatch(name: 'French 1 Franc (1960–2001)', confidence: 0.41),
            CoinMatch(name: 'Italian 100 Lire (1955–1989)', confidence: 0.36),
            CoinMatch(name: 'Spanish 5 Pesetas (1975)', confidence: 0.22),
          ],
        ),
      ),
    ];
  }

  ScanRecord? _find(String id) {
    for (final s in _scans) {
      if (s.id == id) return s;
    }
    return null;
  }

  @override
  Future<Result<List<ScanRecord>>> recentScans({int limit = 20}) async {
    await _tick();
    final sorted = [..._scans]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Result.ok(sorted.take(limit).toList());
  }

  @override
  Future<Result<ScanRecord>> scanById(String id) async {
    await _tick();
    final found = _find(id);
    return found == null
        ? const Result.err(NotFoundFailure('That scan could not be found.'))
        : Result.ok(found);
  }

  @override
  Future<Result<void>> saveScan(ScanRecord record) async {
    await _tick();
    _scans.removeWhere((s) => s.id == record.id);
    _scans.add(record);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> deleteScan(String id) async {
    await _tick();
    _scans.removeWhere((s) => s.id == id);
    return const Result.ok(null);
  }

  @override
  Future<Result<List<ScanRecord>>> collection() async {
    await _tick();
    return Result.ok(_scans.where((s) => s.savedToCollection).toList());
  }

  @override
  Future<Result<void>> addToCollection(String scanId) async {
    await _tick();
    final i = _scans.indexWhere((s) => s.id == scanId);
    if (i >= 0) _scans[i] = _scans[i].copyWith(savedToCollection: true);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> removeFromCollection(String scanId) async {
    await _tick();
    final i = _scans.indexWhere((s) => s.id == scanId);
    if (i >= 0) _scans[i] = _scans[i].copyWith(savedToCollection: false);
    return const Result.ok(null);
  }

  Future<void> _tick() =>
      Future<void>.delayed(const Duration(milliseconds: 260));
}
