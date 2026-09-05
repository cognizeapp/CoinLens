import 'package:flutter/widgets.dart';

/// Bundled real photos for well-known catalog coins, all openly licensed
/// (public domain or Creative Commons with attribution — see
/// assets/coins/CREDITS.md for the exact license and photographer per file).
/// Keyed by [CatalogEntry.id]. Coins without an entry here fall back to the
/// procedurally-generated metallic mockup.
class _RefImage {
  const _RefImage(this.asset, [this.alignment = Alignment.center]);
  final String asset;

  /// Some source photos are a museum/auction "obverse + reverse" scan side by
  /// side (or stacked); this anchors the cover-crop to just one face instead
  /// of a seam down the middle.
  final Alignment alignment;
}

const Map<String, _RefImage> _referenceCoinImages = {
  'us-morgan-dollar': _RefImage('assets/coins/us-morgan-dollar.jpg'),
  'us-peace-dollar': _RefImage('assets/coins/us-peace-dollar.jpg'),
  'us-lincoln-wheat-cent':
      _RefImage('assets/coins/us-lincoln-wheat-cent.jpg', Alignment(-1, 0)),
  'us-washington-quarter':
      _RefImage('assets/coins/us-washington-quarter.jpg', Alignment(0, -1)),
  'us-silver-eagle': _RefImage('assets/coins/us-silver-eagle.png'),
  'gb-sovereign': _RefImage('assets/coins/gb-sovereign.jpg'),
  'gb-50-pence': _RefImage('assets/coins/gb-50-pence.jpg'),
  'za-krugerrand': _RefImage('assets/coins/za-krugerrand.jpg'),
  'greece-athens-owl-tetradrachm':
      _RefImage('assets/coins/greece-athens-owl-tetradrachm.jpg'),
  'rome-aureus-augustus':
      _RefImage('assets/coins/rome-aureus-augustus.jpg', Alignment(-1, 0)),
  'rome-denarius':
      _RefImage('assets/coins/rome-denarius.jpg', Alignment(-1, 0)),
  'es-8-reales': _RefImage('assets/coins/es-8-reales.jpg'),
  'nl-ducat-gold':
      _RefImage('assets/coins/nl-ducat-gold.jpg', Alignment(-1, 0)),
};

/// Path to a bundled real photo for this catalog coin, or null if none is
/// available yet (falls back to the generated mockup).
String? referenceCoinImageAsset(String catalogEntryId) =>
    _referenceCoinImages[catalogEntryId]?.asset;

/// Cover-crop anchor for a bundled reference photo returned by
/// [referenceCoinImageAsset]. Looked up by asset path so callers that only
/// carry the path (e.g. [CoinThumb]) don't need the catalog id too.
Alignment referenceCoinImageAlignment(String asset) =>
    _referenceCoinImages.values
        .firstWhere((v) => v.asset == asset, orElse: () => const _RefImage(''))
        .alignment;
