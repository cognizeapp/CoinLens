import '../../../core/utils/result.dart';
import 'app_user.dart';

enum SocialProvider { google, apple }

abstract interface class AuthRepository {
  /// Emits the current user, or `null` when fully signed out.
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<Result<AppUser>> signInAnonymously();

  Future<Result<AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Result<AppUser>> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Result<AppUser>> signInWithProvider(SocialProvider provider);

  Future<Result<void>> sendPasswordReset(String email);

  Future<Result<void>> signOut();

  /// Permanently removes the account and triggers server-side data deletion
  /// (product spec §5 "Delete account", §23).
  Future<Result<void>> deleteAccount();
}
