import 'package:flutter/material.dart';

final stadtnaviTheme = ThemeData(
  primaryColor: const Color(0xff9bbf28),
  accentColor: const Color(0xffec5188),
  backgroundColor: Colors.white,
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyText1: const TextStyle(color: Color(0xFF000000)),
        bodyText2: const TextStyle(color: Color(0xFF9EC528)),
        headline6: const TextStyle(color: Colors.white),
        subtitle1: const TextStyle(color: Colors.white),
      ),
  primaryTextTheme: ThemeData.light().primaryTextTheme.copyWith(
        headline6: const TextStyle(color: Colors.white),
        subtitle1: const TextStyle(color: Colors.white),
      ),
  primaryIconTheme: ThemeData.light().primaryIconTheme.copyWith(
        color: const Color(0xFFFDFDFE),
      ),
);
