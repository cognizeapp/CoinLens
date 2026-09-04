import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_preferences.dart';

/// The languages Coinsight ships translations for. A `null` locale means
/// "follow the device language".
const supportedLocales = <Locale>[
  Locale('en'),
  Locale('it'),
  Locale('es'),
  Locale('fr'),
  Locale('de'),
  Locale('pt'),
  Locale('nl'),
];

/// `null` = system default; otherwise a forced language.
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(this._prefs)
      : super(_decode(_prefs.languageOverride));

  final AppPreferences _prefs;

  static Locale? _decode(String? code) =>
      (code == null || code.isEmpty) ? null : Locale(code);

  Future<void> set(Locale? locale) async {
    state = locale;
    await _prefs.setLanguageOverride(locale?.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier(ref.watch(appPreferencesProvider));
});
