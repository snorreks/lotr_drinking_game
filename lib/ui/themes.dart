import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color ringColor = Color.fromRGBO(212, 175, 55, 1);

/// google_fonts 9.x is built on top of `material_ui` and its `TextTheme`
/// is not the same type as the one exported by `package:flutter/material.dart`.
/// Build the `TextTheme` style by style instead, since `TextStyle` itself is
/// defined in `package:flutter/painting.dart` and is shared by both.
TextTheme _exo2TextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: GoogleFonts.exo2(textStyle: base.displayLarge),
    displayMedium: GoogleFonts.exo2(textStyle: base.displayMedium),
    displaySmall: GoogleFonts.exo2(textStyle: base.displaySmall),
    headlineLarge: GoogleFonts.exo2(textStyle: base.headlineLarge),
    headlineMedium: GoogleFonts.exo2(textStyle: base.headlineMedium),
    headlineSmall: GoogleFonts.exo2(textStyle: base.headlineSmall),
    titleLarge: GoogleFonts.exo2(textStyle: base.titleLarge),
    titleMedium: GoogleFonts.exo2(textStyle: base.titleMedium),
    titleSmall: GoogleFonts.exo2(textStyle: base.titleSmall),
    bodyLarge: GoogleFonts.exo2(textStyle: base.bodyLarge),
    bodyMedium: GoogleFonts.exo2(textStyle: base.bodyMedium),
    bodySmall: GoogleFonts.exo2(textStyle: base.bodySmall),
    labelLarge: GoogleFonts.exo2(textStyle: base.labelLarge),
    labelMedium: GoogleFonts.exo2(textStyle: base.labelMedium),
    labelSmall: GoogleFonts.exo2(textStyle: base.labelSmall),
  );
}

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
    textTheme: _exo2TextTheme(baseTheme.textTheme).apply(
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
