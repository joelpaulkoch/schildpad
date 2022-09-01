import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/home/drag_detector.dart';

void main() {
  group('detect drags', () {
    testWidgets('drag detector should detect dragged item', (tester) async {
      // GIVEN: an area covered by the drag detector
      final completer = Completer<void>();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: DragDetector(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Container(
                      color: Colors.greenAccent,
                    ),
                  ),
                  onDragDetected: () => completer.complete(),
                  onDragEnd: () {},
                ),
              ),
              Expanded(
                  child: Center(
                child: Draggable(
                    data: 0,
                    feedback: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    )),
              ))
            ],
          ),
        ),
      ));

      // WHEN: something is dragged onto this area
      final draggablePos = tester.getCenter(find.byType(Draggable<int>));
      final dragDetectorPos = tester.getCenter(find.byType(DragDetector));
      final dragOffset = dragDetectorPos - draggablePos;
      await tester.dragFrom(draggablePos, dragOffset);
      await tester.pumpAndSettle();

      // THEN: the drag detector detects it
      expect(completer.isCompleted, isTrue);
    });
    testWidgets('drag detector should detect multiple dragged items',
        (tester) async {
      // GIVEN: an area covered by the drag detector
      final completer1 = Completer<void>();
      final completer2 = Completer<void>();
      final completers = [completer1, completer2];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: DragDetector(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Container(
                      color: Colors.greenAccent,
                    ),
                  ),
                  onDragDetected: () {
                    final firstUncompleted = completers
                        .firstWhere((completer) => !completer.isCompleted);
                    firstUncompleted.complete();
                  },
                  onDragEnd: () {},
                ),
              ),
              Expanded(
                  child: Center(
                child: Draggable(
                    data: 0,
                    feedback: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    )),
              ))
            ],
          ),
        ),
      ));

      // WHEN: something is dragged multiple times onto this area
      final draggablePos = tester.getCenter(find.byType(Draggable<int>));
      final dragDetectorPos = tester.getCenter(find.byType(DragDetector));
      final dragOffset = dragDetectorPos - draggablePos;
      await tester.dragFrom(draggablePos, dragOffset);
      await tester.pumpAndSettle();
      expect(completer1.isCompleted, isTrue);
      expect(completer2.isCompleted, isFalse);

      // THEN: the drag detector detects it each time
      await tester.dragFrom(draggablePos, dragOffset);
      await tester.pumpAndSettle();
      expect(completer2.isCompleted, isTrue);
    });
    testWidgets(
        'drag detector should detect dragged item when its child is a drag target',
        (tester) async {
      // GIVEN: a drag target covered by the drag detector
      final completer = Completer<void>();
      final dragTarget =
          DragTarget(builder: (_, __, ___) => const SizedBox.expand());
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: DragDetector(
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: dragTarget,
                    ),
                  ),
                  onDragDetected: () => completer.complete(),
                  onDragEnd: () {},
                ),
              ),
              Expanded(
                  child: Center(
                child: Draggable(
                    data: 0,
                    feedback: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    )),
              ))
            ],
          ),
        ),
      ));

      // WHEN: something is dragged onto the drag target
      final draggablePos = tester.getCenter(find.byType(Draggable<int>));
      final dragTargetPos = tester.getCenter(find.byWidget(dragTarget));
      final dragOffset = dragTargetPos - draggablePos;
      await tester.timedDragFrom(
          draggablePos, dragOffset, const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // THEN: the drag detector detects it
      expect(completer.isCompleted, isTrue);
    });
    testWidgets(
        'a drag target which is a child of the drag detector should be able to receive dragged data',
        (tester) async {
      // GIVEN: a drag target covered by the drag detector
      final dragDetectorCompleter = Completer<void>();
      final dragTargetCompleter = Completer<void>();
      final dragTarget = DragTarget(
        onAccept: (_) => dragTargetCompleter.complete(),
        builder: (_, __, ___) => const SizedBox.expand(),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: DragDetector(
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: dragTarget,
                    ),
                  ),
                  onDragDetected: () => dragDetectorCompleter.complete(),
                  onDragEnd: () {},
                ),
              ),
              Expanded(
                  child: Center(
                child: Draggable(
                    data: 0,
                    feedback: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    )),
              ))
            ],
          ),
        ),
      ));

      // WHEN: something is dragged onto the drag target
      final draggablePos = tester.getCenter(find.byType(Draggable<int>));
      final dragTargetPos = tester.getCenter(find.byWidget(dragTarget));
      final dragOffset = dragTargetPos - draggablePos;
      await tester.timedDragFrom(
          draggablePos, dragOffset, const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // THEN: the drag detector detects it and the drag target can accept it
      expect(dragDetectorCompleter.isCompleted, isTrue);
      expect(dragTargetCompleter.isCompleted, isTrue);
    });
    testWidgets(
        'when entering and leaving a drag target inside the drag detector with a dragged item the drag detector should detect it only once',
        (tester) async {
      // GIVEN: a drag target covered by the drag detector
      final firstCompleter = Completer<void>();
      final secondCompleter = Completer<void>();
      final completers = [firstCompleter, secondCompleter];
      final dragTarget = DragTarget(
        builder: (_, __, ___) => const SizedBox.expand(),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: DragDetector(
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: dragTarget,
                    ),
                  ),
                  onDragDetected: () {
                    final firstUncompleted = completers
                        .firstWhere((completer) => !completer.isCompleted);
                    firstUncompleted.complete();
                  },
                  onDragEnd: () {},
                ),
              ),
              Expanded(
                  child: Center(
                child: Draggable(
                    data: 0,
                    feedback: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    )),
              ))
            ],
          ),
        ),
      ));

      // WHEN: something is entering and leaving the drag target
      final draggablePos = tester.getCenter(find.byType(Draggable<int>));
      final dragTargetPos = tester.getCenter(find.byWidget(dragTarget));
      final dragOffset = dragTargetPos - draggablePos;
      await tester.timedDragFrom(draggablePos, dragOffset.scale(1.5, 1.5),
          const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // THEN: the drag detector detects it only once
      expect(firstCompleter.isCompleted, isTrue);
      expect(secondCompleter.isCompleted, isFalse);
    }, skip: true);
    testWidgets(
        'two drag targets positioned inside the drag detector should both be able to accept the same dragged item',
        (tester) async {
      // GIVEN: two drag targets covered by a drag detector
      final firstDragTargetCompleter = Completer<void>();
      final secondDragTargetCompleter = Completer<void>();
      final firstDragTarget = DragTarget(
        onWillAccept: (_) {
          firstDragTargetCompleter.complete();
          return false;
        },
        builder: (_, __, ___) => const SizedBox.expand(),
      );
      final secondDragTarget = DragTarget(
        onWillAccept: (_) {
          secondDragTargetCompleter.complete();
          return true;
        },
        builder: (_, __, ___) => const SizedBox.expand(),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: DragDetector(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: firstDragTarget,
                      ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: secondDragTarget,
                      ),
                    ],
                  ),
                  onDragDetected: () {},
                  onDragEnd: () {},
                ),
              ),
              Expanded(
                  child: Center(
                child: Draggable(
                    data: 0,
                    feedback: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: Container(
                        color: Colors.red,
                      ),
                    )),
              ))
            ],
          ),
        ),
      ));

      // WHEN: something is dragged onto the first drag target, which does not accept it, and then onto the second drag target
      final draggablePos = tester.getCenter(find.byType(Draggable<int>));
      final firstDragTargetPos =
          tester.getCenter(find.byWidget(firstDragTarget));
      final secondDragTargetPos =
          tester.getCenter(find.byWidget(secondDragTarget));
      final dragGesture = await tester.startGesture(draggablePos);
      await dragGesture.moveTo(firstDragTargetPos);
      await tester.pumpAndSettle();
      await dragGesture.moveTo(secondDragTargetPos);
      await tester.pumpAndSettle();

      // THEN: the drag detector detects it and both drag target could have accepted it
      // expect(dragDetectorCompleter.isCompleted, isTrue);
      expect(firstDragTargetCompleter.isCompleted, isTrue);
      expect(secondDragTargetCompleter.isCompleted, isTrue);
    });
  });
}
