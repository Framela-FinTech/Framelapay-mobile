import 'package:flutter/material.dart';

/// Colour tokens, resynced to the Framela Figma variable library.
///
/// The hex values below mirror the published Figma variables so the app and
/// the design file stay in lockstep. Existing field names are preserved to
/// avoid churn across screens; each carries the Figma token it maps to.
class AppColors {
  AppColors._();

  // ---- Brand / primary ramp (Figma: Primary Color/*) ----
  static const Color primaryDark = Color(0xFF0B1A33); // Primary 0 — base navy
  static const Color primary20 = Color(0xFF163F6B); // Primary 20
  static const Color primary40 = Color(0xFF2164A1); // Primary 40
  static const Color primary50 = Color(0xFF2B78C4); // Primary 50 (accent blue)

  /// Elevated navy surface (chips/cards on the dark background).
  /// Figma: Framela/Button Hover.
  static const Color secondaryDark = Color(0xFF1F2C43);

  /// Brand gold / primary CTA. Figma: Secondary Color/Secondary 0.
  static const Color accentYellow = Color(0xFFFFB800);

  static const Color white = Color(0xFFFFFFFF);

  // ---- Neutrals (Figma: Neutral Color/*) ----
  static const Color neutral10 = Color(0xFF0A0F14); // Neutral 10 — text
  static const Color neutral40 = Color(0xFF3D4656); // Neutral 40
  static const Color neutral50 = Color(0xFF94A3B8); // Neutral 50
  static const Color neutral60 = Color(0xFF747D8C); // Neutral 60
  static const Color neutral80 = Color(0xFFB6BEC8); // Neutral 80

  /// Secondary / muted text. Figma: Neutral 50 (a.k.a. Framela/Tetiary Text).
  static const Color textGrey = Color(0xFF94A3B8);

  // ---- Semantic (Figma: Semantic Colors/*) ----
  static const Color success = Color(0xFF18794E); // Semantic Success
  static const Color error = Color(0xFFEF4444); // Semantic Error
  static const Color warning = Color(0xFFF59E0B); // Semantic Warning

  // ---- Surfaces & lines ----
  static const Color inputFill = Color(0xFFF5F6FA); // light input fill
  static const Color pageGrey = Color(0xFFF7F8FA); // light app background
  static const Color divider = Color(0xFFCBD5E1); // Figma: Framela/Stroke
  static const Color stroke = Color(0xFFCBD5E1); // Framela/Stroke

  // ---- Button states (Figma: Framela/*) ----
  static const Color buttonHover = Color(0xFF1F2C43); // Framela/Button Hover
  static const Color buttonPressed = Color(0xFF28354B); // Framela/Button Pressed
  static const Color secondaryButtonPressed =
      Color(0xFFE7EDF3); // Framela/Secondary Button Pressed

  // ---- Accent icon tints (centralized so widgets never hardcode raw hex) ----
  static const Color iconBlue = Color(0xFF2B78C4); // Figma: Primary 50
  static const Color iconPurple = Color(0xFF7048E8); // no Figma token; retained
}
