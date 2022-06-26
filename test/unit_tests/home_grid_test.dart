import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/home/home_grid.dart';

void main() {
  test('adding a 1x1 GridPlacement to a 1x1 grid should work', () {
    final gridPlacement = HomeGridPlacement(
      columnStart: 0,
      rowStart: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final homeGridNotifier = HomeGridStateNotifier(1, 1);

    expect(
        homeGridNotifier.canAdd(
            gridPlacement.columnStart!,
            gridPlacement.rowStart!,
            gridPlacement.columnSpan,
            gridPlacement.rowSpan),
        isTrue);

    homeGridNotifier.addPlacement(gridPlacement);
    final storedPlacement = homeGridNotifier.debugState.first;
    expect(storedPlacement.columnStart, gridPlacement.columnStart);
    expect(storedPlacement.rowStart, gridPlacement.rowStart);
    expect(storedPlacement.columnSpan, gridPlacement.columnSpan);
    expect(storedPlacement.rowSpan, gridPlacement.rowSpan);
  });
  test('adding a 2x1 HomeGridPlacement to a 1x1 grid should not work', () {
    final gridPlacement = HomeGridPlacement(
      columnStart: 0,
      rowStart: 0,
      columnSpan: 2,
      rowSpan: 1,
    );
    final homeGridNotifier = HomeGridStateNotifier(1, 1);

    expect(
        homeGridNotifier.canAdd(
            gridPlacement.columnStart!,
            gridPlacement.rowStart!,
            gridPlacement.columnSpan,
            gridPlacement.rowSpan),
        isFalse);

    expect(homeGridNotifier.addPlacement(gridPlacement), isFalse);
  });
  test('addding two 1x1 HomeGridPlacements to a 2x1 grid should work', () {
    final firstHomeGridPlacement = HomeGridPlacement(
      columnStart: 0,
      rowStart: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final secondHomeGridPlacement = HomeGridPlacement(
      columnStart: 1,
      rowStart: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final homeGridNotifier = HomeGridStateNotifier(2, 1);

    expect(
        homeGridNotifier.canAdd(
            firstHomeGridPlacement.columnStart!,
            firstHomeGridPlacement.rowStart!,
            firstHomeGridPlacement.columnSpan,
            firstHomeGridPlacement.rowSpan),
        isTrue);

    expect(homeGridNotifier.addPlacement(firstHomeGridPlacement), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridPlacement.columnStart!,
            secondHomeGridPlacement.rowStart!,
            secondHomeGridPlacement.columnSpan,
            secondHomeGridPlacement.rowSpan),
        isTrue);

    expect(homeGridNotifier.addPlacement(secondHomeGridPlacement), isTrue);
  });
  test(
      'addding two 1x1 HomeGridPlacements at the same position to a 2x1 grid should not work',
      () {
    final firstHomeGridPlacement = HomeGridPlacement(
      columnStart: 0,
      rowStart: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final secondHomeGridPlacement = HomeGridPlacement(
      columnStart: 0,
      rowStart: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final homeGridNotifier = HomeGridStateNotifier(2, 1);

    expect(
        homeGridNotifier.canAdd(
            firstHomeGridPlacement.columnStart!,
            firstHomeGridPlacement.rowStart!,
            firstHomeGridPlacement.columnSpan,
            firstHomeGridPlacement.rowSpan),
        isTrue);

    expect(homeGridNotifier.addPlacement(firstHomeGridPlacement), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridPlacement.columnStart!,
            secondHomeGridPlacement.rowStart!,
            secondHomeGridPlacement.columnSpan,
            secondHomeGridPlacement.rowSpan),
        isFalse);

    expect(homeGridNotifier.addPlacement(secondHomeGridPlacement), isFalse);
  });
  test(
      'adding a 1x1 HomeGridPlacement to a fully occupied grid should not work',
      () {
    final firstHomeGridPlacement = HomeGridPlacement(
      columnStart: 0,
      rowStart: 0,
      columnSpan: 2,
      rowSpan: 1,
    );
    final secondHomeGridPlacement = HomeGridPlacement(
      columnStart: 1,
      rowStart: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final homeGridNotifier = HomeGridStateNotifier(2, 1);

    expect(
        homeGridNotifier.canAdd(
            firstHomeGridPlacement.columnStart!,
            firstHomeGridPlacement.rowStart!,
            firstHomeGridPlacement.columnSpan,
            firstHomeGridPlacement.rowSpan),
        isTrue);

    expect(homeGridNotifier.addPlacement(firstHomeGridPlacement), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridPlacement.columnStart!,
            secondHomeGridPlacement.rowStart!,
            secondHomeGridPlacement.columnSpan,
            secondHomeGridPlacement.rowSpan),
        isFalse);

    expect(homeGridNotifier.addPlacement(secondHomeGridPlacement), isFalse);
  });
  test('adding non overlapping HomeGridPlacements to a 5x10 grid should work',
      () {
    final firstHomeGridPlacement = HomeGridPlacement(
      columnStart: 1,
      rowStart: 0,
      columnSpan: 2,
      rowSpan: 1,
    );
    final secondHomeGridPlacement = HomeGridPlacement(
      columnStart: 4,
      rowStart: 0,
      columnSpan: 1,
      rowSpan: 6,
    );
    final thirdHomeGridPlacement = HomeGridPlacement(
      columnStart: 1,
      rowStart: 5,
      columnSpan: 1,
      rowSpan: 3,
    );
    final fourthHomeGridPlacement = HomeGridPlacement(
      columnStart: 2,
      rowStart: 2,
      columnSpan: 1,
      rowSpan: 1,
    );

    final homeGridNotifier = HomeGridStateNotifier(5, 10);

    expect(
        homeGridNotifier.canAdd(
            firstHomeGridPlacement.columnStart!,
            firstHomeGridPlacement.rowStart!,
            firstHomeGridPlacement.columnSpan,
            firstHomeGridPlacement.rowSpan),
        isTrue);
    expect(homeGridNotifier.addPlacement(firstHomeGridPlacement), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridPlacement.columnStart!,
            secondHomeGridPlacement.rowStart!,
            secondHomeGridPlacement.columnSpan,
            secondHomeGridPlacement.rowSpan),
        isTrue);

    expect(homeGridNotifier.addPlacement(secondHomeGridPlacement), isTrue);

    expect(
        homeGridNotifier.canAdd(
            thirdHomeGridPlacement.columnStart!,
            thirdHomeGridPlacement.rowStart!,
            thirdHomeGridPlacement.columnSpan,
            thirdHomeGridPlacement.rowSpan),
        isTrue);
    expect(homeGridNotifier.addPlacement(thirdHomeGridPlacement), isTrue);

    expect(
        homeGridNotifier.canAdd(
            fourthHomeGridPlacement.columnStart!,
            fourthHomeGridPlacement.rowStart!,
            fourthHomeGridPlacement.columnSpan,
            fourthHomeGridPlacement.rowSpan),
        isTrue);
    expect(homeGridNotifier.addPlacement(fourthHomeGridPlacement), isTrue);
  });
  test('adding an overlapping element to a 5x10 grid should not work', () {
    final firstHomeGridPlacement = HomeGridPlacement(
      columnStart: 1,
      rowStart: 3,
      columnSpan: 2,
      rowSpan: 3,
    );
    final secondHomeGridPlacement = HomeGridPlacement(
      columnStart: 2,
      rowStart: 0,
      columnSpan: 1,
      rowSpan: 6,
    );

    final homeGridNotifier = HomeGridStateNotifier(5, 10);

    expect(
        homeGridNotifier.canAdd(
            firstHomeGridPlacement.columnStart!,
            firstHomeGridPlacement.rowStart!,
            firstHomeGridPlacement.columnSpan,
            firstHomeGridPlacement.rowSpan),
        isTrue);
    expect(homeGridNotifier.addPlacement(firstHomeGridPlacement), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridPlacement.columnStart!,
            secondHomeGridPlacement.rowStart!,
            secondHomeGridPlacement.columnSpan,
            secondHomeGridPlacement.rowSpan),
        isFalse);
    expect(homeGridNotifier.addPlacement(secondHomeGridPlacement), isFalse);
  });
}
