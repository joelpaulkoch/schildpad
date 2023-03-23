import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/flexible_grid.dart';
import 'package:schildpad/home/grid.dart';
import 'package:schildpad/home/model/tile.dart';
import 'package:schildpad/home/tile.dart';
import 'package:schildpad/settings/layout_settings.dart';

final dockColumnCountProvider = Provider<int>((ref) {
  final layout = ref.watch(layoutSettingsProvider);
  return layout.dockColumns;
});
final dockRowCountProvider = Provider<int>((ref) {
  return 1;
});

final dockGridTilesProvider =
    FutureProvider<List<FlexibleGridTile>>((ref) async {
  ref.watch(isarTilesUpdateProvider);

  final columnCount = ref.watch(dockColumnCountProvider);
  final rowCount = ref.watch(dockRowCountProvider);

  final tiles = await ref.watch(isarTilesProvider.future);
  return tiles
      .filter()
      .coordinates((c) => c.locationEqualTo(Location.dock))
      .findAllSync()
      .map((e) => FlexibleGridTile(
          column: e.coordinates.column,
          row: e.coordinates.row,
          columnSpan: e.columnSpan,
          rowSpan: e.rowSpan,
          child: GridElement(
            coordinates: e.coordinates,
            columnCount: columnCount,
            rowCount: rowCount,
          )))
      .toList();
});

class Dock extends ConsumerWidget {
  const Dock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dockColumnCount = ref.watch(dockColumnCountProvider);
    final dockRowCount = ref.watch(dockRowCountProvider);
    final dockGridTiles = ref.watch(dockGridTilesProvider).maybeWhen(
        data: (tiles) => tiles, orElse: () => List<FlexibleGridTile>.empty());

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
