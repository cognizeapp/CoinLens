import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Coarse online/offline signal. Used for a non-blocking banner and to give
/// network failures a clearer message — never to hard-gate the UI, since
/// cached scans and the local pipeline work offline.
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged.map(_isOnline);
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityStreamProvider).valueOrNull ?? true;
});

bool _isOnline(List<ConnectivityResult> results) =>
    results.isNotEmpty && !results.every((r) => r == ConnectivityResult.none);
