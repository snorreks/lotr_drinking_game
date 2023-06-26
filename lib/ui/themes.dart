import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.light,
  primaryColor: Colors.lightBlue[800],
  // Define the default font family.
  fontFamily: 'Georgia',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
    bodyMedium:
        TextStyle(fontSize: 14, fontFamily: 'Hind', color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],

  // Define the default font family.
  fontFamily: 'Georgia',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
    bodyMedium:
        TextStyle(fontSize: 14, fontFamily: 'Hind', color: Colors.white),
  ),
);

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
