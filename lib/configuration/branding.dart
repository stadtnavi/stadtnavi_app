import 'package:flutter/material.dart';

final brandingStadtnavi = ThemeData.from(
  useMaterial3: false,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: const MaterialColor(
      0xfffecc01,
      <int, Color>{
        50: Color(0xfffff8e0),
        100: Color(0xffffedb0),
        200: Color(0xfffee17c),
        300: Color(0xfffed643),
        400: Color(0xfffecb01),
        500: Color(0xffffc200),
        600: Color(0xffffb400),
        700: Color(0xffffa000),
        800: Color(0xffff8e00),
        900: Color(0xffff6d00),
      },
    ),
    accentColor: const Color(0xfffecc01),
    cardColor: Colors.white,
    backgroundColor: Colors.grey[50],
    errorColor: Colors.red,
  ),
).copyWith(
  scaffoldBackgroundColor: Colors.grey[200],
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xfffecc01),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);

final brandingStadtnaviDark = ThemeData.from(
  useMaterial3: false,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: const MaterialColor(
      0xff263238,
      <int, Color>{
        50: Color(0xffeceff1),
        100: Color(0xffcfd8dc),
        200: Color(0xffb0bec5),
        300: Color(0xff90a4ae),
        400: Color(0xff78909c),
        500: Color(0xff607d8b),
        600: Color(0xff546e7a),
        700: Color(0xff455a64),
        800: Color(0xff37474f),
        900: Color(0xff263238),
      },
    ),
    accentColor: const Color(0xffff6d00),
    cardColor: const Color(0xff182025),
    brightness: Brightness.dark,
  ),
).copyWith(
  scaffoldBackgroundColor: Colors.grey[800],
  dialogBackgroundColor: const Color(0xff141515),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xff263238),
    foregroundColor: Colors.white,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xff141515),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff161919),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xffff6d00),
  ),
);
