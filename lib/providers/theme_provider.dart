import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  ThemeData get lightTheme => ThemeData(
        primaryColor: Colors.blue[100],
        scaffoldBackgroundColor: Colors.blue[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[100],
          titleTextStyle:
              TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
        ),
        cardColor: Colors.blue[100],
        iconTheme: IconThemeData(color: Colors.blue[900]),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.blue[900]),
          bodyMedium: TextStyle(color: Colors.blue[900]),
        ),
      );

  ThemeData get darkTheme => ThemeData(
        primaryColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          titleTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        cardColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      );

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
