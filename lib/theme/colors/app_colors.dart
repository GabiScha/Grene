import 'package:flutter/material.dart';

class AppColors {
  static late Color background;
  static late Color primary;
  static late Color text;
  static late Color accent;

  static const Color potColor = Color.fromARGB(255, 83, 60, 49);
  static const Color backGreen = Color.fromRGBO(104, 177, 130, 1);
  static const Color backLightGreen = Color.fromRGBO(163, 219, 188, 1);

  static void load(bool isDark) {
    if (isDark) {
      background = const Color(0xFF121212);
      primary = const Color(0xFF4CAF50);
      text = const Color(0xFFEAEAEA);
      accent = const Color(0xFF81C784);
    } else {
      background = const Color(0xFFF5F5DC);
      primary = const Color(0xFF6BCF9E);
      text = const Color(0xFF333333);
      accent = const Color(0xFF4CAF50);
    }
  }
}
