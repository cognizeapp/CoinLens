import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The Coinsights coin mark, standalone — for app bars, onboarding, and
/// anywhere the full wordmark would be too wide.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: Image.asset(
        'assets/brand/icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// The "coin mark + Coinsights" lockup, rendered live in Inter so it stays
/// crisp at any size and follows the theme.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.height = 30, this.color});

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandMark(size: height),
        SizedBox(width: height * 0.34),
        Text(
          'Coinsights',
          style: TextStyle(
            fontSize: height * 0.72,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
