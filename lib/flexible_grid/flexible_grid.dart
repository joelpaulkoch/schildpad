import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlexibleGrid extends StatelessWidget {
  const FlexibleGrid(
      {Key? key,
      required this.columnCount,
      required this.rowCount,
      required this.gridTiles,
      required this.children})
      : super(key: key);

  final int columnCount;
  final int rowCount;
  final List<FlexibleGridTile> gridTiles;
  final List<FlexibleGridChild> children;

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
        delegate: _FlexibleGridLayoutDelegate(
            columns: columnCount, rows: rowCount, gridTiles: gridTiles),
        children: <Widget>[
          for (final FlexibleGridChild child in children)
            LayoutId(id: GridCell(child.column, child.row), child: child.child)
        ]);
  }
}

class FlexibleGridTile {
  const FlexibleGridTile({
    Key? key,
    required this.column,
    required this.row,
    this.columnSpan = 1,
    this.rowSpan = 1,
  });

  final int column;
  final int row;
  final int columnSpan;
  final int rowSpan;

  bool isInside(FlexibleGridTile other) {
    return other.column <= column &&
        column + columnSpan <= other.column + other.columnSpan &&
        other.row <= row &&
        row + rowSpan <= other.row + other.rowSpan;
  }
}

class FlexibleGridChild extends StatelessWidget {
  const FlexibleGridChild(
      {Key? key, required this.column, required this.row, required this.child})
      : super(key: key);

  final int column;
  final int row;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class FlexibleGridStateNotifier extends StateNotifier<List<FlexibleGridTile>> {
  FlexibleGridStateNotifier(this.columnCount, this.rowCount)
      : isOccupied = List.generate(
            columnCount, (_) => List.generate(rowCount, (_) => false)),
        super(_generateDefaultGridTiles(0, 0, columnCount, rowCount));

  final int columnCount;
  final int rowCount;
  final List<List<bool>> isOccupied;

  void _occupyCells(FlexibleGridTile tile) {
    for (var col = tile.column; col < tile.column + tile.columnSpan; col++) {
      for (var row = tile.row; row < tile.row + tile.rowSpan; row++) {
        isOccupied[col][row] = true;
      }
    }
  }

  void _freeCells(FlexibleGridTile tile) {
    for (var col = tile.column; col < tile.column + tile.columnSpan; col++) {
      for (var row = tile.row; row < tile.row + tile.rowSpan; row++) {
        isOccupied[col][row] = false;
      }
    }
  }

  bool addTile(FlexibleGridTile tile) {
    if (canAdd(tile.column, tile.row, tile.columnSpan, tile.rowSpan)) {
      _occupyCells(tile);
      final tilesToRemove = state.where((t) => t.isInside(tile)).toList();
      for (var t in tilesToRemove) {
        state.remove(t);
      }
      state = [...state, tile];
      return true;
    }
    return false;
  }

  void removeTile(int columnStart, int rowStart) {
    final tileToRemoveIterable = state
        .where((tile) => tile.column == columnStart && tile.row == rowStart);

    assert(tileToRemoveIterable.length == 1);

    if (tileToRemoveIterable.isNotEmpty) {
      final tileToRemove = tileToRemoveIterable.first;
      if (state.remove(tileToRemove)) {
        _freeCells(tileToRemove);
        state = [
          ...state,
          ..._generateDefaultGridTiles(columnStart, rowStart,
              tileToRemove.columnSpan, tileToRemove.rowSpan)
        ];
      }
    }
  }

  bool canAdd(int columnStart, int rowStart, int columnSpan, int rowSpan) {
    if (columnStart + columnSpan > columnCount ||
        rowStart + rowSpan > rowCount) {
      return false;
    }
    for (var col = columnStart; col < columnStart + columnSpan; col++) {
      for (var row = rowStart; row < rowStart + rowSpan; row++) {
        if (isOccupied[col][row]) return false;
      }
    }
    return true;
  }
}

List<FlexibleGridTile> _generateDefaultGridTiles(
    int columnStart, int rowStart, int columnSpan, int rowSpan) {
  return List.generate(
      columnSpan,
      (colIndex) => List.generate(
          rowSpan,
          (rowIndex) => FlexibleGridTile(
                column: columnStart + colIndex,
                row: rowStart + rowIndex,
                columnSpan: 1,
                rowSpan: 1,
              ))).expand((element) => element).toList();
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
          GridCell(tile.column, tile.row),
          BoxConstraints(
              maxWidth: columnWidth * tile.columnSpan,
              maxHeight: rowHeight * tile.rowSpan));
      positionChild(GridCell(tile.column, tile.row),
          Offset(columnWidth * tile.column, rowHeight * tile.row));
    }
  }

  @override
  bool shouldRelayout(_FlexibleGridLayoutDelegate oldDelegate) {
    return oldDelegate.columns != columns || oldDelegate.rows != rows;
  }
}

class GridCell extends Equatable {
  const GridCell(this.col, this.row);

  final int col;
  final int row;

  @override
  List<Object> get props => [col, row];
}
