import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/flexible_grid/flexible_grid.dart';

void main() {
  group('generate default tiles', () {
    test('generating default tiles for an m x n grid should create m x n tiles',
        () {
      const m = 3;
      const n = 5;
      final tiles = generateDefaultGridTiles(m, n);
      expect(tiles.length, m * n);
    });
    test(
        'generating default tiles with a negative dimension should return an empty list',
        () {
      const m = -1;
      const n = 1;
      expect(generateDefaultGridTiles(m, n), isEmpty);
      expect(generateDefaultGridTiles(n, m), isEmpty);
    });
    test(
        'when generating default tiles with column start c all tiles should be placed in columns greater or equal than c',
        () {
      const c = 1;
      final tiles = generateDefaultGridTiles(2, 2, columnStart: c);
      expect(tiles.every((element) => element.column >= c), isTrue);
    });
    test(
        'when generating default tiles with row start r all tiles should be placed in rows greater or equal than r',
        () {
      const r = 1;
      final tiles = generateDefaultGridTiles(2, 2, rowStart: r);
      expect(tiles.every((element) => element.row >= r), isTrue);
    });
    test(
        'generating default tiles with negative column start or row start should return an empty list',
        () {
      const negativeNumber = -1;
      expect(
          generateDefaultGridTiles(2, 2, columnStart: negativeNumber), isEmpty);
      expect(generateDefaultGridTiles(2, 2, rowStart: negativeNumber), isEmpty);
    });
  });
  group('add tiles', () {
    test('after adding a tile the list should contain the tile', () {
      final List<FlexibleGridTile> tiles = [];
      const tile = FlexibleGridTile(column: 0, row: 0);
      final tilesAfterAdd = addTile(tiles, 1, 1, tile);
      expect(tilesAfterAdd, contains(tile));
    });
    test('adding a tile that is larger than the grid should not work', () {
      final List<FlexibleGridTile> tiles = [];

      const wideTile = FlexibleGridTile(column: 0, row: 0, columnSpan: 2);
      final tilesAfterAddWide = addTile(tiles, 1, 1, wideTile);
      expect(tilesAfterAddWide.contains(wideTile), isFalse);

      const tallTile = FlexibleGridTile(column: 0, row: 0, rowSpan: 2);
      final tilesAfterAddTall = addTile(tiles, 1, 1, tallTile);
      expect(tilesAfterAddTall.contains(tallTile), isFalse);
    });
    test('calling addTile with invalid dimensions should not change the list',
        () {
      final tiles = [const FlexibleGridTile(column: 0, row: 0)];
      expect(addTile(tiles, 2, -1, const FlexibleGridTile(column: 1, row: 0)),
          tiles);
      expect(addTile(tiles, 0, 2, const FlexibleGridTile(column: 0, row: 1)),
          tiles);
    });
    test(
        'adding a tile on a spot which is already occupied by a tile should not work',
        () {
      const firstTile = FlexibleGridTile(column: 0, row: 0);
      const secondTile = FlexibleGridTile(column: 0, row: 0);
      final tiles = [firstTile];
      final tilesAfterAdd = addTile(tiles, 1, 1, secondTile);

      expect(tilesAfterAdd, tiles);
    });
  });
  group('remove tiles', () {
    test('after removing a tile it should not be in the list anymore', () {
      final tiles = [const FlexibleGridTile(column: 0, row: 0)];
      final tilesAfterRemoving = removeTile(tiles, 0, 0);
      expect(tilesAfterRemoving, isEmpty);
    });
  });
}
