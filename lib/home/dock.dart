import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/flexible_grid.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/model/tile.dart';

final dockColumnCountProvider = Provider<int>((ref) {
  return 4;
});
final dockRowCountProvider = Provider<int>((ref) {
  return 1;
});

final dockGridTilesProvider = Provider<List<FlexibleGridTile>>((ref) {
  ref.watch(isarUpdateProvider);
  final tiles = ref.watch(homeIsarProvider).whenOrNull(data: (tiles) => tiles);
  final columnCount = ref.watch(dockColumnCountProvider);
  final rowCount = ref.watch(dockRowCountProvider);
  final gridTiles = tiles
      ?.filter()
      .coordinates((c) => c.locationEqualTo(Location.dock))
      .findAllSync();
  final flexibleGridTiles = gridTiles?.map((e) => FlexibleGridTile(
      column: e.coordinates.column,
      row: e.coordinates.row,
      columnSpan: e.columnSpan,
      rowSpan: e.rowSpan,
      child: GridCell(
        coordinates: e.coordinates,
        columnCount: columnCount,
        rowCount: rowCount,
      )));
  return flexibleGridTiles?.toList() ?? List.empty();
});

class Dock extends ConsumerWidget {
  const Dock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dockColumnCount = ref.watch(dockColumnCountProvider);
    final dockRowCount = ref.watch(dockRowCountProvider);
    final dockGridTiles = ref.watch(dockGridTilesProvider);

    return Container(
        color: Colors.black38,
        child: Grid(
            location: Location.dock,
            page: null,
            columnCount: dockColumnCount,
            rowCount: dockRowCount,
            tiles: dockGridTiles));
  }
}
