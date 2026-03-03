import 'package:flutter/material.dart';

class AppColors {
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color darkBgSecondary = Color(0xFF1A1F3A);
  static const Color darkBgTertiary = Color(0xFF0F1428);
  static const Color glassLight = Color.fromARGB(26, 255, 255, 255);
  static const Color glassBorder = Color.fromARGB(51, 255, 255, 255);
  static const Color glassHover = Color.fromARGB(38, 255, 255, 255);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldAccentDark = Color(0xFFC19B1F);
  static const Color sageGreen = Color(0xFF4A6741);
  static const Color cream = Color(0xFFF5F1E8);
  static const Color textLight = Color(0xFFE8E6E1);
  static const Color textMuted = Color(0xFFB0AEA8);

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldAccent, goldAccentDark],
  );
}
