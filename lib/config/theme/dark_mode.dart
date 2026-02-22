import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    inverseSurface: Colors.grey.shade300,
    shadow: Colors.grey.shade600,
    primary: Colors.green.shade900,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.green.shade700,
    onPrimary: Colors.grey.shade300,
    error: Colors.red.shade900,
  ),
  brightness: Brightness.dark,
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.grey.shade300,
    displayColor: Colors.white,
    ),
);