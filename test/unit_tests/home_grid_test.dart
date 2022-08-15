import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/home.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter('schildpad/home_grid_test');
  });
  setUp(() async {});
  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  group('add tiles', () {
    test('adding a 1x1 grid tile to a 1x1 grid should work', () {
      final homeGridNotifier = HomeGridStateNotifier(0, 1, 1);
      expect(
          homeGridNotifier.canAddElement(
              0, 0, ElementData(columnSpan: 1, rowSpan: 1)),
          isTrue);

      homeGridNotifier.addElement(0, 0, ElementData(columnSpan: 1, rowSpan: 1));
      final storedTile = homeGridNotifier.debugState.first;
      expect(storedTile.column, 0);
      expect(storedTile.row, 0);
      expect(storedTile.columnSpan, 1);
      expect(storedTile.rowSpan, 1);
    });
    test('adding a 2x1 FlexibleGridTile to a 1x1 grid should not work', () {
      final homeGridNotifier = HomeGridStateNotifier(0, 1, 1);

      expect(
          homeGridNotifier.canAddElement(
              0, 0, ElementData(columnSpan: 2, rowSpan: 1)),
          isFalse);

      final stateBeforeAdd = homeGridNotifier.debugState;
      homeGridNotifier.addElement(0, 0, ElementData(columnSpan: 2, rowSpan: 1));
      expect(homeGridNotifier.debugState, stateBeforeAdd);
    });
    test('adding two 1x1 HomeGridTiles to a 2x1 grid should work', () {
      final homeGridNotifier = HomeGridStateNotifier(0, 2, 1);

      expect(homeGridNotifier.debugState, isEmpty);
      expect(
          homeGridNotifier.canAddElement(
              0, 0, ElementData(columnSpan: 1, rowSpan: 1)),
          isTrue);

      homeGridNotifier.addElement(0, 0, ElementData(columnSpan: 1, rowSpan: 1));
      expect(homeGridNotifier.debugState.length, 1);

      expect(
          homeGridNotifier.canAddElement(
              1, 0, ElementData(columnSpan: 1, rowSpan: 1)),
          isTrue);

      homeGridNotifier.addElement(1, 0, ElementData(columnSpan: 1, rowSpan: 1));
      expect(homeGridNotifier.debugState.length, 2);
    });
    test(
        'adding two 1x1 HomeGridTiles at the same position to a 2x1 grid should not work',
        () {
      final homeGridNotifier = HomeGridStateNotifier(0, 2, 1);

      expect(
          homeGridNotifier.canAddElement(
              0, 0, ElementData(columnSpan: 1, rowSpan: 1)),
          isTrue);

      homeGridNotifier.addElement(0, 0, ElementData(columnSpan: 1, rowSpan: 1));
      expect(homeGridNotifier.debugState.length, 1);

      expect(
          homeGridNotifier.canAddElement(
              0, 0, ElementData(columnSpan: 1, rowSpan: 1)),
          isFalse);

      final stateBeforeAdd = homeGridNotifier.debugState;
      homeGridNotifier.addElement(0, 0, ElementData(columnSpan: 1, rowSpan: 1));
      expect(homeGridNotifier.debugState, stateBeforeAdd);
    });
    test(
        'adding a 1x1 FlexibleGridTile to a fully occupied grid should not work',
        () {
      final homeGridNotifier = HomeGridStateNotifier(0, 2, 1);

      expect(
          homeGridNotifier.canAddElement(
              0, 0, ElementData(columnSpan: 2, rowSpan: 1)),
          isTrue);

      homeGridNotifier.addElement(0, 0, ElementData(columnSpan: 2, rowSpan: 1));
      expect(homeGridNotifier.debugState.length, 1);

      expect(
          homeGridNotifier.canAddElement(
              1, 0, ElementData(columnSpan: 1, rowSpan: 1)),
          isFalse);

      final stateBeforeAdd = homeGridNotifier.debugState;
      homeGridNotifier.addElement(1, 0, ElementData(columnSpan: 1, rowSpan: 1));
      expect(homeGridNotifier.debugState, stateBeforeAdd);
    });
  });
}
