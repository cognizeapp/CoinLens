/// Build-time configuration, populated from `--dart-define` values (see
/// `.env.example`). Everything here is safe to ship in the client; secrets stay
/// on the backend.
enum AppFlavor { dev, staging, prod }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.enableFirebase,
    required this.enableRevenueCat,
    required this.apiBaseUrl,
    required this.revenueCatKeyIos,
    required this.revenueCatKeyAndroid,
  });

  final AppFlavor flavor;
  final bool enableFirebase;
  final bool enableRevenueCat;
  final String apiBaseUrl;
  final String revenueCatKeyIos;
  final String revenueCatKeyAndroid;

  bool get useMockBackend => apiBaseUrl.isEmpty;
  bool get isProd => flavor == AppFlavor.prod;

  factory AppConfig.fromEnvironment() {
    const flavorStr = String.fromEnvironment('APP_FLAVOR', defaultValue: 'dev');
    return AppConfig(
      flavor: AppFlavor.values.firstWhere(
        (f) => f.name == flavorStr,
        orElse: () => AppFlavor.dev,
      ),
      enableFirebase:
          const bool.fromEnvironment('ENABLE_FIREBASE', defaultValue: false),
      enableRevenueCat:
          const bool.fromEnvironment('ENABLE_REVENUECAT', defaultValue: false),
      apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
      revenueCatKeyIos: const String.fromEnvironment('REVENUECAT_API_KEY_IOS'),
      revenueCatKeyAndroid:
          const String.fromEnvironment('REVENUECAT_API_KEY_ANDROID'),
    );
  }
}
