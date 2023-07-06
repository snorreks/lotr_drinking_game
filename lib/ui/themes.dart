import 'package:flutter/material.dart';

final Color ringColor = const Color.fromRGBO(212, 175, 55, 1);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.green[600]!,
    secondary: ringColor, // Ring color
    onSurface: Colors.brown[800]!,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green[600],
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: ringColor, // FAB color
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.green[900]!, // Darker shade of green for primary color
    secondary: ringColor, // Ring color
    surface: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green[900], // Darker shade of green for AppBar
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: ringColor, // FAB color
  ),
);
