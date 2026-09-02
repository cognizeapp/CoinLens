import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/preferences/app_preferences.dart';
import 'formatters.dart';

/// A [MoneyFormatter] bound to the user's selected currency.
final moneyFormatterProvider = Provider<MoneyFormatter>((ref) {
  final code = ref.watch(currencyCodeProvider);
  return MoneyFormatter(currencyCode: code);
});
