import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/ads/ad_service.dart';
import '../../services/subscription/subscription_service.dart';
import '../theme/app_colors.dart';

/// A single anchored banner ad, shown only to free-tier users on mobile.
/// Premium users, web, and builds with ads disabled get [SizedBox.shrink].
/// Deliberately placed at the very bottom of a scroll view so it never
/// covers content or a primary action.
class BannerAdSlot extends ConsumerStatefulWidget {
  const BannerAdSlot({super.key});

  @override
  ConsumerState<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends ConsumerState<BannerAdSlot> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _requested = false;

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_requested) return;
    _requested = true;
    final ads = ref.read(adServiceProvider);
    if (!ads.available) return;

    final width = MediaQuery.of(context).size.width.truncate();
    await ads.init();

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );
    if (size == null || !mounted) return;

    final ad = BannerAd(
      adUnitId: ads.bannerUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    _ad = ad;
    await ad.load();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);
    if (isPremium) return const SizedBox.shrink();

    final ads = ref.watch(adServiceProvider);
    if (!ads.available) return const SizedBox.shrink();

    // Kick off the load once, after first build (needs MediaQuery).
    if (!_requested) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }

    if (!_loaded || _ad == null) return const SizedBox.shrink();

    return Container(
      alignment: Alignment.center,
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: AdWidget(ad: _ad!),
    );
  }
}
