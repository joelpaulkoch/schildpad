import 'package:flutter/material.dart';

class SchildpadTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          color: Colors.white70,
          elevation: 0,
        ),
        primarySwatch: Colors.grey,
        useMaterial3: true);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          color: Colors.black87,
          elevation: 0,
        ),
        primarySwatch: Colors.grey,
        useMaterial3: true);
  }
}
