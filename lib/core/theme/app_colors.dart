import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryDark = Color(0xFF0B0E2C); // deep navy background
  static const Color secondaryDark = Color(0xFF12163A);
  static const Color accentYellow = Color(0xFFF5B93D); // CTA buttons
  static const Color white = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF9A9DB5);
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color inputFill = Color(0xFFF5F6FA);
  static const Color divider = Color(0xFFE0E2EA);

  // Accent icon tints (centralized so widgets never hardcode raw hex).
  static const Color iconBlue = Color(0xFF3B5BDB);
  static const Color iconPurple = Color(0xFF7048E8);
  static const Color pageGrey = Color(0xFFF7F8FA); // light app background
}