import 'package:intl/intl.dart';

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
}

String formatScanDate(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return DateFormat.yMMMd().format(date);
}

String formatConfidence(double value) => '${(value * 100).round()}%';
