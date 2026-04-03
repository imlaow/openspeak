import 'package:flutter/material.dart';

enum ThemePreset { dynamic, ocean, sunset, forest, graphite }

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemePreset _preset = ThemePreset.dynamic;

  ThemeMode get themeMode => _themeMode;
  ThemePreset get preset => _preset;

  bool get useDynamicColor => _preset == ThemePreset.dynamic;

  Color get seedColor {
    switch (_preset) {
      case ThemePreset.dynamic:
      case ThemePreset.ocean:
        return const Color(0xFF0A84FF);
      case ThemePreset.sunset:
        return const Color(0xFFFF6B3D);
      case ThemePreset.forest:
        return const Color(0xFF2E7D32);
      case ThemePreset.graphite:
        return const Color(0xFF455A64);
    }
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void setPreset(ThemePreset preset) {
    if (_preset == preset) return;
    _preset = preset;
    notifyListeners();
  }
}

final themeController = ThemeController();
