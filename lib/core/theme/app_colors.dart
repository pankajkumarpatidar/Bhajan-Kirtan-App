import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFFFF6F00);
  static const Color secondary = Color(0xFFFFA000);

  // Background
  static const Color background = Color(0xFFF8F8F8);
  static const Color card = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);

  // Divider
  static const Color divider = Color(0xFFE0E0E0);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFFFF6F00),
      Color(0xFFFF9800),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}