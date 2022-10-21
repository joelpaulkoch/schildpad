import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FlexibleGridTile {
  const FlexibleGridTile(
      {Key? key,
      required this.column,
      required this.row,
      this.columnSpan = 1,
      this.rowSpan = 1,
      this.child})
      : assert(column >= 0),
        assert(row >= 0),
        assert(columnSpan >= 1),
        assert(rowSpan >= 1);

  final int column;
  final int row;
  final int columnSpan;
  final int rowSpan;
  final Widget? child;
}

class FlexibleGrid extends StatelessWidget {
  const FlexibleGrid(
      {Key? key,
      required this.columnCount,
      required this.rowCount,
      required this.gridTiles})
      : super(key: key);

  final int columnCount;
  final int rowCount;
  final List<FlexibleGridTile> gridTiles;

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
        delegate: _FlexibleGridLayoutDelegate(
            columns: columnCount, rows: rowCount, gridTiles: gridTiles),
        children: <Widget>[
          for (final FlexibleGridTile tile in gridTiles)
            LayoutId(
                id: _GridCell(tile.column, tile.row),
                child: tile.child ?? const SizedBox.shrink())
        ]);
  }
}

class _FlexibleGridLayoutDelegate extends MultiChildLayoutDelegate {
  _FlexibleGridLayoutDelegate(
      {required this.columns, required this.rows, required this.gridTiles});

  final int columns;
  final int rows;
  final List<FlexibleGridTile> gridTiles;

  @override
  void performLayout(Size size) {
    final double columnWidth = size.width / columns;
    final double rowHeight = size.height / rows;

    for (final FlexibleGridTile tile in gridTiles) {
      layoutChild(
          _GridCell(tile.column, tile.row),
          BoxConstraints(
              maxWidth: columnWidth * tile.columnSpan,
              maxHeight: rowHeight * tile.rowSpan));
      positionChild(_GridCell(tile.column, tile.row),
          Offset(columnWidth * tile.column, rowHeight * tile.row));
    }
  }

  @override
  bool shouldRelayout(_FlexibleGridLayoutDelegate oldDelegate) {
    return oldDelegate.columns != columns || oldDelegate.rows != rows;
  }
}

bool canAdd(List<FlexibleGridTile> tiles, int columnCount, int rowCount,
    int columnStart, int rowStart, int columnSpan, int rowSpan) {
  if (columnStart + columnSpan > columnCount || rowStart + rowSpan > rowCount) {
    return false;
  }

  for (var col = columnStart; col < columnStart + columnSpan; col++) {
    for (var row = rowStart; row < rowStart + rowSpan; row++) {
      if (tiles.any((tile) => isInsideTile(col, row, tile))) return false;
    }
  }
  return true;
}

bool isInsideTile(int column, int row, FlexibleGridTile tile) =>
    tile.column <= column &&
    column < tile.column + tile.columnSpan &&
    tile.row <= row &&
    row < tile.row + tile.rowSpan;

List<FlexibleGridTile> addTile(List<FlexibleGridTile> tiles, int columnCount,
    int rowCount, FlexibleGridTile tile) {
  if (canAdd(tiles, columnCount, rowCount, tile.column, tile.row,
      tile.columnSpan, tile.rowSpan)) {
    return [...tiles, tile];
  }
  return tiles;
}

List<FlexibleGridTile> removeTile(
    List<FlexibleGridTile> tiles, int columnStart, int rowStart) {
  tiles.removeWhere(
      (tile) => tile.column == columnStart && tile.row == rowStart);
  return tiles;
}

List<FlexibleGridTile> generateDefaultGridTiles(int columnSpan, int rowSpan,
    {int columnStart = 0, int rowStart = 0}) {
  if (columnSpan <= 0 || rowSpan <= 0 || columnStart < 0 || rowStart < 0) {
    return List.empty();
  }
  return List.generate(
      columnSpan,
      (colIndex) => List.generate(
          rowSpan,
          (rowIndex) => FlexibleGridTile(
                column: columnStart + colIndex,
                row: rowStart + rowIndex,
                columnSpan: 1,
                rowSpan: 1,
              ))).expand((element) => element).toList(growable: false);
}

class _GridCell extends Equatable {
  const _GridCell(this.col, this.row);

  final int col;
  final int row;

  @override
  List<Object> get props => [col, row];
}
