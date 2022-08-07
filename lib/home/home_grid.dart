import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/flexible_grid/flexible_grid.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_apps/apps.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

final homeColumnCountProvider = Provider<int>((ref) {
  return 4;
});
final homeRowCountProvider = Provider<int>((ref) {
  return 5;
});

final homeGridTilesProvider = StateNotifierProvider.family<
    FlexibleGridStateNotifier, List<FlexibleGridTile>, int>((ref, pageIndex) {
  final columns = ref.watch(homeColumnCountProvider);
  final rows = ref.watch(homeRowCountProvider);
  return FlexibleGridStateNotifier(columns, rows);
});

final homeGridElementDataProvider =
    StateProvider.family<HomeGridElementData, PagedGridCell>(
        (ref, pageGridCell) {
  return HomeGridElementData();
});

class HomeViewGrid extends ConsumerWidget {
  const HomeViewGrid(
    this.pageIndex, {
    Key? key,
  }) : super(key: key);

  final int pageIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeGridTiles = ref.watch(homeGridTilesProvider(pageIndex));
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
              child: HomeGridElement(pageIndex, tile.column, tile.row),
            ),
        ]);
  }
}

class HomeGridElement extends ConsumerWidget {
  const HomeGridElement(
    this.pageIndex,
    this.columnStart,
    this.rowStart, {
    Key? key,
  }) : super(key: key);

  final int pageIndex;
  final int columnStart;
  final int rowStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);
    final gridElementData = ref.watch(homeGridElementDataProvider(
        PagedGridCell(pageIndex, columnStart, rowStart)));
    final app = gridElementData.appData;
    return DragTarget<HomeGridElementData>(onWillAccept: (draggedData) {
      final data = draggedData;
      if (data != null) {
        final willAccept =
            ref.read(homeGridTilesProvider(pageIndex).notifier).canAdd(
                  columnStart,
                  rowStart,
                  data.getColumnSpan(context, columnCount),
                  data.getRowSpan(context, rowCount),
                );
        dev.log('($columnStart, $rowStart) will accept: $willAccept');
        return willAccept;
      }
      return false;
    }, onAccept: (data) {
      dev.log('dropped in ($columnStart, $rowStart)');
      if (ref.read(homeGridTilesProvider(pageIndex).notifier).addTile(
          FlexibleGridTile(
              column: columnStart,
              row: rowStart,
              columnSpan: data.getColumnSpan(context, columnCount),
              rowSpan: data.getRowSpan(context, rowCount)))) {
        ref
            .read(homeGridElementDataProvider(
                    PagedGridCell(pageIndex, columnStart, rowStart))
                .notifier)
            .state = data;

        final originColumn = data.originColumn;
        final originRow = data.originRow;
        if (originColumn != null && originRow != null) {
          dev.log('removing element from ($columnStart, $rowStart)');
          ref
              .read(homeGridElementDataProvider(
                      PagedGridCell(pageIndex, originColumn, originRow))
                  .notifier)
              .state = HomeGridElementData();
          ref
              .read(homeGridTilesProvider(pageIndex).notifier)
              .removeTile(originColumn, originRow);
        }
      }
      ref.read(showTrashProvider.notifier).state = false;
    }, builder: (_, __, ___) {
      if (app != null) {
        return InstalledAppDraggable(
          app: app,
          appIcon: AppIcon(packageName: app.packageName),
          pageIndex: pageIndex,
          column: columnStart,
          row: rowStart,
        );
      }
      final appWidget = gridElementData.appWidgetData;
      if (appWidget != null) {
        final widgetId = appWidget.appWidgetId ??
            ref
                .watch(appWidgetIdProvider(appWidget.componentName))
                .maybeMap(data: (id) => id.value, orElse: () => null);

        if (widgetId != null) {
          final showAppWidgetMenu = ref.watch(showAppWidgetContextMenuProvider);
          return Stack(alignment: AlignmentDirectional.center, children: [
            GestureDetector(
              onLongPress: () {
                ref.read(showAppWidgetContextMenuProvider.notifier).state =
                    true;
              },
              child: AppWidget(
                appWidgetData: appWidget.copyWith(widgetId),
              ),
            ),
            if (showAppWidgetMenu)
              AppWidgetContextMenu(
                pageIndex: pageIndex,
                columnStart: columnStart,
                rowStart: rowStart,
              )
          ]);
        }
      }
      return const SizedBox.expand();
    });
  }
}

class HomeGridElementData {
  HomeGridElementData(
      {this.appData,
      this.appWidgetData,
      this.originPageIndex,
      this.originColumn,
      this.originRow});

  final AppData? appData;
  final AppWidgetData? appWidgetData;
  final int? originPageIndex;
  final int? originColumn;
  final int? originRow;

  bool get isEmpty => appData == null && appWidgetData == null;

  int getColumnSpan(BuildContext context, int columnCount) {
    if (appData != null) {
      return 1;
    }
    final widgetData = appWidgetData;
    if (widgetData != null) {
      // return widgetData.getColumnSpan(context, columnCount);
      return 2;
    }
    return 1;
  }

  int getRowSpan(BuildContext context, int rowCount) {
    if (appData != null) {
      return 1;
    }
    final widgetData = appWidgetData;
    if (widgetData != null) {
      // return widgetData.getRowSpan(context, rowCount);
      return 1;
    }
    return 1;
  }
}
