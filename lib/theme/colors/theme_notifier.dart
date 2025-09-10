import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'package:grene/services/storage_service.dart';
import 'package:grene/theme/colors/app_colors.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get currentTheme =>
      _isDark ? AppTheme.darkTheme() : AppTheme.lightTheme();


  ThemeNotifier() {
    _loadTheme();
  }

  void toggleTheme() async {
    _isDark = !_isDark;
    await StorageService.saveTheme(_isDark);
    AppColors.load(_isDark); // 🔹 atualiza cores globais
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    _isDark = await StorageService.getTheme();
    AppColors.load(_isDark); // 🔹 inicializa cores corretas
    notifyListeners();
  }
}
