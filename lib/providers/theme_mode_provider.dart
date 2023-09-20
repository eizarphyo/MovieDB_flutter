import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  // If system theme mode is dark, assign true, else false
  bool _isDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  checkSystemTheme() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    debugPrint("IS DARK MODE >>>> $_isDarkMode");
    notifyListeners();
  }

  setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    if (mode == ThemeMode.dark) {
      _isDarkMode = true;
      notifyListeners();
    } else if (mode == ThemeMode.system) {
      checkSystemTheme();
    } else {
      _isDarkMode = false;
      notifyListeners();
    }
  }
}
