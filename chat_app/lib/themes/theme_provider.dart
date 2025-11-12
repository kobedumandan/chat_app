import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = Lightmode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == Darkmode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == Lightmode) {
      themeData = Darkmode;
    } else {
      themeData = Lightmode;
    }
  }
}