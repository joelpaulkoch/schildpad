import 'package:flutter/material.dart';

import 'launcher/home_view.dart';

void main() {
  runApp(const SchildpadApp());
}

class SchildpadApp extends StatelessWidget {
  const SchildpadApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true),
        home: const HomeView());
  }
}
