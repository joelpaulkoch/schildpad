import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/flexible_grid.dart' as fg;
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_apps/apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

final homeColumnCountProvider = Provider<int>((ref) {
  return 4;
});
final homeRowCountProvider = Provider<int>((ref) {
  return 5;
});

String getHiveBoxName(int pageIndex) => 'home_data_$pageIndex';

String getHiveKey(int column, int row) => '${column}_$row';

final homeGridTilesProvider = StateNotifierProvider.family<
    HomeGridStateNotifier, List<fg.FlexibleGridTile>, int>((ref, pageIndex) {
  final columns = ref.watch(homeColumnCountProvider);
  final rows = ref.watch(homeRowCountProvider);
  return HomeGridStateNotifier(
    pageIndex,
    columns,
    rows,
  );
});

class HomeGridStateNotifier extends StateNotifier<List<fg.FlexibleGridTile>> {
  HomeGridStateNotifier(this.pageIndex, this.columnCount, this.rowCount)
      : hiveBox = Hive.box<String>(getHiveBoxName(pageIndex)),
        super([]) {
    var tiles = <fg.FlexibleGridTile>[];
    for (String key in hiveBox.keys) {
      final colRow = key.split('_');
      final col = int.parse(colRow[0]);
      final row = int.parse(colRow[1]);
      final String appPackage = hiveBox.get(key) ?? '';

      final tile = fg.FlexibleGridTile(
          column: col,
          row: row,
          child: InstalledAppDraggable(
            app: AppData(packageName: appPackage),
            appIcon: AppIcon(packageName: appPackage),
            pageIndex: pageIndex,
            column: col,
            row: row,
          ));

      tiles = fg.addTile(tiles, columnCount, rowCount, tile);
    }
    state = tiles;
  }

  final int pageIndex;
  final int columnCount;
  final int rowCount;

  Box<String> hiveBox;

  bool canAdd(fg.FlexibleGridTile tile) {
    return fg.canAdd(state, columnCount, rowCount, tile.column, tile.row,
        tile.columnSpan, tile.rowSpan);
  }

  void addTile(fg.FlexibleGridTile tile) {
    final stateBefore = state;
    state = fg.addTile(state, columnCount, rowCount, tile);
    if (state != stateBefore) {
      dev.log('saving app in (${tile.column}, ${tile.row})');
      hiveBox.put(getHiveKey(tile.column, tile.row), 'p');
    }
  }

  void removeTile(int columnStart, int rowStart) {
    state = fg.removeTile(state, columnStart, rowStart);
    dev.log('deleting app in (${columnStart}, ${rowStart})');
    hiveBox.delete(getHiveKey(columnStart, rowStart));
  }
}

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageCount = ref.watch(pageCountProvider);
    final leftPagesCount = ref.watch(leftPagesProvider);
    final initialPage = ref.watch(initialPageProvider);
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);
    final pageController = PageController(initialPage: initialPage);
    return PageView(
        controller: pageController,
        children: List.generate(
            pageCount,
            (index) =>
                HomeViewGrid(index - leftPagesCount, columnCount, rowCount)));
  }
}

class HomeViewGrid extends ConsumerWidget {
  const HomeViewGrid(
    this.pageIndex,
    this.columnCount,
    this.rowCount, {
    Key? key,
  }) : super(key: key);

  final int pageIndex;
  final int columnCount;
  final int rowCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dev.log('rebuilding HomeViewGrid');
    final homeGridTiles = ref.watch(homeGridTilesProvider(pageIndex));
    final defaultTiles = [];
    for (var col = 0; col < columnCount; col++) {
      for (var row = 0; row < rowCount; row++) {
        if (!homeGridTiles.any((tile) => fg.isInsideTile(col, row, tile))) {
          defaultTiles.add(fg.FlexibleGridTile(
              column: col,
              row: row,
              child: HomeGridEmptyCell(
                  pageIndex: pageIndex, column: col, row: row)));
        }
      }
    }

