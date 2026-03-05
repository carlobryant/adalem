import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

const String _globalFont = "GoogleSans";
Color _primary = Colors.green.shade900;
Color _inPrimary = Colors.green.shade400;
Color _onPrimary = Colors.grey.shade300;
Color _onSurface = Colors.grey.shade600;
Color _error = Color.fromARGB(255, 186, 84, 71);
Color _onError = Color.fromARGB(255, 75, 2, 2);

ThemeData get lightMode => ThemeData(
  fontFamily: _globalFont,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    inverseSurface: Colors.grey.shade900,
    onSurface: _onSurface,
    shadow: Colors.grey.shade900,
    primary: _primary,
    secondary: Colors.grey.shade400,
    inversePrimary: _inPrimary,
    onPrimary: _onPrimary,
    error: _error,
    onError: _onError,
  ),
  brightness: Brightness.light,
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: _globalFont,
    bodyColor: Colors.grey.shade900,
    displayColor: Colors.black,
    ),
);

ThemeData get darkMode => ThemeData(
  fontFamily: _globalFont,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    inverseSurface: Colors.grey.shade300,
    onSurface: _onSurface,
    shadow: Colors.grey.shade600,
    primary: _primary,
    secondary: Colors.grey.shade700,
    inversePrimary: _inPrimary,
    onPrimary: _onPrimary,
    error: _error,
    onError: _onError,
  ),
  brightness: Brightness.dark,
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: _globalFont,
    bodyColor: Colors.grey.shade300,
    displayColor: Colors.white,
    ),
);
  
class FontScale {
  static const String _fontSizeKey = "font_size_scale";
  static final _storage = GetStorage();

  static const Map<String, double> fontSizeScales = {
    'Small': 0.8,
    'Normal': 1.0,
    'Large': 1.2,
    'Extra Large': 1.4,
  };

  static double get currentFontScale => _storage.read(_fontSizeKey) ?? fontSizeScales['Extra Large']!;

  static Future<void> setFontScale(double scale) async {
    await _storage.write(_fontSizeKey, scale);
  }
}

