import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

/// Currency + date formatting. Currency code is user-configurable (Profile ›
/// Currency settings); default is EUR to match the product examples.
class MoneyFormatter {
  const MoneyFormatter({this.currencyCode = 'EUR', this.locale = 'en_IE'});

  final String currencyCode;
  final String locale;

  static const Map<String, String> _symbols = {
    'EUR': '€',
    'USD': '\$',
    'GBP': '£',
    'CHF': 'CHF ',
  };

  String single(num amount) {
    final symbol = _symbols[currencyCode] ?? '$currencyCode ';
    final f = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: amount % 1 == 0 ? 0 : 2,
    );
    return f.format(amount);
  }

  /// e.g. "€25 – €60"
  String range(num min, num max) => '${single(min)} – ${single(max)}';

  /// Compact form for large figures used in rankings: "€16.5M", "€900K", "€180".
  String compact(num amount) {
    final symbol = _symbols[currencyCode] ?? '$currencyCode ';
    final a = amount.abs();
    if (a >= 1000000) {
      final v = amount / 1000000;
      return '$symbol${_trim(v)}M';
    }
    if (a >= 10000) {
      final v = amount / 1000;
      return '$symbol${_trim(v)}K';
    }
    return single(amount);
  }

  String _trim(num v) {
    final s = v.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }
}

String formatScanDate(DateTime date, AppLocalizations l) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 1) return l.justNow;
  if (diff.inHours < 1) return l.minutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l.hoursAgo(diff.inHours);
  if (diff.inDays < 7) return l.daysAgo(diff.inDays);
  return DateFormat.yMMMd(l.localeName).format(date);
}

String formatConfidence(double value) => '${(value * 100).round()}%';
