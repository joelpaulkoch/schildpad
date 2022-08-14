import 'package:flutter/material.dart';

class DragDetector extends StatefulWidget {
  const DragDetector(
      {Key? key, required this.child, required this.onDragDetected})
      : super(key: key);

  final Widget child;
  final VoidCallback onDragDetected;

  @override
  State<DragDetector> createState() => _DragDetectorState();
}

class _DragDetectorState extends State<DragDetector> {
  bool dragDetected = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child,
      Positioned.fill(
        child: DragTarget(
            hitTestBehavior: HitTestBehavior.translucent,
            onWillAccept: (_) {
              if (!dragDetected) {
                widget.onDragDetected();
                setState(() {
                  dragDetected = true;
                });
              }
              return false;
            },
            onLeave: (_) {
              if (dragDetected) {
                setState(() {
                  dragDetected = false;
                });
              }
            },
            builder: (_, __, ___) {
              return const SizedBox.expand();
            }),
      ),
    ]);
  }
}
