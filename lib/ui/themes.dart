import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color ringColor = Color.fromRGBO(212, 175, 55, 1);

ThemeData _getTheme(Brightness brightness) {
  final ThemeData baseTheme = ThemeData(brightness: brightness);
  return baseTheme.copyWith(
    colorScheme: baseTheme.colorScheme.copyWith(
      primary: Colors.green[brightness == Brightness.light ? 600 : 900],
      secondary: ringColor,
    ),
    textTheme: GoogleFonts.exo2TextTheme(baseTheme.textTheme),
  );
}

final ThemeData darkTheme = _getTheme(Brightness.dark);

final ThemeData lightTheme = _getTheme(Brightness.light);
