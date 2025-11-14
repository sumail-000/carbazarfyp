import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors - Deep Blue & Amber
  static const Color primary = Color(0xFF0D47A1); // Deep Blue
  static const Color primaryLight = Color(0xFF5472D3);
  static const Color primaryDark = Color(0xFF002171);
  
  static const Color accent = Color(0xFFFFB300); // Amber
  static const Color accentLight = Color(0xFFFFE54C);
  static const Color accentDark = Color(0xFFC68400);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF29B6F6);

  // Light Theme Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textTertiary = Color(0xFF9E9E9E);
  
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextTertiary = Color(0xFF757575);
  
  static const Color darkBorder = Color(0xFF424242);
  static const Color darkDivider = Color(0xFF303030);

  // Verification Badge Colors
  static const Color verified = Color(0xFF4CAF50);
  static const Color unverified = Color(0xFF9E9E9E);
  static const Color pending = Color(0xFFFFA726);
  static const Color blocked = Color(0xFFEF5350);

  // Auction Status Colors
  static const Color auctionLive = Color(0xFFEF5350);
  static const Color auctionUpcoming = Color(0xFF29B6F6);
  static const Color auctionEnded = Color(0xFF9E9E9E);
  
  // Overlay Colors
  static const Color overlayLight = Color(0x0D000000); // 5% black
  static const Color overlayMedium = Color(0x1F000000); // 12% black
  static const Color overlayHeavy = Color(0x61000000); // 38% black
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient auctionGradient = LinearGradient(
    colors: [Color(0xFFEF5350), Color(0xFFFF6F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

