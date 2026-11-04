import 'package:flutter/material.dart';

/// Elevation tokens, resynced to the Framela Figma effect styles.
///
/// Figma colours are RGBA; Flutter `Color` is ARGB (0xAARRGGBB), so the alpha
/// byte is moved to the front. `spread` maps to [BoxShadow.spreadRadius] and
/// `radius` to [BoxShadow.blurRadius].
class AppShadows {
  AppShadows._();

  /// Figma: Framela Shadow 2 — #0B1F3A0F, offset (0, 2), radius 8, spread 0.
  /// The default resting elevation for white content cards.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F0B1F3A),
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  /// Figma: Framela Shadow 1 — #06031614, offset (0, 0), radius 24, spread 10.
  /// A softer, wider ambient shadow for raised/floating surfaces.
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x14060316),
      offset: Offset(0, 0),
      blurRadius: 24,
      spreadRadius: 10,
    ),
  ];
}
