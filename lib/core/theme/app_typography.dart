import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Inter-based type scale. Large value numbers get their own prominent styles.
abstract final class AppTypography {
  static TextTheme textTheme(TextTheme base) {
    final inter = GoogleFonts.interTextTheme(base);
    return inter.copyWith(
      displayLarge: inter.displayLarge?.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      ),
      headlineMedium: inter.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleLarge: inter.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: inter.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: inter.bodyLarge?.copyWith(
        fontSize: 15,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      bodyMedium: inter.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      labelLarge: inter.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: AppColors.textPrimary,
      ),
      labelSmall: inter.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.textSecondary,
      ),
    );
  }

  /// Hero style for estimated-value figures on the result screen.
  static const TextStyle valueHero = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.gold,
  );

  static const TextStyle valueMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}
