import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SchildpadTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(0xff, 0x34, 0xb5, 0x33)),
        useMaterial3: true);
  }

  static ThemeData get darkTheme {
    return SchildpadTheme.lightTheme.copyWith(brightness: Brightness.dark);
  }
}

const schildpadSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemStatusBarContrastEnforced: true,
  systemNavigationBarContrastEnforced: true,
  systemNavigationBarDividerColor: Colors.transparent,
);
