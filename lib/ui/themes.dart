import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color ringColor = Color.fromRGBO(212, 175, 55, 1);

ThemeData _getTheme(Brightness brightness) {
  final ThemeData baseTheme = ThemeData(brightness: brightness);
  return baseTheme.copyWith(
    colorScheme: baseTheme.colorScheme.copyWith(
      primary: Colors.green[brightness == Brightness.light ? 600 : 900],
      secondary: ringColor,
      onPrimary: Colors.white,
      onSurface:
          brightness == Brightness.light ? Colors.grey[900] : Colors.white,
    ),
    tabBarTheme: baseTheme.tabBarTheme.copyWith(
      indicatorColor: Colors.white,
    ),
    textTheme: GoogleFonts.exo2TextTheme(baseTheme.textTheme).apply(
      bodyColor:
          brightness == Brightness.light ? Colors.grey[900] : Colors.white,
      displayColor:
          brightness == Brightness.light ? Colors.grey[900] : Colors.white,
      decorationColor:
          brightness == Brightness.light ? Colors.grey[900] : Colors.white,
    ),
  );
}

final ThemeData darkTheme = _getTheme(Brightness.dark);

final ThemeData lightTheme = _getTheme(Brightness.light);
