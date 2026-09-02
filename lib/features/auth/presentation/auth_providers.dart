import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/failure.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

/// Overridden in `main()` with the mock or Firebase repository.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => throw UnimplementedError('authRepositoryProvider not overridden'),
);

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

/// Drives the sign-in / sign-up forms.
class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repo) : super(const AsyncData(null));

  final AuthRepository _repo;

  Future<bool> _run(Future<dynamic> Function() action) async {
    state = const AsyncLoading();
    try {
      final result = await action();
      // result is Result<...>
      final failure = result.failureOrNull as Failure?;
      if (failure != null) {
        state = AsyncError(failure, StackTrace.current);
        return false;
      }
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(const UnknownFailure(), st);
      return false;
    }
  }

  Future<bool> continueAsGuest() => _run(_repo.signInAnonymously);

  Future<bool> signIn(String email, String password) =>
      _run(() => _repo.signInWithEmail(email: email, password: password));

  Future<bool> register(String email, String password, String? name) => _run(
      () => _repo.registerWithEmail(
          email: email, password: password, displayName: name));

  Future<bool> social(SocialProvider provider) =>
      _run(() => _repo.signInWithProvider(provider));

  Future<bool> resetPassword(String email) =>
      _run(() => _repo.sendPasswordReset(email));
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
