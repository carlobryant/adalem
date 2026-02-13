import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    inverseSurface: Colors.grey.shade800,
    shadow: Colors.grey.shade900,
    primary: Colors.green.shade400,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.green.shade800,
  ),
  brightness: Brightness.light,
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.grey.shade800,
    displayColor: Colors.black,
    ),
);