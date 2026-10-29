import 'package:flutter/material.dart';

/// Single source of truth for every color in the app.
/// Never hardcode Color(...) or Colors.xxx inside screens/widgets.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2F6BFF); // royal blue
  static const Color accent = Color(0xFF7C5CFF); // violet

  // Surfaces
  static const Color background = Color(0xFF0B1426); // deep navy
  static const Color surface = Color(0xFF132039);
  static const Color surfaceLight = Color(0xFF1B2B49);
  static const Color border = Color(0xFF2A3B5C);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA9B4C8);

  // Status
  static const Color error = Color(0xFFE5484D);
  static const Color success = Color(0xFF2ECC8F);

  // Utility
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
  static const Color scrim = Color(0x99000000); // scanner dim overlay
}
