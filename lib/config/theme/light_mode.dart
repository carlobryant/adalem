import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    inverseSurface: Colors.grey.shade900,
    shadow: Colors.grey.shade900,
    primary: Colors.green.shade900,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.green.shade400,
    onPrimary: Colors.grey.shade300,
    error: Colors.red.shade300,
  ),
  brightness: Brightness.light,
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.grey.shade900,
    displayColor: Colors.black,
    ),
);