import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The Coinsights hero coin — the brand emblem coin on a soft orange glow,
/// with an optional slow "float" so it feels alive on the home and onboarding
/// screens. Purely decorative.
class GlowCoin extends StatefulWidget {
  const GlowCoin({
    super.key,
    this.size = 120,
    this.float = true,
    this.glow = true,
  });

  final double size;

  /// Gentle vertical bob.
  final bool float;

  /// Radial orange halo behind the coin.
  final bool glow;

  @override
  State<GlowCoin> createState() => _GlowCoinState();
}

class _GlowCoinState extends State<GlowCoin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  @override
  void initState() {
    super.initState();
    if (widget.float) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final coin = Image.asset(
      'assets/brand/coin_hero.png',
      width: s,
      height: s,
      fit: BoxFit.contain,
    );

    final glowing = widget.glow
        ? Container(
            width: s * 1.5,
            height: s * 1.5,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.28),
                  AppColors.gold.withValues(alpha: 0.06),
                  AppColors.gold.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
            child: coin,
          )
        : coin;

    if (!widget.float) return glowing;

    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_c.value);
        return Transform.translate(
          offset: Offset(0, -6 + t * 12),
          child: child,
        );
      },
      child: glowing,
    );
  }
}
