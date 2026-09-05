import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/preferences/app_preferences.dart';
import '../../services/preferences/locale_provider.dart';
import 'formatters.dart';

/// A [MoneyFormatter] bound to the user's selected currency and UI language
/// (so thousands separators etc. follow the language).
final moneyFormatterProvider = Provider<MoneyFormatter>((ref) {
  final code = ref.watch(currencyCodeProvider);
  final locale =
      ref.watch(localeProvider) ?? PlatformDispatcher.instance.locale;
  return MoneyFormatter(currencyCode: code, locale: locale.languageCode);
});
