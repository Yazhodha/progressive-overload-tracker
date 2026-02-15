import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application typography styles
class AppTypography {
  AppTypography._();

  // Font Family
  static const String fontFamily = 'SF Pro Display';
  static const String fontFamilyMono = 'SF Mono';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Light Theme Text Styles
  static TextTheme get lightTextTheme => TextTheme(
        // Display
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: bold,
          letterSpacing: -0.25,
          color: AppColors.lightTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: bold,
          color: AppColors.lightTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: bold,
          color: AppColors.lightTextPrimary,
        ),

        // Headline
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: semiBold,
          color: AppColors.lightTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: semiBold,
          color: AppColors.lightTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: semiBold,
          color: AppColors.lightTextPrimary,
        ),

        // Title
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: medium,
          color: AppColors.lightTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: medium,
          letterSpacing: 0.15,
          color: AppColors.lightTextPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: medium,
          letterSpacing: 0.1,
          color: AppColors.lightTextPrimary,
        ),

        // Body
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: regular,
          letterSpacing: 0.5,
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: regular,
          letterSpacing: 0.25,
          color: AppColors.lightTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: regular,
          letterSpacing: 0.4,
          color: AppColors.lightTextTertiary,
        ),

        // Label
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: medium,
          letterSpacing: 0.1,
          color: AppColors.lightTextPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: medium,
          letterSpacing: 0.5,
          color: AppColors.lightTextSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: medium,
          letterSpacing: 0.5,
          color: AppColors.lightTextTertiary,
        ),
      );

  // Dark Theme Text Styles
  static TextTheme get darkTextTheme => TextTheme(
        // Display
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: bold,
          letterSpacing: -0.25,
          color: AppColors.darkTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: bold,
          color: AppColors.darkTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: bold,
          color: AppColors.darkTextPrimary,
        ),

        // Headline
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: semiBold,
          color: AppColors.darkTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: semiBold,
          color: AppColors.darkTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: semiBold,
          color: AppColors.darkTextPrimary,
        ),

        // Title
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: medium,
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: medium,
          letterSpacing: 0.15,
          color: AppColors.darkTextPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: medium,
          letterSpacing: 0.1,
          color: AppColors.darkTextPrimary,
        ),

        // Body
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: regular,
          letterSpacing: 0.5,
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: regular,
          letterSpacing: 0.25,
          color: AppColors.darkTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: regular,
          letterSpacing: 0.4,
          color: AppColors.darkTextTertiary,
        ),

        // Label
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: medium,
          letterSpacing: 0.1,
          color: AppColors.darkTextPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: medium,
          letterSpacing: 0.5,
          color: AppColors.darkTextSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: medium,
          letterSpacing: 0.5,
          color: AppColors.darkTextTertiary,
        ),
      );
}
