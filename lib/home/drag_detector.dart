import 'package:flutter/material.dart';

class DragDetector extends StatelessWidget {
  const DragDetector(
      {Key? key,
      required this.child,
      required this.onDragDetected,
      required this.onDragEnd})
      : super(key: key);

  final Widget child;
  final VoidCallback onDragDetected;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
        hitTestBehavior: HitTestBehavior.translucent,
        onWillAccept: (_) {
          onDragDetected();
          return false;
        },
        onLeave: (_) {},
        builder: (_, __, ___) {
          return child;
        });
  }
}
