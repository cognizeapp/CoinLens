import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/config/app_config.dart';

/// Coinsights' real AdMob banner units (publisher pub-3811419528132275).
/// Ad unit ids aren't secret — they're embedded in every shipped binary.
/// A --dart-define (ADMOB_BANNER_IOS / ADMOB_BANNER_ANDROID) still overrides,
/// e.g. to point a debug build at Google's test units.
const _bannerAndroid = 'ca-app-pub-3811419528132275/9354603614';
const _bannerIos = 'ca-app-pub-3811419528132275/3661247639';

class AdService {
  AdService(this._config);

  /// An ads-off instance — the default for [adServiceProvider] before
  /// bootstrap installs the real one, and what tests get for free.
  AdService.disabled() : _config = null;

  final AppConfig? _config;
  bool _initialized = false;

  /// Ads are possible at all only on mobile, with the master switch on.
  bool get available =>
      (_config?.enableAds ?? false) &&
      !kIsWeb &&
      (Platform.isAndroid || Platform.isIOS);

  String get bannerUnitId {
    final config = _config;
    if (kIsWeb || config == null) return '';
    if (Platform.isIOS) {
      return config.admobBannerIos.isNotEmpty
          ? config.admobBannerIos
          : _bannerIos;
    }
    return config.admobBannerAndroid.isNotEmpty
        ? config.admobBannerAndroid
        : _bannerAndroid;
  }

  Future<void> init() async {
    if (_initialized || !available) return;
    await MobileAds.instance.initialize();
    _initialized = true;
  }
}

final adServiceProvider = Provider<AdService>((ref) => AdService.disabled());
