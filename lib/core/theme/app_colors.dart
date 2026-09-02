import 'package:flutter/material.dart';

/// CoinLens visual identity — a sophisticated dark palette where gold signals
/// value, rarity and Premium.
abstract final class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0B0D12);
  static const Color backgroundSecondary = Color(0xFF151820);
  static const Color card = Color(0xFF1C2029);
  static const Color cardElevated = Color(0xFF232833);

  // Accents
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldSoft = Color(0x33D4AF37);
  static const Color blue = Color(0xFF4F8CFF);
  static const Color blueSoft = Color(0x334F8CFF);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A7B5);
  static const Color textTertiary = Color(0xFF6B7280);

  // Semantic
  static const Color success = Color(0xFF3DD68C);
  static const Color warning = Color(0xFFF5A623);
  static const Color danger = Color(0xFFFF5C5C);

  // Lines / borders
  static const Color border = Color(0xFF2A2F3A);
  static const Color divider = Color(0xFF20242E);

  // Rarity scale (Common -> Extremely Rare)
  static const Color rarityCommon = Color(0xFF6B7280);
  static const Color rarityUncommon = Color(0xFF3DD68C);
  static const Color rarityRare = Color(0xFF4F8CFF);
  static const Color rarityVeryRare = Color(0xFF9B7BFF);
  static const Color rarityExtremelyRare = Color(0xFFD4AF37);
}
