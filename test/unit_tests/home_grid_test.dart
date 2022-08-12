import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/flexible_grid.dart';
import 'package:schildpad/home/home.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter('schildpad/home_grid_test');
  });
  setUp(() async {
    await Hive.openBox<String>(getHiveBoxName(0));
  });
  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  group('add tiles', () {
    test('adding a 1x1 grid tile to a 1x1 grid should work', () {
      const gridTile = FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      );
      final homeGridNotifier = HomeGridStateNotifier(0, 1, 1);

      expect(homeGridNotifier.canAdd(gridTile), isTrue);

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
      final homeGridNotifier = HomeGridStateNotifier(0, 1, 1);

      expect(homeGridNotifier.canAdd(gridTile), isFalse);

      final stateBeforeAdd = homeGridNotifier.debugState;
      homeGridNotifier.addTile(gridTile);
      expect(homeGridNotifier.debugState, stateBeforeAdd);
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
      final homeGridNotifier = HomeGridStateNotifier(0, 2, 1);

      expect(homeGridNotifier.canAdd(firstHomeGridTile), isTrue);

      homeGridNotifier.addTile(firstHomeGridTile);
      expect(homeGridNotifier.debugState, contains(firstHomeGridTile));

      expect(homeGridNotifier.canAdd(secondHomeGridTile), isTrue);

      homeGridNotifier.addTile(secondHomeGridTile);
      expect(homeGridNotifier.debugState, contains(secondHomeGridTile));
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
      final homeGridNotifier = HomeGridStateNotifier(0, 2, 1);

      expect(homeGridNotifier.canAdd(firstHomeGridTile), isTrue);

      homeGridNotifier.addTile(firstHomeGridTile);
      expect(homeGridNotifier.debugState, contains(firstHomeGridTile));

      expect(homeGridNotifier.canAdd(secondHomeGridTile), isFalse);

      final stateBeforeAdd = homeGridNotifier.debugState;
      homeGridNotifier.addTile(secondHomeGridTile);
      expect(homeGridNotifier.debugState, stateBeforeAdd);
    });
    test(
        'adding a 1x1 FlexibleGridTile to a fully occupied grid should not work',
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
      final homeGridNotifier = HomeGridStateNotifier(0, 2, 1);

      expect(homeGridNotifier.canAdd(firstHomeGridTile), isTrue);

      homeGridNotifier.addTile(firstHomeGridTile);
      expect(homeGridNotifier.debugState, contains(firstHomeGridTile));

      expect(homeGridNotifier.canAdd(secondHomeGridTile), isFalse);

      final stateBeforeAdd = homeGridNotifier.debugState;
      homeGridNotifier.addTile(secondHomeGridTile);
      expect(homeGridNotifier.debugState, stateBeforeAdd);
    });
  });
}
