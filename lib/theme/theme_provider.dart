import 'package:flutter/material.dart';
import 'package:weather_app/theme/Dark.dart';
import 'package:weather_app/theme/Light.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData themeData = darkMode;
  ThemeData get getThemeData => themeData;
  bool get isDark => (themeData == darkMode);
  set setThemeData(ThemeData themeData_) {
    this.themeData = themeData_;
    notifyListeners();
  }

  void toggleTheme() {
    if (themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
    notifyListeners();
  }
}
