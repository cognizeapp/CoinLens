import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// A place a collector can realistically sell a coin, with the trade-offs
/// that matter (reach, fees, speed, whether it suits a low- or high-value
/// piece). Deliberately contains **no** scraped "sold for X" data — the
/// numbers shown to the user are our own model's estimate, clearly labelled.
enum Marketplace {
  ebay,
  heritageAuctions,
  stacksBowers,
  certifiedDealer,
  localCoinShop,
  collectorForums,
  coinShow,
  facebookGroups,
}

extension MarketplaceInfo on Marketplace {
  String name(AppLocalizations l) => switch (this) {
        Marketplace.ebay => l.sellEbayName,
        Marketplace.heritageAuctions => l.sellHeritageName,
        Marketplace.stacksBowers => l.sellStacksName,
        Marketplace.certifiedDealer => l.sellCertifiedDealerName,
        Marketplace.localCoinShop => l.sellLocalShopName,
        Marketplace.collectorForums => l.sellForumsName,
        Marketplace.coinShow => l.sellCoinShowName,
        Marketplace.facebookGroups => l.sellFacebookName,
      };

  String blurb(AppLocalizations l) => switch (this) {
        Marketplace.ebay => l.sellEbayBlurb,
        Marketplace.heritageAuctions => l.sellHeritageBlurb,
        Marketplace.stacksBowers => l.sellStacksBlurb,
        Marketplace.certifiedDealer => l.sellCertifiedDealerBlurb,
        Marketplace.localCoinShop => l.sellLocalShopBlurb,
        Marketplace.collectorForums => l.sellForumsBlurb,
        Marketplace.coinShow => l.sellCoinShowBlurb,
        Marketplace.facebookGroups => l.sellFacebookBlurb,
      };

  IconData get icon => switch (this) {
        Marketplace.ebay => Icons.shopping_bag_outlined,
        Marketplace.heritageAuctions => Icons.gavel_rounded,
        Marketplace.stacksBowers => Icons.gavel_rounded,
        Marketplace.certifiedDealer => Icons.verified_outlined,
        Marketplace.localCoinShop => Icons.storefront_outlined,
        Marketplace.collectorForums => Icons.forum_outlined,
        Marketplace.coinShow => Icons.event_outlined,
        Marketplace.facebookGroups => Icons.groups_outlined,
      };

  /// Optional external link. Kept to well-known landing pages only.
  String? get url => switch (this) {
        Marketplace.ebay => 'https://www.ebay.com/b/Coins/11116',
        Marketplace.heritageAuctions => 'https://coins.ha.com/',
        Marketplace.stacksBowers => 'https://www.stacksbowers.com/',
        _ => null,
      };
}

/// What the app suggests for a given coin, derived only from its estimated
/// value. Higher-value coins lean towards auction houses and certification;
/// everyday coins lean towards eBay, dealers and shows.
class SellGuide {
  const SellGuide({
    required this.resaleLowEur,
    required this.resaleHighEur,
    required this.marketplaces,
    required this.tierAdvice,
  });

  /// A realistic "what a private seller nets" band — narrower and lower than
  /// the retail market value, because of buyer premiums, dealer margins and
  /// the discount collectors expect on a raw (un-slabbed) coin.
  final double resaleLowEur;
  final double resaleHighEur;

  final List<Marketplace> marketplaces;

  /// One line tailored to the coin's value tier (grading / shipping / photos).
  final String Function(AppLocalizations) tierAdvice;

  static SellGuide forValue(double typicalEur) {
    // Private-sale realism factor vs. retail "market value".
    final low = typicalEur * 0.55;
    final high = typicalEur * 0.9;

    if (typicalEur >= 2000) {
      return SellGuide(
        resaleLowEur: low,
        resaleHighEur: high,
        marketplaces: const [
          Marketplace.heritageAuctions,
          Marketplace.stacksBowers,
          Marketplace.certifiedDealer,
          Marketplace.ebay,
          Marketplace.coinShow,
        ],
        tierAdvice: (l) => l.sellTierHigh,
      );
    }
    if (typicalEur >= 150) {
      return SellGuide(
        resaleLowEur: low,
        resaleHighEur: high,
        marketplaces: const [
          Marketplace.ebay,
          Marketplace.certifiedDealer,
          Marketplace.collectorForums,
          Marketplace.coinShow,
          Marketplace.localCoinShop,
        ],
        tierAdvice: (l) => l.sellTierMid,
      );
    }
    return SellGuide(
      resaleLowEur: low,
      resaleHighEur: high,
      marketplaces: const [
        Marketplace.ebay,
        Marketplace.localCoinShop,
        Marketplace.facebookGroups,
        Marketplace.coinShow,
        Marketplace.collectorForums,
      ],
      tierAdvice: (l) => l.sellTierLow,
    );
  }
}
