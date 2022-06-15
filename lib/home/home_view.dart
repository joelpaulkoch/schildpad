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
          final primaryVelocity = details.primaryVelocity ?? 0;
          // on swipe up
          if (primaryVelocity < 0) {
            context.push('/apps');
          }
        },
        child: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
        ));
  }
}
