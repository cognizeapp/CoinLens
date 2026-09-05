import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/config/app_config.dart';

/// Google's public test banner units — safe to ship, show a labelled
/// "Test Ad", and never earn or spend. Used until real AdMob units are
/// supplied via --dart-define (ADMOB_BANNER_IOS / ADMOB_BANNER_ANDROID).
const _testBannerAndroid = 'ca-app-pub-3940256099942544/9214589741';
const _testBannerIos = 'ca-app-pub-3940256099942544/2435281174';

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
          : _testBannerIos;
    }
    return config.admobBannerAndroid.isNotEmpty
        ? config.admobBannerAndroid
        : _testBannerAndroid;
  }

  Future<void> init() async {
    if (_initialized || !available) return;
    await MobileAds.instance.initialize();
    _initialized = true;
  }
}

final adServiceProvider = Provider<AdService>((ref) => AdService.disabled());
