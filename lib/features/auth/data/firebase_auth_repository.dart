import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/error/failure.dart';
import '../../../core/utils/result.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

/// Real authentication backed by Firebase Auth, with Google and Apple as
/// social providers. This is the implementation used whenever a Firebase
/// project is configured (see `bootstrap.dart`); [MockAuthRepository] remains
/// available for offline development.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: const ['email']);

  final fb.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AppUser _toAppUser(fb.User user) => AppUser(
        id: user.uid,
        isAnonymous: user.isAnonymous,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        createdAt: user.metadata.creationTime,
      );

  @override
  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : _toAppUser(user);
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth
        .authStateChanges()
        .map((u) => u == null ? null : _toAppUser(u));
  }

  Future<Result<AppUser>> _guard(
      Future<fb.UserCredential> Function() op) async {
    try {
      final cred = await op();
      final user = cred.user;
      if (user == null) {
        return const Result.err(AuthFailure('Sign-in did not return a user.'));
      }
      return Result.ok(_toAppUser(user));
    } on fb.FirebaseAuthException catch (e) {
      return Result.err(AuthFailure(_messageFor(e), cause: e));
    } catch (e) {
      return Result.err(
          AuthFailure('Sign-in failed. Please try again.', cause: e));
    }
  }

  String _messageFor(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Choose a stronger password (at least 6 characters).';
      case 'network-request-failed':
        return 'No internet connection. Check your network and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'user-cancelled':
      case 'canceled':
        return 'Sign-in was cancelled.';
      default:
        return e.message ?? 'Sign-in failed. Please try again.';
    }
  }

  @override
  Future<Result<AppUser>> signInAnonymously() {
    return _guard(() => _auth.signInAnonymously());
  }

  @override
  Future<Result<AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(() => _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        ));
  }

  @override
  Future<Result<AppUser>> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // If the current session is an anonymous "explore" account, upgrade it in
    // place so scans/collection made before signing up are preserved
    // (product spec §24) instead of being orphaned under a new uid.
    final anon = _auth.currentUser;
    final result = anon != null && anon.isAnonymous
        ? await _guard(() => anon.linkWithCredential(
              fb.EmailAuthProvider.credential(
                email: email.trim(),
                password: password,
              ),
            ))
        : await _guard(() => _auth.createUserWithEmailAndPassword(
              email: email.trim(),
              password: password,
            ));

    if (result case Ok(value: final user)) {
      final name = displayName?.trim();
      if (name != null && name.isNotEmpty) {
        await _auth.currentUser?.updateDisplayName(name);
      }
      return Result.ok(user.copyWith(displayName: name));
    }
    return result;
  }

  @override
  Future<Result<AppUser>> signInWithProvider(SocialProvider provider) {
    return switch (provider) {
      SocialProvider.google => _signInWithGoogle(),
      SocialProvider.apple => _signInWithApple(),
    };
  }

  Future<Result<AppUser>> _signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return const Result.err(AuthFailure('Sign-in was cancelled.'));
      }
      final auth = await account.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      return _guard(() => _linkOrSignIn(credential));
    } on fb.FirebaseAuthException catch (e) {
      return Result.err(AuthFailure(_messageFor(e), cause: e));
    } catch (e) {
      return Result.err(AuthFailure('Google sign-in failed.', cause: e));
    }
  }

  Future<Result<AppUser>> _signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauth = fb.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final result = await _guard(() => _linkOrSignIn(oauth));
      // Apple only returns the name on first authorization; Firebase doesn't
      // capture it automatically, so set it explicitly when present.
      if (result case Ok(value: final user)) {
        final given = appleCredential.givenName;
        final family = appleCredential.familyName;
        if ((given != null && given.isNotEmpty) ||
            (family != null && family.isNotEmpty)) {
          final name = [given, family].whereType<String>().join(' ').trim();
          await _auth.currentUser?.updateDisplayName(name);
          return Result.ok(user.copyWith(displayName: name));
        }
      }
      return result;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return const Result.err(AuthFailure('Sign-in was cancelled.'));
      }
      return Result.err(AuthFailure('Apple sign-in failed.', cause: e));
    } on fb.FirebaseAuthException catch (e) {
      return Result.err(AuthFailure(_messageFor(e), cause: e));
    } catch (e) {
      return Result.err(AuthFailure('Apple sign-in failed.', cause: e));
    }
  }

  /// Links the credential to an in-progress anonymous session so guest data
  /// carries over, falling back to a normal sign-in if there's no anonymous
  /// session or the credential is already tied to another account.
  Future<fb.UserCredential> _linkOrSignIn(fb.AuthCredential credential) async {
    final current = _auth.currentUser;
    if (current != null && current.isAnonymous) {
      try {
        return await current.linkWithCredential(credential);
      } on fb.FirebaseAuthException catch (e) {
        if (e.code != 'credential-already-in-use' &&
            e.code != 'email-already-in-use') {
          rethrow;
        }
        // Fall through to a plain sign-in with the existing account.
      }
    }
    return _auth.signInWithCredential(credential);
  }

  @override
  Future<Result<void>> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const Result.ok(null);
    } on fb.FirebaseAuthException catch (e) {
      return Result.err(AuthFailure(_messageFor(e), cause: e));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        if (!Platform.isIOS && !Platform.isMacOS) _googleSignIn.signOut(),
      ]);
      return const Result.ok(null);
    } catch (e) {
      return Result.err(AuthFailure('Sign-out failed.', cause: e));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      return const Result.ok(null);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return const Result.err(AuthFailure(
          'For your security, please sign in again before deleting your account.',
        ));
      }
      return Result.err(AuthFailure(_messageFor(e), cause: e));
    }
  }
}
