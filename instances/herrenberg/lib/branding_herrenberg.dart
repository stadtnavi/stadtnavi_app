import 'package:flutter/material.dart';

final brandingStadtnaviHerrenberg = ThemeData.from(
  useMaterial3: false,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: const MaterialColor(
      0xff9BBF28,
      <int, Color>{
        50: Color(0xfff4f7e6),
        100: Color(0xffe2ebc1),
        200: Color(0xffcfde99),
        300: Color(0xffbbd26f),
        400: Color(0xffabc84d),
        500: Color(0xff9cbf28),
        600: Color(0xff8baf20),
        700: Color(0xff769c14),
        800: Color(0xff618808),
        900: Color(0xff3b6700),
      },
    ),
    accentColor: const Color(0xff9BBF28),
    cardColor: Colors.white,
    backgroundColor: Colors.grey[50],
    errorColor: Colors.red,
  ),
).copyWith(
  scaffoldBackgroundColor: Colors.grey[200],
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff9BBF28),
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);
