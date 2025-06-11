import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = AppTheme.lightTheme;
  bool _isDarkMode = false;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  ThemeProvider._();

  static Future<ThemeProvider> create() async {
    final provider = ThemeProvider._();
    await provider._loadTheme();
    return provider;
  }


  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    notifyListeners();
    await _saveTheme();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('isDarkMode');
    if (saved != null) {
      _isDarkMode = saved;
      _currentTheme = _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
    _isInitialized = true;
    notifyListeners();
  }
}

