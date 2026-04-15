import 'package:flutter/material.dart';

const String _globalFont = "GoogleSans";
//final Color _primary = Colors.green.shade900;
final Color _primary = const Color.fromARGB(255, 34, 92, 54);
final Color _inPrimary = Colors.green.shade400;
final Color _conPrimary = const Color.fromARGB(255, 28, 60, 31);
final Color _onPrimary = Colors.grey.shade300;
final Color _tertiary = Color(0xFFBA8E23);
final Color _onTertiary = Color.fromARGB(255, 243, 174, 2);
final Color _onSurface = Colors.grey.shade600;
final Color _conSurface = Colors.grey.shade800;
final Color _error = const Color.fromARGB(255, 186, 84, 71);
final Color _onError = const Color.fromARGB(255, 75, 2, 2);

ThemeData get lightMode => ThemeData(
  fontFamily: _globalFont,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    inverseSurface: Colors.grey.shade900,
    onSurface: _onSurface,
    surfaceContainer: _conSurface,
    shadow: Colors.grey.shade900,
    primary: _primary,
    secondary: Colors.grey.shade400,
    inversePrimary: _inPrimary,
    onPrimary: _onPrimary,
    primaryContainer: _conPrimary,
    tertiary: _tertiary,
    onTertiary: _onTertiary,
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
    surfaceContainer: _conSurface,
    shadow: Colors.grey.shade600,
    primary: _primary,
    secondary: Colors.grey.shade700,
    inversePrimary: _inPrimary,
    onPrimary: _onPrimary,
    primaryContainer: _conPrimary,
    tertiary: _tertiary,
    onTertiary: _onTertiary,
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

enum NotebookTheme {
  red(primary: Color(0xFFbb8997), secondary: Color(0xFF9a1a87)),
  orange(primary: Color(0xFFbf9588), secondary: Color(0xFF960e00)),
  yellow(primary: Color(0xFFcaae7c), secondary: Color(0xFFc58002)),
  green(primary: Color(0xFFa4ba73), secondary: Color(0xFF998b16)),
  blue(primary: Color(0xFF7597be), secondary: Color(0xFF147b41)),
  purple(primary: Color(0xFF8d88bf), secondary: Color(0xFF1358a5)),
  pink(primary: Color(0xFFaf7eb2), secondary: Color(0xFF860fa8)),
  grey(primary: Color(0xFFa4a4a4), secondary: Color(0xFF757575));

  final Color primary;
  final Color secondary;

  const NotebookTheme({
    required this.primary,
    required this.secondary,
  });
}

class Recolor{
  static Color darken(Color color, [double amount = 0.4]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
