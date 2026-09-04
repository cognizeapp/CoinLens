abstract final class AppConstants {
  static const String appName = 'Coinsight';
  static const String tagline = 'Discover what your coins are really worth.';

  // Legal
  static const String privacyPolicyUrl = 'https://coinsight.app/privacy';
  static const String termsOfServiceUrl = 'https://coinsight.app/terms';
  static const String supportEmail = 'support@coinsight.app';

  // Disclaimers surfaced across value / grading UI.
  static const String valueDisclaimer =
      'Coin values are estimates based on available data and may vary depending '
      'on condition, authenticity and market demand.';
  static const String gradingDisclaimer =
      'This app does not provide professional numismatic authentication or '
      'financial advice. Condition estimates are approximate.';

  // SharedPreferences keys.
  static const String kOnboardingComplete = 'onboarding_complete';
  static const String kCurrencyCode = 'currency_code';
  static const String kLanguageCode = 'language_code';
}
