import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = AppTheme.lightTheme;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeData get getLightTheme => AppTheme.lightTheme;
  ThemeData get getDarkTheme => AppTheme.darkTheme;
  ThemeMode get themeMode => _themeMode;

  // Cambia el tema entre claro y oscuro
  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();  // Notifica a la UI para redibujar con el nuevo tema
  }
}
