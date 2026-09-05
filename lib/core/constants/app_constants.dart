abstract final class AppConstants {
  static const String appName = 'Coinsights';
  static const String tagline = 'Discover what your coins are really worth.';

  // Legal — hosted on GitHub Pages (repo cognizeapp/CoinLens, /docs).
  static const String privacyPolicyUrl =
      'https://cognizeapp.github.io/CoinLens/privacy.html';
  static const String termsOfServiceUrl =
      'https://cognizeapp.github.io/CoinLens/terms.html';
  static const String supportUrl =
      'https://cognizeapp.github.io/CoinLens/support.html';
  static const String supportEmail = 'cognizeapp@gmail.com';

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
