import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/app_config.dart';

/// Ad unit ids. The shipped defaults are Google's official *test* units —
/// safe to submit (they show a labelled "Test Ad" and never earn or spend).
/// Real Coinsights units are supplied per build via --dart-define
/// (ADMOB_BANNER_IOS / ADMOB_BANNER_ANDROID / ADMOB_INTERSTITIAL_IOS /
/// ADMOB_INTERSTITIAL_ANDROID) once the AdMob account has approved the app
/// (which Google only does after the app is live on a store).
const _bannerAndroidTest = 'ca-app-pub-3940256099942544/6300978111';
const _bannerIosTest = 'ca-app-pub-3940256099942544/2934735716';
const _interstitialAndroidTest = 'ca-app-pub-3940256099942544/1033173712';

/// Real Coinsights iOS interstitial (AdMob publisher pub-9425660542593371,
/// same account as the iOS GADApplicationIdentifier). Serves real ads once
/// AdMob approves the app after launch; until then it "no fills" and the app
/// simply skips the ad — no harm.
const _interstitialIosReal = 'ca-app-pub-9425660542593371/1529023831';

/// Show an interstitial after every Nth scan for free users, to offset the
/// per-scan cost of cloud identification.
const _scansPerInterstitial = 5;
const _kScanCountKey = 'ad_scan_count';

class AdService {
  AdService(this._config, [this._prefs]);

  /// An ads-off instance — the default for [adServiceProvider] before
  /// bootstrap installs the real one, and what tests get for free.
  AdService.disabled()
      : _config = null,
        _prefs = null;

  final AppConfig? _config;
  final SharedPreferences? _prefs;
  bool _initialized = false;

  InterstitialAd? _interstitial;
  bool _loadingInterstitial = false;

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
          : _bannerIosTest;
    }
    return config.admobBannerAndroid.isNotEmpty
        ? config.admobBannerAndroid
        : _bannerAndroidTest;
  }

  String get _interstitialUnitId {
    final config = _config!;
    if (Platform.isIOS) {
      return config.admobInterstitialIos.isNotEmpty
          ? config.admobInterstitialIos
          : _interstitialIosReal;
    }
    return config.admobInterstitialAndroid.isNotEmpty
        ? config.admobInterstitialAndroid
        : _interstitialAndroidTest;
  }

  /// Non-personalised (contextual) ad request — no advertising profile is
  /// built, so no App Tracking Transparency prompt is needed. Matches the
  /// privacy policy.
  static const AdRequest _request = AdRequest(extras: {'npa': '1'});

  Future<void> init() async {
    if (_initialized || !available) return;
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.g,
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
      ),
    );
    _initialized = true;
    _preloadInterstitial();
  }

  void _preloadInterstitial() {
    if (!available || _interstitial != null || _loadingInterstitial) return;
    _loadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: _request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _loadingInterstitial = false;
        },
        onAdFailedToLoad: (_) {
          _interstitial = null;
          _loadingInterstitial = false;
        },
      ),
    );
  }

  /// Call once per completed scan for a **free** user. Every
  /// [_scansPerInterstitial]th scan an interstitial is shown; a fresh one is
  /// preloaded for next time. Silently does nothing if ads are off or no ad is
  /// ready yet.
  Future<void> recordScanAndMaybeInterstitial() async {
    if (!available) return;
    if (!_initialized) await init();

    final prefs = _prefs;
    final count = ((prefs?.getInt(_kScanCountKey) ?? 0) + 1);
    await prefs?.setInt(_kScanCountKey, count);

    if (count % _scansPerInterstitial != 0) {
      _preloadInterstitial();
      return;
    }

    final ad = _interstitial;
    if (ad == null) {
      _preloadInterstitial();
      return;
    }
    _interstitial = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _preloadInterstitial();
      },
    );
    await ad.show();
  }
}

final adServiceProvider = Provider<AdService>((ref) => AdService.disabled());
