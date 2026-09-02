import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../core/error/failure.dart';
import '../../../core/utils/result.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

/// Local, no-network auth used until Firebase is configured. Persists a single
/// "account" to SharedPreferences so sessions survive restarts. This is a
/// development stand-in — it does not verify passwords securely and must never
/// ship to production.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._prefs) {
    _restore();
  }

  static const _kUserId = 'mock_auth_user_id';
  static const _kEmail = 'mock_auth_email';
  static const _kName = 'mock_auth_name';
  static const _kAnon = 'mock_auth_anonymous';

  final SharedPreferences _prefs;
  final _uuid = const Uuid();
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _current;

  void _restore() {
    final id = _prefs.getString(_kUserId);
    if (id != null) {
      _current = AppUser(
        id: id,
        isAnonymous: _prefs.getBool(_kAnon) ?? false,
        email: _prefs.getString(_kEmail),
        displayName: _prefs.getString(_kName),
      );
    }
  }

  Future<void> _persist(AppUser? user) async {
    _current = user;
    if (user == null) {
      await _prefs.remove(_kUserId);
      await _prefs.remove(_kEmail);
      await _prefs.remove(_kName);
      await _prefs.remove(_kAnon);
    } else {
      await _prefs.setString(_kUserId, user.id);
      await _prefs.setBool(_kAnon, user.isAnonymous);
      if (user.email != null) await _prefs.setString(_kEmail, user.email!);
      if (user.displayName != null) {
        await _prefs.setString(_kName, user.displayName!);
      }
    }
    _controller.add(user);
  }

  @override
  AppUser? get currentUser => _current;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _current; // deliver the restored session to late subscribers
    yield* _controller.stream;
  }

  Future<Result<AppUser>> _delayed(AppUser user) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await _persist(user);
    return Result.ok(user);
  }

  @override
  Future<Result<AppUser>> signInAnonymously() {
    return _delayed(AppUser(
      id: _uuid.v4(),
      isAnonymous: true,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<Result<AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final knownEmail = _prefs.getString(_kEmail);
    if (knownEmail != null && knownEmail != email.trim()) {
      return const Result.err(AuthFailure('No account found for that email.'));
    }
    return _delayed(AppUser(
      id: _prefs.getString(_kUserId) ?? _uuid.v4(),
      isAnonymous: false,
      email: email.trim(),
      displayName: _prefs.getString(_kName) ?? email.split('@').first,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<Result<AppUser>> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _delayed(AppUser(
      id: _current?.isAnonymous == true ? _current!.id : _uuid.v4(),
      isAnonymous: false,
      email: email.trim(),
      displayName: displayName?.trim().isNotEmpty == true
          ? displayName!.trim()
          : email.split('@').first,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<Result<AppUser>> signInWithProvider(SocialProvider provider) {
    final label = provider == SocialProvider.google ? 'Google' : 'Apple';
    return _delayed(AppUser(
      id: _uuid.v4(),
      isAnonymous: false,
      email: 'user@${label.toLowerCase()}.example',
      displayName: '$label User',
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<Result<void>> sendPasswordReset(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> signOut() async {
    await _persist(null);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> deleteAccount() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    await _persist(null);
    return const Result.ok(null);
  }

  void dispose() => _controller.close();
}
