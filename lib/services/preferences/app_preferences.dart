import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';

/// Overridden in `main()` once SharedPreferences has loaded.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider not overridden'),
);

/// Small typed wrapper over the handful of local preferences the app keeps.
class AppPreferences {
  AppPreferences(this._prefs);
  final SharedPreferences _prefs;

  bool get onboardingComplete =>
      _prefs.getBool(AppConstants.kOnboardingComplete) ?? false;

  Future<void> setOnboardingComplete() =>
      _prefs.setBool(AppConstants.kOnboardingComplete, true);

  String get currencyCode =>
      _prefs.getString(AppConstants.kCurrencyCode) ?? 'EUR';

  Future<void> setCurrencyCode(String code) =>
      _prefs.setString(AppConstants.kCurrencyCode, code);

  /// The user's forced UI language, or `null` to follow the device language.
  String? get languageOverride {
    final v = _prefs.getString(AppConstants.kLanguageCode);
    return (v == null || v.isEmpty) ? null : v;
  }

  Future<void> setLanguageOverride(String? code) => (code == null)
      ? _prefs.remove(AppConstants.kLanguageCode)
      : _prefs.setString(AppConstants.kLanguageCode, code);
}

final appPreferencesProvider = Provider<AppPreferences>(
  (ref) => AppPreferences(ref.watch(sharedPreferencesProvider)),
);

/// Reactive onboarding flag used by the router redirect.
class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier(this._prefs) : super(_prefs.onboardingComplete);
  final AppPreferences _prefs;

  Future<void> complete() async {
    await _prefs.setOnboardingComplete();
    state = true;
  }
}

final onboardingCompleteProvider =
    StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier(ref.watch(appPreferencesProvider));
});

/// Reactive currency selection.
class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier(this._prefs) : super(_prefs.currencyCode);
  final AppPreferences _prefs;

  Future<void> set(String code) async {
    await _prefs.setCurrencyCode(code);
    state = code;
  }
}

final currencyCodeProvider =
    StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier(ref.watch(appPreferencesProvider));
});
