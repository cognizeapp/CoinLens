/// Build-time configuration, populated from `--dart-define` values (see
/// `.env.example`). Everything here is safe to ship in the client; secrets stay
/// on the backend.
enum AppFlavor { dev, staging, prod }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.enableFirebase,
    required this.enableRevenueCat,
    required this.enableAds,
    required this.apiBaseUrl,
    required this.revenueCatKeyIos,
    required this.revenueCatKeyAndroid,
    required this.admobBannerIos,
    required this.admobBannerAndroid,
    required this.admobInterstitialIos,
    required this.admobInterstitialAndroid,
    required this.geminiApiKey,
  });

  final AppFlavor flavor;
  final bool enableFirebase;
  final bool enableRevenueCat;

  /// Master switch for AdMob banners. Even when true, ads only show to
  /// free-tier users (premium is always ad-free).
  final bool enableAds;
  final String apiBaseUrl;
  final String revenueCatKeyIos;
  final String revenueCatKeyAndroid;

  /// AdMob unit ids. Empty falls back to a built-in default (real banner units;
  /// Google test units for interstitials until real ones are created).
  final String admobBannerIos;
  final String admobBannerAndroid;
  final String admobInterstitialIos;
  final String admobInterstitialAndroid;

  /// Google Gemini API key for cloud coin identification. Empty → the on-device
  /// pipeline is used. Supplied via --dart-define=GEMINI_API_KEY.
  final String geminiApiKey;
  bool get useGemini => geminiApiKey.isNotEmpty;

  bool get useMockBackend => apiBaseUrl.isEmpty;
  bool get isProd => flavor == AppFlavor.prod;

  factory AppConfig.fromEnvironment() {
    const flavorStr = String.fromEnvironment('APP_FLAVOR', defaultValue: 'dev');
    return AppConfig(
      flavor: AppFlavor.values.firstWhere(
        (f) => f.name == flavorStr,
        orElse: () => AppFlavor.dev,
      ),
      // Both default to on now that the Coinsights Firebase project and
      // RevenueCat app exist; RevenueCat still no-ops to the mock service if
      // no platform API key is supplied (see bootstrap()).
      enableFirebase:
          const bool.fromEnvironment('ENABLE_FIREBASE', defaultValue: true),
      enableRevenueCat:
          const bool.fromEnvironment('ENABLE_REVENUECAT', defaultValue: true),
      enableAds: const bool.fromEnvironment('ENABLE_ADS', defaultValue: true),
      apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
      revenueCatKeyIos: const String.fromEnvironment('REVENUECAT_API_KEY_IOS'),
      revenueCatKeyAndroid:
          const String.fromEnvironment('REVENUECAT_API_KEY_ANDROID'),
      admobBannerIos: const String.fromEnvironment('ADMOB_BANNER_IOS'),
      admobBannerAndroid: const String.fromEnvironment('ADMOB_BANNER_ANDROID'),
      admobInterstitialIos:
          const String.fromEnvironment('ADMOB_INTERSTITIAL_IOS'),
      admobInterstitialAndroid:
          const String.fromEnvironment('ADMOB_INTERSTITIAL_ANDROID'),
      geminiApiKey: const String.fromEnvironment('GEMINI_API_KEY'),
    );
  }
}
