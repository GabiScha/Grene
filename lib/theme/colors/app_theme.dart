import 'package:flutter/material.dart';
import 'package:grene/theme/colors/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
  AppColors.load(false);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary, 
    brightness: Brightness.light,
  ).copyWith(
    background: AppColors.background,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    onBackground: AppColors.text,
  );

  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: colorScheme, 
    useMaterial3: true, 
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.text,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.text,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.text),
      bodyMedium: TextStyle(color: AppColors.text),
    ),
  );
}

  static ThemeData darkTheme() {
  AppColors.load(false);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary, 
    brightness: Brightness.light,
  ).copyWith(
    background: AppColors.background,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    onBackground: AppColors.text,
  );

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: colorScheme,
    useMaterial3: true, 
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.text,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.text,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.text),
      bodyMedium: TextStyle(color: AppColors.text),
    ),
  );
}
}
