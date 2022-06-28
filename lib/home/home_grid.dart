import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/flexible_grid/flexible_grid.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

final homeColumnCountProvider = Provider<int>((ref) {
  return 4;
});
final homeRowCountProvider = Provider<int>((ref) {
  return 5;
});

final homeGridTilesProvider =
    StateNotifierProvider<FlexibleGridStateNotifier, List<FlexibleGridTile>>(
        (ref) {
  final columns = ref.watch(homeColumnCountProvider);
  final rows = ref.watch(homeRowCountProvider);
  return FlexibleGridStateNotifier(columns, rows);
});

final homeGridElementDataProvider = StateProvider //TODO check .autoDispose
    .family<HomeGridElementData, GridCell>((ref, gridCell) {
  return HomeGridElementData();
});

class HomeViewGrid extends ConsumerWidget {
  const HomeViewGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeGridTiles = ref.watch(homeGridTilesProvider);
    final columns = ref.watch(homeColumnCountProvider);
    final rows = ref.watch(homeRowCountProvider);
    dev.log('rebuilding HomeViewGrid');
    return FlexibleGrid(
        columnCount: columns,
        rowCount: rows,
        gridTiles: homeGridTiles,
        children: [
          for (final tile in homeGridTiles)
            FlexibleGridChild(
              column: tile.column,
              row: tile.row,
              child: HomeGridElement(tile.column, tile.row),
            ),
        ]);
  }
}

class HomeGridElement extends ConsumerWidget {
  const HomeGridElement(
    this.columnStart,
    this.rowStart, {
    Key? key,
  }) : super(key: key);

  final int columnStart;
  final int rowStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridElementData =
        ref.watch(homeGridElementDataProvider(GridCell(columnStart, rowStart)));
    final app = gridElementData.appData;
    return DragTarget<HomeGridElementData>(onWillAccept: (draggedData) {
      final data = draggedData;
      if (data != null) {
        return ref.read(homeGridTilesProvider.notifier).canAdd(
              columnStart,
              rowStart,
              data.columnSpan,
              data.rowSpan,
            );
      }
      return false;
    }, onAccept: (data) {
      if (ref.read(homeGridTilesProvider.notifier).addTile(FlexibleGridTile(
          column: columnStart,
          row: rowStart,
          columnSpan: data.columnSpan,
          rowSpan: data.rowSpan))) {
        ref
            .read(homeGridElementDataProvider(GridCell(columnStart, rowStart))
                .notifier)
            .state = data;
      }
      ref.read(showTrashProvider.notifier).state = false;
    }, builder: (_, __, ___) {
      if (app != null) {
        return InstalledAppIcon(
            app: app,
            onDragStarted: () {
              ref.read(showTrashProvider.notifier).state = true;
            },
            onDragCompleted: () {
              dev.log('removing ${app.name} from ($columnStart, $rowStart)');
              ref
                  .read(homeGridTilesProvider.notifier)
                  .removeTile(columnStart, rowStart);
              // TODO check if necessary
              ref
                  .read(homeGridElementDataProvider(
                          GridCell(columnStart, rowStart))
                      .notifier)
                  .state = HomeGridElementData();
            },
            onDraggableCanceled: (_, __) {
              ref.read(showTrashProvider.notifier).state = false;
            });
      }
      final appWidget = gridElementData.appWidgetData;
      if (appWidget != null) {
        return AppWidget(
            appWidgetData: appWidget,
            onDragStarted: () {
              ref.read(showTrashProvider.notifier).state = true;
            },
            onDragCompleted: () {
              dev.log(
                  'removing ${appWidget.label} from ($columnStart, $rowStart)');
              ref
                  .read(homeGridTilesProvider.notifier)
                  .removeTile(columnStart, rowStart);
              // TODO check if necessary
              ref
                  .read(homeGridElementDataProvider(
                          GridCell(columnStart, rowStart))
                      .notifier)
                  .state = HomeGridElementData();
            },
            onDraggableCanceled: (_, __) {
              ref.read(showTrashProvider.notifier).state = false;
            });
      }
      return const SizedBox.expand();
    });
  }
}

class HomeGridElementData {
  final AppData? appData;
  final AppWidgetData? appWidgetData;

  HomeGridElementData({this.appData, this.appWidgetData});

  bool get isEmpty => appData == null && appWidgetData == null;

  // TODO add appWidgetData
  int get columnSpan => (appData != null) ? 1 : 2;

  int get rowSpan => (appData != null) ? 1 : 2;
}
