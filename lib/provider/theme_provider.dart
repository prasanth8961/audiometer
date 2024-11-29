import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/color.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> loadTheme() async {
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

  ThemeData get lightTheme => ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kTransperentColor,
        colorScheme: const ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          surface: kTertiaryColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: kTextColor),
          bodyMedium: TextStyle(color: kTextColor),
        ),
      );

  ThemeData get darkTheme => ThemeData(
        primaryColor: kPrimaryDarkColor,
        scaffoldBackgroundColor: kSecondaryDarkColor,
        colorScheme: const ColorScheme.dark(
          primary: kPrimaryDarkColor,
          secondary: kSecondaryDarkColor,
          surface: kTertiaryDarkColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: kTextDarkColor),
          bodyMedium: TextStyle(color: kTextDarkColor),
        ),
      );

  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;
}
