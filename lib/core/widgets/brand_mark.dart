import 'package:flutter/material.dart';

/// The Coinsights coin+scan-frame icon, standalone — for app bars, onboarding,
/// and anywhere the full wordmark would be too wide.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.asset(
        'assets/brand/icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// The full "icon + Coinsights" lockup, for the Home header and other
/// high-visibility spots with enough horizontal room.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.height = 32});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/brand/logo_transparent.png',
      height: height,
      fit: BoxFit.fitHeight,
      alignment: Alignment.centerLeft,
    );
  }
}
