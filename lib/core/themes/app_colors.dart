import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // Primary Colors - Vibrant blue for fitness/energy
  static const Color primary = Color(0xFF2563EB); // Blue 600
  static const Color primaryLight = Color(0xFF60A5FA); // Blue 400
  static const Color primaryDark = Color(0xFF1D4ED8); // Blue 700

  // Secondary Colors - Orange/amber for motivation
  static const Color secondary = Color(0xFFF59E0B); // Amber 500
  static const Color secondaryLight = Color(0xFFFBBF24); // Amber 400
  static const Color secondaryDark = Color(0xFFD97706); // Amber 600

  // Accent Colors
  static const Color accent = Color(0xFF10B981); // Emerald 500
  static const Color accentLight = Color(0xFF34D399); // Emerald 400
  static const Color accentDark = Color(0xFF059669); // Emerald 600

  // Success Colors
  static const Color success = Color(0xFF22C55E); // Green 500
  static const Color successLight = Color(0xFF4ADE80); // Green 400
  static const Color successDark = Color(0xFF16A34A); // Green 600
  static const Color successBackground = Color(0xFFDCFCE7); // Green 100

  // Error Colors
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFF87171); // Red 400
  static const Color errorDark = Color(0xFFDC2626); // Red 600
  static const Color errorBackground = Color(0xFFFEE2E2); // Red 100

  // Warning Colors
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFBBF24); // Amber 400
  static const Color warningDark = Color(0xFFD97706); // Amber 600
  static const Color warningBackground = Color(0xFFFEF3C7); // Amber 100

  // Info Colors
  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoLight = Color(0xFF60A5FA); // Blue 400
  static const Color infoDark = Color(0xFF2563EB); // Blue 600
  static const Color infoBackground = Color(0xFFDBEAFE); // Blue 100

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE2E8F0); // Slate 200
  static const Color lightBorder = Color(0xFFCBD5E1); // Slate 300

  // Light Theme Text Colors
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600
  static const Color lightTextTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color lightTextDisabled = Color(0xFFCBD5E1); // Slate 300

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF334155); // Slate 700
  static const Color darkDivider = Color(0xFF475569); // Slate 600
  static const Color darkBorder = Color(0xFF64748B); // Slate 500

  // Dark Theme Text Colors
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Slate 300
  static const Color darkTextTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextDisabled = Color(0xFF64748B); // Slate 500

  // Muscle Group Colors (for charts and visualization)
  static const Color muscleChest = Color(0xFFEF4444); // Red
  static const Color muscleBack = Color(0xFF3B82F6); // Blue
  static const Color muscleShoulders = Color(0xFFF59E0B); // Amber
  static const Color muscleArms = Color(0xFF8B5CF6); // Violet
  static const Color muscleLegs = Color(0xFF10B981); // Emerald
  static const Color muscleCore = Color(0xFFEC4899); // Pink

  // Chart Colors
  static const List<Color> chartColors = [
    primary,
    secondary,
    accent,
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
  ];

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryLight, secondary],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLight, accent],
  );
}
