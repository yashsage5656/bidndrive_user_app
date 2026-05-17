import 'package:flutter/material.dart';

/// App Color Constants - Car Marketplace Theme
/// Primary: Mint Green (#2ECC71)
class AppColors {
  AppColors._();
  static const Color backgroundDark = Color(0xFFF5F5F5); // or any light bg
  // Primary Colors
  static const Color primary = Color(0xFF16A34A);
  static const Color primaryLight = Color.fromARGB(255, 70, 231, 124);
  static const Color primaryDark = Color.fromARGB(255, 70, 231, 124);
  static const Color primarySurface = Color(0xFFE8F8F0);

  // Dark Theme Colors (for Auth screens)
  static const Color darkNavy = Color(0xFF1A2B47);
  static const Color darkNavyLight = Color(0xFF243B5A);
  static const Color darkGradientStart = Color(0xFF1E3A5F);
  static const Color darkGradientEnd = Color(0xFF0D1B2A);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Grey Scale
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkGradientStart, darkGradientEnd],
  );

  static const LinearGradient authGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A5F), Color(0xFF152238), Color(0xFF0D1B2A)],
  );

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.15);

  // Divider
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE8E8E8);

  // Overlay
  static Color overlay = Colors.black.withOpacity(0.5);
  static Color overlayLight = Colors.black.withOpacity(0.3);
}
