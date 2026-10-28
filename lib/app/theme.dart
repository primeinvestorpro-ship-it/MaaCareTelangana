import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - Maternal Care & Telangana Health Palette
  static const Color primaryRose = Color(0xFFD81B60);     // Warm maternal pink/rose
  static const Color primaryLight = Color(0xFFFCE4EC);    // Very soft rose tint
  static const Color primaryDark = Color(0xFF880E4F);     // Deep rose
  static const Color secondaryTeal = Color(0xFF00897B);   // Clinical reassurance teal
  static const Color secondaryLight = Color(0xFFE0F2F1);  // Soft teal tint
  static const Color emergencyRed = Color(0xFFD32F2F);    // High-visibility emergency
  static const Color warningAmber = Color(0xFFFFA000);    // Alerts / Attention
  static const Color surfaceWarm = Color(0xFFFFFBFB);     // Calm background
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryRose,
      primary: primaryRose,
      secondary: secondaryTeal,
      surface: surfaceWarm,
      error: emergencyRed,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF9F7F7),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF2E2E2E),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E1E1E),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: primaryLight,
      elevation: 4,
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: primaryRose,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        );
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRose,
        foregroundColor: Colors.white,
        elevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryRose,
        side: const BorderSide(color: primaryRose, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryRose,
      primary: primaryRose,
      secondary: secondaryTeal,
      surface: darkSurface,
      error: emergencyRed,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkBg,
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
