import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static final ColorScheme _scheme = ColorScheme.fromSeed(
    seedColor: AppColors.navy,
    brightness: Brightness.light,
    primary: AppColors.navy,
    secondary: AppColors.blue,
    tertiary: AppColors.signalYellow,
    error: AppColors.dangerRed,
    surface: AppColors.surface,
  );

  static ThemeData get light {
    const borderRadius = BorderRadius.all(Radius.circular(20));

    return ThemeData(
      useMaterial3: true,
      colorScheme: _scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.standard,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          color: AppColors.ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: AppColors.ink,
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.45, color: AppColors.ink),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: AppColors.muted,
        ),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      appBarTheme: const AppBarThemeData(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 10,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.blue.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? AppColors.navy
                : AppColors.muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.navy
                : AppColors.muted,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: borderRadius),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: AppColors.blue, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        shape: StadiumBorder(),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
