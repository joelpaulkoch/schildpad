import 'package:flutter/material.dart';

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
        home: Stack(
          children: const [
            SizedBox.expand(child: ColoredBox(color: Colors.cyanAccent)),
            Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(child: Text("this is home")))
          ],
        ));
  }
}
