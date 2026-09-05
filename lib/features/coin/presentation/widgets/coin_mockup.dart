import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/coin_models.dart';

/// A generated, license-free "coin face" — used everywhere a coin needs a
/// visual but we have no real photo of it (catalog entries, rankings, search
/// results). Purely vector: a metallic disc whose gradient is derived from
/// the coin's material, an embossed rim, and the denomination/initial as the
/// engraving. Deterministic per [seed] so the same coin always renders the
/// same subtle rim pattern.
///
/// For a coin the user actually photographed, prefer [CoinPhotoMockup]
/// instead — it frames their own capture the same way a numismatic photo
/// would be presented, rather than fabricating one.
class CoinMockup extends StatelessWidget {
  const CoinMockup({
    super.key,
    required this.material,
    required this.rarity,
    this.label,
    this.seed = '',
    this.size = 56,
  });

  final String material;
  final CoinRarity rarity;
  /// Short engraving text — usually the denomination (e.g. "25¢", "£1").
  final String? label;
  final String seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CoinMockupPainter(
          palette: _materialPalette(material),
          rarity: rarity,
          label: label,
          seed: seed,
        ),
      ),
    );
  }
}

class _MetalPalette {
  const _MetalPalette(this.light, this.mid, this.dark, this.engraving);
  final Color light;
  final Color mid;
  final Color dark;
  final Color engraving;
}

_MetalPalette _materialPalette(String material) {
  final m = material.toLowerCase();
  if (m.contains('gold')) {
    return const _MetalPalette(
      Color(0xFFF3D77B),
      AppColors.gold,
      Color(0xFF8A6A16),
      Color(0xFF4A3708),
    );
  }
  if (m.contains('silver')) {
    return const _MetalPalette(
      Color(0xFFF2F4F7),
      Color(0xFFC3CAD6),
      Color(0xFF7D8592),
      Color(0xFF3A3F47),
    );
  }
  if (m.contains('copper') || m.contains('bronze')) {
    return const _MetalPalette(
      Color(0xFFE3A97C),
      Color(0xFFB9713F),
      Color(0xFF6E3F1E),
      Color(0xFF35190A),
    );
  }
  if (m.contains('nickel') || m.contains('steel') || m.contains('clad')) {
    return const _MetalPalette(
      Color(0xFFE3E6EA),
      Color(0xFFAEB4BD),
      Color(0xFF6B7078),
      Color(0xFF2C2F33),
    );
  }
  // Bimetallic / unknown — a warm brass default.
  return const _MetalPalette(
    Color(0xFFE9D9A0),
    Color(0xFFC7A44A),
    Color(0xFF7A611F),
    Color(0xFF3D3009),
  );
}

class _CoinMockupPainter extends CustomPainter {
  _CoinMockupPainter({
    required this.palette,
    required this.rarity,
    required this.label,
    required this.seed,
  });

  final _MetalPalette palette;
  final CoinRarity rarity;
  final String? label;
  final String seed;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) / 2;

    // Body: radial metallic gradient for a struck-disc look.
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = ui.Gradient.radial(
          center - Offset(r * 0.3, r * 0.3),
          r * 1.6,
          [palette.light, palette.mid, palette.dark],
          const [0.0, 0.55, 1.0],
        ),
    );

    // Rim.
    canvas.drawCircle(
      center,
      r * 0.98,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.08
        ..color = palette.dark.withValues(alpha: 0.55),
    );

    // Reeded edge — small ticks around the border, deterministic per seed.
    const tickCount = 40;
    final hash = seed.isEmpty ? 0 : seed.codeUnits.fold<int>(0, (a, b) => a + b);
    for (var i = 0; i < tickCount; i++) {
      final angle = (2 * math.pi / tickCount) * i + (hash % 360) * math.pi / 180;
      final inner = Offset(
        center.dx + math.cos(angle) * r * 0.92,
        center.dy + math.sin(angle) * r * 0.92,
      );
      final outer = Offset(
        center.dx + math.cos(angle) * r * 0.99,
        center.dy + math.sin(angle) * r * 0.99,
      );
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..color = palette.dark.withValues(alpha: 0.35)
          ..strokeWidth = r * 0.03,
      );
    }

    // Inner ring (typical of coin design).
    canvas.drawCircle(
      center,
      r * 0.78,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.02
        ..color = palette.engraving.withValues(alpha: 0.35),
    );

    // Engraving text (denomination / initial).
    final text = (label != null && label!.trim().isNotEmpty)
        ? label!.trim()
        : '¤';
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: palette.engraving.withValues(alpha: 0.82),
          fontSize: r * (text.length > 2 ? 0.62 : 0.82),
          fontWeight: FontWeight.w800,
          fontFeatures: const [ui.FontFeature.tabularFigures()],
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: r * 1.6);
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));

    // Rarity glint — a soft gold ring for Rare and above, echoing the app's
    // rarity color scale so a glance at Rankings reads value at a glance.
    if (rarity == CoinRarity.veryRare || rarity == CoinRarity.extremelyRare) {
      canvas.drawCircle(
        center,
        r * 0.99,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.05
          ..color = AppColors.gold.withValues(alpha: 0.9),
      );
    }

    // Specular highlight for a "struck metal" feel.
    canvas.drawCircle(
      center - Offset(r * 0.32, r * 0.35),
      r * 0.28,
      Paint()
        ..shader = ui.Gradient.radial(
          center - Offset(r * 0.32, r * 0.35),
          r * 0.28,
          [Colors.white.withValues(alpha: 0.35), Colors.white.withValues(alpha: 0.0)],
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _CoinMockupPainter oldDelegate) {
    return oldDelegate.palette != palette ||
        oldDelegate.rarity != rarity ||
        oldDelegate.label != label ||
        oldDelegate.seed != seed;
  }
}

/// Frames the user's own front-of-coin capture into a circular "coin photo"
/// presentation — used on the Result screen and in the Collection, where a
/// real photo exists and shouldn't be replaced by a generated mockup.
class CoinPhotoMockup extends StatelessWidget {
  const CoinPhotoMockup({
    super.key,
    required this.image,
    this.rarity,
    this.size = 96,
    this.alignment = Alignment.center,
  });

  final ImageProvider image;
  final CoinRarity? rarity;
  final double size;

  /// Where to anchor the cover-crop — most of the user's own captures are a
  /// single coin face already, but bundled reference photos (see
  /// referenceCoinImageAsset) are often a museum/auction "obverse + reverse"
  /// side-by-side or stacked scan, so callers pass an edge alignment to crop
  /// to just one face instead of a seam down the middle.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final ringColor = (rarity == CoinRarity.veryRare || rarity == CoinRarity.extremelyRare)
        ? AppColors.gold
        : AppColors.border;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.045),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A3F47), Color(0xFF15171C)],
        ),
        border: Border.all(color: ringColor, width: size * 0.02),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: size * 0.12,
            offset: Offset(0, size * 0.04),
          ),
        ],
      ),
      child: ClipOval(
        child: Image(image: image, fit: BoxFit.cover, alignment: alignment),
      ),
    );
  }
}
