import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/flexible_grid.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/model/home_tile.dart';

final dockColumnCountProvider = Provider<int>((ref) {
  return 4;
});
final dockRowCountProvider = Provider<int>((ref) {
  return 1;
});

final dockGridTilesProvider = Provider<List<FlexibleGridTile>>((ref) {
  ref.watch(isarUpdateProvider);
  final tiles = ref.watch(homeIsarProvider).whenOrNull(data: (tiles) => tiles);

  final gridTiles = tiles
      ?.filter()
      .coordinates((c) => c.locationEqualTo(Location.dock))
      .findAllSync();
  final flexibleGridTiles = gridTiles?.map((e) => FlexibleGridTile(
      column: e.coordinates?.column ?? 0,
      row: e.coordinates?.row ?? 0,
      columnSpan: e.columnSpan!,
      rowSpan: e.rowSpan!,
      child: DockGridCell(
        pageIndex: null,
        column: e.coordinates?.column ?? 0,
        row: e.coordinates?.row ?? 0,
      )));
  return flexibleGridTiles?.toList() ?? List.empty();
});

class DockGrid extends ConsumerWidget {
  const DockGrid(
    this.columnCount,
    this.rowCount, {
    Key? key,
  }) : super(key: key);

  final int columnCount;
  final int rowCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dev.log('rebuilding Dock');
    final dockGridTiles = ref.watch(dockGridTilesProvider);
    final defaultTiles = [];
    for (var col = 0; col < columnCount; col++) {
      for (var row = 0; row < rowCount; row++) {
        if (!dockGridTiles.any((tile) => isInsideTile(col, row, tile))) {
          defaultTiles.add(FlexibleGridTile(
              column: col,
              row: row,
              child: DockGridCell(pageIndex: null, column: col, row: row)));
        }
      }
    }

    return FlexibleGrid(
        columnCount: columnCount,
        rowCount: rowCount,
        gridTiles: [...dockGridTiles, ...defaultTiles]);
  }
}

class DockGridCell extends ConsumerWidget {
  const DockGridCell({
    required this.pageIndex,
    required this.column,
    required this.row,
    Key? key,
  }) : super(key: key);

  final int? pageIndex;
  final int column;
  final int row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnCount = ref.watch(dockColumnCountProvider);
    final rowCount = ref.watch(dockRowCountProvider);
    return SchildpadGridCell(
      coordinates: GlobalElementCoordinates(
          location: Location.dock, column: column, row: row),
      columnCount: columnCount,
      rowCount: rowCount,
    );
  }
}

class Dock extends ConsumerWidget {
  const Dock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dockColumnCount = ref.watch(dockColumnCountProvider);
    final dockRowCount = ref.watch(dockRowCountProvider);
    return Container(
        color: Colors.black38, child: DockGrid(dockColumnCount, dockRowCount));
  }
}
