import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        context.go("/apps");
      },
      child: Stack(
        children: const [
          SizedBox.expand(child: ColoredBox(color: Colors.cyanAccent)),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(child: Text("this is home")))
        ],
      ),
    );
  }
}
