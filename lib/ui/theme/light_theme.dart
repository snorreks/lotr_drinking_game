import 'package:flutter/material.dart';

const Color primaryColor = Color(0xff500E46);
const Color primaryAccentColor = Color(0xffF7E6EF);

const Color errorColor = Color(0xffEA3A3A);
const Color disabledColor = Color(0xffEDEDED);

const Color accentColor = Color(0xff78939B);
const Color secondaryAccentColor = Color(0xffEA5F3A);

const Color secondaryColor = Color(0xff923C66);

const Color backgroundColor = Color(0xfffafafa);

const Color lightColor = Color(0xffF3F3F3);

const Color secondaryButtonColor = Color(0xffFFFFFF);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Vaud',
  indicatorColor: primaryColor,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.black87,
  ),
  dividerColor: const Color(0x50000000),
  buttonTheme: const ButtonThemeData(
    buttonColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryButtonColor,
    ),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(color: Colors.black87),
    headline2: TextStyle(color: Colors.black87),
    headline3: TextStyle(color: Colors.black87),
    headline4: TextStyle(color: Colors.black87),
    headline5: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    headline6: TextStyle(color: Colors.black87),
    subtitle1: TextStyle(color: Colors.black87, fontSize: 18),
    subtitle2: TextStyle(color: Colors.black87),
    bodyText1: TextStyle(color: Colors.black87, fontSize: 18),
    bodyText2: TextStyle(color: Colors.black87, fontSize: 16),
    caption: TextStyle(color: Colors.black87),
    button: TextStyle(
      color: Colors.black87,
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    ),
    overline: TextStyle(color: Colors.black87),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
  ),
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryButtonColor,
  ),
  appBarTheme: const AppBarTheme(
    color: backgroundColor,
    toolbarTextStyle: TextStyle(color: Colors.black87),
    titleTextStyle: TextStyle(color: Colors.black87),
    iconTheme: IconThemeData(color: accentColor),
    actionsIconTheme: IconThemeData(color: accentColor),
  ),
  scaffoldBackgroundColor: backgroundColor,
  iconTheme: const IconThemeData(color: accentColor),
);
