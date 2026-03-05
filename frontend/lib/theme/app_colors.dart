import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Earthy & Sage
  static const Color darkBg = Color(0xFF0F1410); // Very dark green-black
  static const Color darkBgSecondary = Color(0xFF1B241C);
  static const Color sageGreen = Color(0xFF4A6741);
  static const Color sageLight = Color(0xFF8BA882);
  static const Color earthBrown = Color(0xFF3E2723);
  static const Color cream = Color(0xFFF5F1E8);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldAccentDark = Color(0xFFC19B1F);

  // UI Accents
  static const Color textLight = Color(0xFFE8E6E1);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color dividerColor = Color.fromARGB(26, 255, 255, 255);

  // Glassmorphism
  static const Color glassWhite = Color.fromARGB(20, 255, 255, 255);
  static const Color glassLight =
      Color.fromARGB(20, 255, 255, 255); // alias for glassWhite
  static const Color glassBorder = Color.fromARGB(40, 255, 255, 255);
  static const Color glassHover = Color.fromARGB(60, 255, 255, 255);

  static const LinearGradient luxuryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [sageGreen, Color(0xFF2E412A)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldAccent, goldAccentDark],
  );
}
