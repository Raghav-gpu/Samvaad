import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, // Dark Charcoal
    primaryColor: const Color(0xFF1DB954), // Bright Green Accent
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor:
          const Color.fromRGBO(6, 6, 6, 1), // Slightly darker for app bar
      titleTextStyle: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.cyan, brightness: Brightness.dark),
    textTheme: TextTheme(
      // Titles or Headings
      titleLarge: GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      // Subtitles
      titleSmall: GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      // Chat Messages or Body Text
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      // Secondary Text
      bodySmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
//colors

class AppColors {
  // Background Color
  static const Color background = Color.fromRGBO(6, 6, 6, 1);

  // Primary Accent Colors
  static const Color primaryBlue = Color(0xFF64B5F6); // Electric Blue
  static const Color primaryGreen = Color(0xFF80C785); // Neon Green
  static const Color primaryPurple = Color(0xFFD1A1E0); // Neon Purple

  // Secondary Accent Colors
  static const Color secondaryPink = Color(0xFFF50057); // Pastel Pink
  static const Color secondaryBlue = Color(0xFF03A9F4); // Pastel Blue
  static const Color secondaryYellow = Color(0xFFFFEB3B); // Pastel Yellow

  // Text Colors
  static const Color textPrimary = Colors.white; // White Text
  static const Color textSecondary = Color(0xFFB0B0B0); // Light Gray Text

  // App Bar and Icon Colors
  static const Color appBar =
      Color.fromRGBO(12, 12, 12, 1); // Darker shade for the app bar

  static const Color iconPrimary = Color(0xFF2196F3); // Electric Blue for icons
  static const Color iconSecondary =
      Color(0xFFB0B0B0); // Light Gray for secondary icons

  // Buttons and Floating Action Buttons (FAB)
  static const Color buttonBackground =
      Color(0xFF2196F3); // Electric Blue for FAB and buttons
  static const Color buttonText = Colors.white; // White text on buttons

  // Borders and Dividers
  static const Color divider = Color(0xFF333333); // Subtle Divider

  // Shadow Colors
  static const Color shadow =
      Color.fromRGBO(10, 10, 10, 1); // Deep shadow effect
  static const Color cyan = Color(0xFF00f5ff); // Cyan color
  static const Color chatBox = Color.fromRGBO(17, 17, 17, 1);
  static const Color accent = Color(0xFFF50057);
}
