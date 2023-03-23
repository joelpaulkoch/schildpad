import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SchildpadTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: const Color.fromARGB(0xff, 0x34, 0xb5, 0x33)),
        useMaterial3: true);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const Color.fromARGB(0xff, 0x34, 0xb5, 0x33)),
        useMaterial3: true);
  }
}

const schildpadSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemStatusBarContrastEnforced: true,
  systemNavigationBarContrastEnforced: true,
  systemNavigationBarDividerColor: Colors.transparent,
);
