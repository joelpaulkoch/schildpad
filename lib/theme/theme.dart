import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

const schildpadSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemStatusBarContrastEnforced: true,
  systemNavigationBarContrastEnforced: true,
  systemNavigationBarDividerColor: Colors.transparent,
);