    return fg.FlexibleGrid(
        columnCount: columnCount,
        rowCount: rowCount,
        gridTiles: [...homeGridTiles, ...defaultTiles]);
  }
}

class HomeGridEmptyCell extends ConsumerWidget {
  const HomeGridEmptyCell({
    required this.pageIndex,
    required this.column,
    required this.row,
    Key? key,
  }) : super(key: key);

  final int pageIndex;
  final int column;
  final int row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<HomeGridElementData>(
      onWillAccept: (draggedData) {
        final data = draggedData;
        if (data != null) {
          final willAccept = ref
              .read(homeGridTilesProvider(pageIndex).notifier)
              .canAdd(fg.FlexibleGridTile(
                column: column,
                row: row,
                columnSpan: data.columnSpan,
                rowSpan: data.rowSpan,
              ));
          dev.log('($column, $row) will accept: $willAccept');
          return willAccept;
        }
        return false;
      },
      onAccept: (data) {
        dev.log('dropped in ($column, $row)');
        Widget? widgetToAdd;

        final app = data.appData;
        if (app != null) {
          widgetToAdd = InstalledAppDraggable(
            app: app,
            appIcon: AppIcon(packageName: app.packageName),
            pageIndex: pageIndex,
            column: column,
            row: row,
          );
        }
        final appWidget = data.appWidgetData;
        if (appWidget != null) {
          widgetToAdd = HomeGridWidget(
              appWidget: appWidget,
              pageIndex: pageIndex,
              column: column,
              row: row);
        }

        assert(widgetToAdd != null);

        ref.read(homeGridTilesProvider(pageIndex).notifier).addTile(
              fg.FlexibleGridTile(
                  column: column,
                  row: row,
                  columnSpan: data.columnSpan,
                  rowSpan: data.rowSpan,
                  child: SizedBox.expand(child: widgetToAdd)),
            );
        final originColumn = data.originColumn;
        final originRow = data.originRow;
        if (originColumn != null && originRow != null) {
          dev.log('removing element from ($originColumn, $originRow)');
          ref
              .read(homeGridTilesProvider(pageIndex).notifier)
              .removeTile(originColumn, originRow);
        }
        ref.read(showTrashProvider.notifier).state = false;
      },
      builder: (_, __, ___) => const SizedBox.expand(),
    );
  }
}

class HomeGridWidget extends ConsumerWidget {
  const HomeGridWidget({
    Key? key,
    required this.appWidget,
    required this.pageIndex,
    required this.column,
    required this.row,
  }) : super(key: key);

  final AppWidgetData appWidget;
  final int pageIndex;
  final int column;
  final int row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAppWidgetMenu = ref.watch(showAppWidgetContextMenuProvider);
    final widgetId = appWidget.appWidgetId ??
        ref
            .watch(appWidgetIdProvider(appWidget.componentName))
            .maybeMap(data: (id) => id.value, orElse: () => null);

    return Stack(alignment: AlignmentDirectional.center, children: [
      GestureDetector(
        onLongPress: () {
          ref.read(showAppWidgetContextMenuProvider.notifier).state = true;
        },
        child: (widgetId != null)
            ? AppWidget(
                appWidgetData: appWidget.copyWith(widgetId),
              )
            : const CircularProgressIndicator(),
      ),
      if (showAppWidgetMenu)
        AppWidgetContextMenu(
          pageIndex: pageIndex,
          columnStart: column,
          rowStart: row,
        )
    ]);
  }
}

class HomeGridElementData {
  HomeGridElementData(
      {this.appData,
      this.appWidgetData,
      required this.columnSpan,
      required this.rowSpan,
      this.originPageIndex,
      this.originColumn,
      this.originRow});

  final AppData? appData;
  final AppWidgetData? appWidgetData;
  final int columnSpan;
  final int rowSpan;
  final int? originPageIndex;
  final int? originColumn;
  final int? originRow;

  bool get isEmpty => appData == null && appWidgetData == null;
}
