import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme lightTextTheme = GoogleFonts.latoTextTheme(const TextTheme(
    headline1: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline2: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    headline3: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    headline4: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    headline5: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(224, 32, 32, 1),
    ),
    headline6: TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.bold,
    ),
  ));

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xfff42b03),
      colorScheme: const ColorScheme.light(primary: Color(0xfff42b03), secondary: Color(0xffe89005)),
      scaffoldBackgroundColor: const Color(0xfff8f8ff),
      textTheme: lightTextTheme,
    );
  }
}
