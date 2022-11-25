import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/flexible_grid.dart';
import 'package:schildpad/home/model/tile.dart';
import 'package:schildpad/home/tile.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';

class Grid extends StatelessWidget {
  const Grid(
      {Key? key,
      required this.location,
      this.page,
      required this.columnCount,
      required this.rowCount,
      required this.tiles})
      : super(key: key);
  final Location location;
  final int? page;
  final int columnCount;
  final int rowCount;
  final List<FlexibleGridTile> tiles;

  @override
  Widget build(BuildContext context) {
    final defaultTiles = [];
    for (var column = 0; column < columnCount; column++) {
      for (var row = 0; row < rowCount; row++) {
        if (!tiles.any((tile) => isInsideTile(column, row, tile))) {
          defaultTiles.add(_getDefaultTile(
              location, page, column, row, columnCount, rowCount));
        }
      }
    }

    return FlexibleGrid(
        columnCount: columnCount,
        rowCount: rowCount,
        gridTiles: [...tiles, ...defaultTiles]);
  }
}

FlexibleGridTile _getDefaultTile(Location location, int? page, int column,
        int row, int columnCount, int rowCount) =>
    FlexibleGridTile(
        column: column,
        row: row,
        child: GridElement(
          coordinates: GlobalElementCoordinates(
              location: location, page: page, column: column, row: row),
          columnCount: columnCount,
          rowCount: rowCount,
        ));

class GridElement extends ConsumerWidget {
  const GridElement(
      {Key? key,
      required this.coordinates,
      required this.columnCount,
      required this.rowCount})
      : super(key: key);
  final GlobalElementCoordinates coordinates;
  final int columnCount;
  final int rowCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tile = ref.watch(tileProvider(coordinates));
    final tileManager = ref.watch(tileManagerProvider);

    /* app widget gets special treatment because you cannot drag it inside drag target
     * when this is fixed this part should be moved inside the DragTarget
     */
    if (_isAppWidgetData(tile.tileData)) {
      final appWidgetData = tile.tileData?.appWidgetData;
      if (appWidgetData != null) {
        assert(appWidgetData.appWidgetId != null);
        return AppWidgetDraggable(
            appWidgetData: appWidgetData,
            columnSpan: tile.columnSpan,
            rowSpan: tile.rowSpan,
            origin: coordinates);
      }
    }

    return DragTarget<ElementData>(onWillAccept: (draggedData) {
      final data = draggedData;

      if (data != null) {
        return tileManager.canAddElement(
            columnCount, rowCount, coordinates, data);
      }

      return false;
    }, onAccept: (data) async {
      await tileManager.addElement(columnCount, rowCount, coordinates, data);
      await tileManager.removeElement(data.origin);
      ref.read(showTrashProvider.notifier).state = false;
    }, builder: (_, accepted, rejected) {
      BoxDecoration? boxDecoration;
      if (rejected.isNotEmpty) {
        boxDecoration =
            BoxDecoration(border: Border.all(color: Colors.red, width: 3));
      } else if (accepted.isNotEmpty) {
        boxDecoration = BoxDecoration(
            border: Border.all(color: Colors.greenAccent, width: 3));
      }

      final appData = tile.tileData?.appData;
      final Widget child;
      if (appData != null) {
        child = InstalledAppDraggable(
          app: appData,
          appIcon: AppIcon(
            packageName: appData.packageName,
            showAppName: false,
          ),
          origin: coordinates,
        );
      } else {
        child = const SizedBox.expand();
      }

      return Container(
        alignment: Alignment.center,
        foregroundDecoration: boxDecoration,
        child: child,
      );
    });
  }
}

bool _isAppWidgetData(ElementData? data) =>
    data != null && data.appData == null && data.appWidgetData != null;
