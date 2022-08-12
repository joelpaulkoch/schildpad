import 'package:flutter/material.dart';

class DragDetector extends StatelessWidget {
  const DragDetector(
      {Key? key, required this.child, required this.onDragDetected})
      : super(key: key);

  final Widget child;
  final VoidCallback onDragDetected;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      // DragTarget(
      //     hitTestBehavior: HitTestBehavior.translucent,
      //     onWillAccept: (_) {
      //       onDragDetected();
      //       return false;
      //     },
      //     builder: (_, __, ___) => const SizedBox.expand())
    ]);
  }
}
