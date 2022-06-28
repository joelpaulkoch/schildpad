import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/flexible_grid/flexible_grid.dart';

void main() {
  test('adding a 1x1 grid tile to a 1x1 grid should work', () {
    const gridTile = FlexibleGridTile(
      column: 0,
      row: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final homeGridNotifier = FlexibleGridStateNotifier(1, 1);

    expect(
        homeGridNotifier.canAdd(gridTile.column, gridTile.row,
            gridTile.columnSpan, gridTile.rowSpan),
        isTrue);

    homeGridNotifier.addTile(gridTile);
    final storedTile = homeGridNotifier.debugState.first;
    expect(storedTile.column, gridTile.column);
    expect(storedTile.row, gridTile.row);
    expect(storedTile.columnSpan, gridTile.columnSpan);
    expect(storedTile.rowSpan, gridTile.rowSpan);
  });
  test('adding a 2x1 FlexibleGridTile to a 1x1 grid should not work', () {
    const gridTile = FlexibleGridTile(
      column: 0,
      row: 0,
      columnSpan: 2,
      rowSpan: 1,
    );
    final homeGridNotifier = FlexibleGridStateNotifier(1, 1);

    expect(
        homeGridNotifier.canAdd(gridTile.column, gridTile.row,
            gridTile.columnSpan, gridTile.rowSpan),
        isFalse);

    expect(homeGridNotifier.addTile(gridTile), isFalse);
  });
  test('adding two 1x1 HomeGridTiles to a 2x1 grid should work', () {
    const firstHomeGridTile = FlexibleGridTile(
      column: 0,
      row: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    const secondHomeGridTile = FlexibleGridTile(
      column: 1,
      row: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final homeGridNotifier = FlexibleGridStateNotifier(2, 1);

    expect(
        homeGridNotifier.canAdd(firstHomeGridTile.column, firstHomeGridTile.row,
            firstHomeGridTile.columnSpan, firstHomeGridTile.rowSpan),
        isTrue);

    expect(homeGridNotifier.addTile(firstHomeGridTile), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridTile.column,
            secondHomeGridTile.row,
            secondHomeGridTile.columnSpan,
            secondHomeGridTile.rowSpan),
        isTrue);

    expect(homeGridNotifier.addTile(secondHomeGridTile), isTrue);
  });
  test(
      'adding two 1x1 HomeGridTiles at the same position to a 2x1 grid should not work',
      () {
    const firstHomeGridTile = FlexibleGridTile(
      column: 0,
      row: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    const secondHomeGridTile = FlexibleGridTile(
      column: 0,
      row: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final homeGridNotifier = FlexibleGridStateNotifier(2, 1);

    expect(
        homeGridNotifier.canAdd(firstHomeGridTile.column, firstHomeGridTile.row,
            firstHomeGridTile.columnSpan, firstHomeGridTile.rowSpan),
        isTrue);

    expect(homeGridNotifier.addTile(firstHomeGridTile), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridTile.column,
            secondHomeGridTile.row,
            secondHomeGridTile.columnSpan,
            secondHomeGridTile.rowSpan),
        isFalse);

    expect(homeGridNotifier.addTile(secondHomeGridTile), isFalse);
  });
  test('adding a 1x1 FlexibleGridTile to a fully occupied grid should not work',
      () {
    const firstHomeGridTile = FlexibleGridTile(
      column: 0,
      row: 0,
      columnSpan: 2,
      rowSpan: 1,
    );
    const secondHomeGridTile = FlexibleGridTile(
      column: 1,
      row: 0,
      columnSpan: 1,
      rowSpan: 1,
    );
    final homeGridNotifier = FlexibleGridStateNotifier(2, 1);

    expect(
        homeGridNotifier.canAdd(firstHomeGridTile.column, firstHomeGridTile.row,
            firstHomeGridTile.columnSpan, firstHomeGridTile.rowSpan),
        isTrue);

    expect(homeGridNotifier.addTile(firstHomeGridTile), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridTile.column,
            secondHomeGridTile.row,
            secondHomeGridTile.columnSpan,
            secondHomeGridTile.rowSpan),
        isFalse);

    expect(homeGridNotifier.addTile(secondHomeGridTile), isFalse);
  });
  test('adding non overlapping HomeGridTiles to a 5x10 grid should work', () {
    const firstHomeGridTile = FlexibleGridTile(
      column: 1,
      row: 0,
      columnSpan: 2,
      rowSpan: 1,
    );
    const secondHomeGridTile = FlexibleGridTile(
      column: 4,
      row: 0,
      columnSpan: 1,
      rowSpan: 6,
    );
    const thirdHomeGridTile = FlexibleGridTile(
      column: 1,
      row: 5,
      columnSpan: 1,
      rowSpan: 3,
    );
    const fourthHomeGridTile = FlexibleGridTile(
      column: 2,
      row: 2,
      columnSpan: 1,
      rowSpan: 1,
    );

    final homeGridNotifier = FlexibleGridStateNotifier(5, 10);

    expect(
        homeGridNotifier.canAdd(firstHomeGridTile.column, firstHomeGridTile.row,
            firstHomeGridTile.columnSpan, firstHomeGridTile.rowSpan),
        isTrue);
    expect(homeGridNotifier.addTile(firstHomeGridTile), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridTile.column,
            secondHomeGridTile.row,
            secondHomeGridTile.columnSpan,
            secondHomeGridTile.rowSpan),
        isTrue);

    expect(homeGridNotifier.addTile(secondHomeGridTile), isTrue);

    expect(
        homeGridNotifier.canAdd(thirdHomeGridTile.column, thirdHomeGridTile.row,
            thirdHomeGridTile.columnSpan, thirdHomeGridTile.rowSpan),
        isTrue);
    expect(homeGridNotifier.addTile(thirdHomeGridTile), isTrue);

    expect(
        homeGridNotifier.canAdd(
            fourthHomeGridTile.column,
            fourthHomeGridTile.row,
            fourthHomeGridTile.columnSpan,
            fourthHomeGridTile.rowSpan),
        isTrue);
    expect(homeGridNotifier.addTile(fourthHomeGridTile), isTrue);
  });
  test('adding an overlapping element to a 5x10 grid should not work', () {
    const firstHomeGridTile = FlexibleGridTile(
      column: 1,
      row: 3,
      columnSpan: 2,
      rowSpan: 3,
    );
    const secondHomeGridTile = FlexibleGridTile(
      column: 2,
      row: 0,
      columnSpan: 1,
      rowSpan: 6,
    );

    final homeGridNotifier = FlexibleGridStateNotifier(5, 10);

    expect(
        homeGridNotifier.canAdd(firstHomeGridTile.column, firstHomeGridTile.row,
            firstHomeGridTile.columnSpan, firstHomeGridTile.rowSpan),
        isTrue);
    expect(homeGridNotifier.addTile(firstHomeGridTile), isTrue);

    expect(
        homeGridNotifier.canAdd(
            secondHomeGridTile.column,
            secondHomeGridTile.row,
            secondHomeGridTile.columnSpan,
            secondHomeGridTile.rowSpan),
        isFalse);
    expect(homeGridNotifier.addTile(secondHomeGridTile), isFalse);
  });
}
