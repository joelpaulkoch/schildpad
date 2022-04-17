import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        SizedBox.expand(child: ColoredBox(color: Colors.cyanAccent)),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: Text("this is home")))
      ],
    );
  }
}
