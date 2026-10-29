import 'package:flutter/material.dart';

/// MediaQuery based sizing. Use instead of fixed pixel values.
extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// [percent] of screen width (0-100).
  double wp(double percent) => screenWidth * percent / 100;

  /// [percent] of screen height (0-100).
  double hp(double percent) => screenHeight * percent / 100;

  /// Scaled font / icon size, relative to a 390 px wide design.
  double sp(double size) => size * (screenWidth / 390).clamp(0.85, 1.25);
}
