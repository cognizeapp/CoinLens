import 'bootstrap.dart';

/// Single entry point. Flavor-specific entry points (main_dev.dart,
/// main_prod.dart) can be added later; configuration is driven by
/// `--dart-define` today.
Future<void> main() => bootstrap();
