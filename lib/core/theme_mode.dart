import 'package:flutter/material.dart';

const String _globalFont = "GoogleSans";
Color _primary = Colors.green.shade900;
Color _inPrimary = Colors.green.shade400;
Color _onPrimary = Colors.grey.shade300;
Color _onSurface = Colors.grey.shade600;
Color _error = Color.fromARGB(255, 186, 84, 71);

ThemeData lightMode = ThemeData(
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
  ),
  brightness: Brightness.light,
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: _globalFont,
    bodyColor: Colors.grey.shade900,
    displayColor: Colors.black,
    ),
);

ThemeData darkMode = ThemeData(
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
  ),
  brightness: Brightness.dark,
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: _globalFont,
    bodyColor: Colors.grey.shade300,
    displayColor: Colors.white,
    ),
);