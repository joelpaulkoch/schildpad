import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/flexible_grid.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/model/home_tile.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';

final dockColumnCountProvider = Provider<int>((ref) {
  return 4;
});
final dockRowCountProvider = Provider<int>((ref) {
  return 1;
});

final dockGridTilesProvider = Provider<List<FlexibleGridTile>>((ref) {
  ref.watch(isarUpdateProvider);
  final tiles = ref.watch(homeIsarProvider).whenOrNull(data: (tiles) => tiles);

  final gridTiles = tiles?.filter().pageEqualTo(null).findAllSync();
  final flexibleGridTiles = gridTiles?.map((e) => FlexibleGridTile(
      column: e.column!,
      row: e.row!,
      columnSpan: e.columnSpan!,
      rowSpan: e.rowSpan!,
      child: DockGridCell(
        pageIndex: null,
        column: e.column!,
        row: e.row!,
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
    final tile = ref.watch(tileProvider(GlobalElementCoordinates(
        location: Location.dock, column: column, row: row)));

    final tileManager = ref.watch(tileManagerProvider);
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);

    return DragTarget<ElementData>(onWillAccept: (draggedData) {
      final data = draggedData;
      if (data != null) {
        return tileManager.canAddElement(
            columnCount, rowCount, pageIndex, column, row, data);
      }
      return false;
    }, onAccept: (data) async {
      await tileManager.addElement(
          columnCount, rowCount, pageIndex, column, row, data);

      final elementOrigin = data.origin;
      final originPageIndex = elementOrigin.pageIndex;
      final originColumn = elementOrigin.column;
      final originRow = elementOrigin.row;

      if (originColumn != null && originRow != null) {
        await tileManager.removeElement(
            originPageIndex, originColumn, originRow);
      }
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
      final appData = tile.appData;
      final appWidgetData = tile.appWidgetData;

      final Widget child;
      if (appData != null) {
        final appPackage = appData.packageName ?? '';
        child = InstalledAppDraggable(
          app: AppData(packageName: appPackage),
          appIcon: AppIcon(
            packageName: appPackage,
          ),
          origin: GlobalElementCoordinates(
              location: Location.dock, column: column, row: row),
        );
      } else if (appWidgetData != null) {
        final componentName = appWidgetData.componentName!;
        final widgetId = appWidgetData.appWidgetId!;
        child = HomeGridWidget(
            appWidgetData: AppWidgetData(
                componentName: componentName, appWidgetId: widgetId),
            columnSpan: tile.columnSpan!,
            rowSpan: tile.rowSpan!,
            origin: GlobalElementCoordinates(
                location: Location.dock, column: column, row: row));
      } else {
        child = const SizedBox.expand();
      }

      return OverflowBox(
        child: Container(
          foregroundDecoration: boxDecoration,
          child: child,
        ),
      );
    });
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
