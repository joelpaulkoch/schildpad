import 'package:flutter/material.dart';

class SchildpadTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.cyan,
        useMaterial3: true);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
        useMaterial3: true);
  }
}
