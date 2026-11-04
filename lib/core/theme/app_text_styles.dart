import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography scale, resynced to the Framela Figma text-style library.
///
/// Family is Inter (matching the Figma tokens); sizes, weights, line-heights
/// and letter-spacing mirror the published styles. `height` is expressed as
/// Flutter's multiplier (Figma lineHeight / fontSize).
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  // ---- Display / headline ----
  /// Figma: Bold/Display Small — 38 / SemiBold / lh 48.
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 38,
    fontWeight: FontWeight.w600,
    height: 48 / 38,
    color: AppColors.neutral10,
  );

  /// Figma: Framela Bold/Headline 1 — 32 / Bold / lh 48.
  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 48 / 32,
    color: AppColors.neutral10,
  );

  /// Figma: Framela Semi Bold/Headline — 28 / SemiBold / lh 42.
  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 42 / 28,
    color: AppColors.neutral10,
  );

  // ---- Title ----
  /// Figma: Semi Bold/Title Small — 16 / SemiBold / lh 24 / ls 0.5.
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    letterSpacing: 0.5,
    color: AppColors.neutral10,
  );

  /// Figma: Semi Bold/Title X-Small — 14 / SemiBold / lh 24 / ls 0.1.
  static const TextStyle titleXSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 24 / 14,
    letterSpacing: 0.1,
    color: AppColors.neutral10,
  );

  // ---- Body ----
  /// Figma: Framela Semi Bold/Body Text Large — 16 / SemiBold / lh 24.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    color: AppColors.neutral10,
  );

  /// Figma: Framela Semi Bold/Body Text Medium — 14 / SemiBold / lh 20 / ls 0.25.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.25,
    color: AppColors.neutral10,
  );

  // ---- Label ----
  /// Figma: Framela Bold/Label Text — 14 / Bold / lh 20.
  static const TextStyle labelText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    color: AppColors.neutral10,
  );

  /// Figma: Framela Medium/Label Large — 14 / Medium / lh 20 / ls 0.1.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
    color: AppColors.neutral10,
  );

  /// Figma: Framela Semi Bold/Label Text Medium — 12 / SemiBold / lh 16 / ls 0.5.
  static const TextStyle labelMediumSemibold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.5,
    color: AppColors.neutral10,
  );

  /// Figma: Framela Medium/Label Medium — 12 / Medium / lh 16 / ls 0.5.
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.5,
    color: AppColors.neutral60,
  );

  /// Figma: Framela Regular/Label Medium — 12 / Regular / lh 16 / ls 0.5.
  static const TextStyle labelRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.5,
    color: AppColors.neutral60,
  );
}
