import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/flexible_grid.dart';
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

String getHomeDataHiveBoxName(int pageIndex) => 'home_data_$pageIndex';

String getHomeDataHiveKey(int column, int row) => '${column}_$row';

final homeGridTilesProvider =
    Provider.family<List<FlexibleGridTile>, int>((ref, pageIndex) {
  final tiles = ref.watch(homeGridStateProvider(pageIndex));
  return tiles;
});

final homeGridStateProvider = StateNotifierProvider.family<
    HomeGridStateNotifier, List<FlexibleGridTile>, int>((ref, pageIndex) {
  final columns = ref.watch(homeColumnCountProvider);
  final rows = ref.watch(homeRowCountProvider);
  return HomeGridStateNotifier(
    pageIndex,
    columns,
    rows,
  );
});

class HomeGridStateNotifier extends StateNotifier<List<FlexibleGridTile>> {
  HomeGridStateNotifier(this.pageIndex, this.columnCount, this.rowCount)
      : hiveBox = Hive.box<List<String>>(getHomeDataHiveBoxName(pageIndex)),
        super([]) {
    var tiles = <FlexibleGridTile>[];
    for (String key in hiveBox.keys) {
      final colRow = key.split('_');
      final col = int.parse(colRow[0]);
      final row = int.parse(colRow[1]);
      final List elementData = hiveBox.get(key) ?? [];

      Widget? tileChild;
      if (elementData.length == 1) {
        final appPackage = elementData.cast<String>().first;
        tileChild = InstalledAppDraggable(
          app: AppData(packageName: appPackage),
          appIcon: AppIcon(packageName: appPackage),
          pageIndex: pageIndex,
          column: col,
          row: row,
        );
      } else if (elementData.length == 2) {
        final appWidgetData = elementData.cast<String>();
        final componentName = appWidgetData.first;
        final appWidgetId = int.parse(appWidgetData.elementAt(1));
        tileChild = HomeGridWidget(
            appWidget: AppWidgetData(
                componentName: componentName, appWidgetId: appWidgetId),
            pageIndex: pageIndex,
            column: col,
            row: row);
      }

      final tile = FlexibleGridTile(column: col, row: row, child: tileChild);

      tiles = addTile(tiles, columnCount, rowCount, tile);
    }
    state = tiles;
  }

  final int pageIndex;
  final int columnCount;
  final int rowCount;

  Box<List<String>> hiveBox;

  bool canAddElement(int column, int row, HomeGridElementData data) {
    return canAdd(state, columnCount, rowCount, column, row, data.columnSpan,
        data.rowSpan);
  }

  void addElement(int column, int row, HomeGridElementData data) {
    Widget? widgetToAdd;
    List<String> dataToPersist = [];

    final app = data.appData;
    final appWidget = data.appWidgetData;

    if (app != null) {
      widgetToAdd = InstalledAppDraggable(
        app: app,
        appIcon: AppIcon(packageName: app.packageName),
        pageIndex: pageIndex,
        column: column,
        row: row,
      );
      dataToPersist.add(app.packageName);
    } else if (appWidget != null) {
      widgetToAdd = HomeGridWidget(
          appWidget: appWidget, pageIndex: pageIndex, column: column, row: row);
      dataToPersist.add(appWidget.componentName);
      dataToPersist.add('${appWidget.appWidgetId}');
    }

    final tileToAdd = FlexibleGridTile(
        column: column,
        row: row,
        columnSpan: data.columnSpan,
        rowSpan: data.rowSpan,
        child: SizedBox.expand(child: widgetToAdd));

    final stateBefore = state;
    state = addTile(state, columnCount, rowCount, tileToAdd);
    if (state != stateBefore) {
      dev.log('saving element in ($column, $row)');
      hiveBox.put(getHomeDataHiveKey(column, row), dataToPersist);
    }
  }

  void removeElement(int columnStart, int rowStart) {
    state = removeTile(state, columnStart, rowStart);
    dev.log('deleting element in ($columnStart, $rowStart)');
    hiveBox.delete(getHomeDataHiveKey(columnStart, rowStart));
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
        if (!homeGridTiles.any((tile) => isInsideTile(col, row, tile))) {
          defaultTiles.add(FlexibleGridTile(
              column: col,
              row: row,
              child: HomeGridEmptyCell(
                  pageIndex: pageIndex, column: col, row: row)));
        }
      }
    }

    return FlexibleGrid(
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
              .read(homeGridStateProvider(pageIndex).notifier)
              .canAddElement(column, row, data);
          dev.log('($column, $row) will accept: $willAccept');
          return willAccept;
        }
        return false;
      },
      onAccept: (data) {
        dev.log('dropped in ($column, $row)');
        ref
            .read(homeGridStateProvider(pageIndex).notifier)
            .addElement(column, row, data);
        final originColumn = data.originColumn;
        final originRow = data.originRow;
        if (originColumn != null && originRow != null) {
          dev.log('removing element from ($originColumn, $originRow)');
          ref
              .read(homeGridStateProvider(pageIndex).notifier)
              .removeElement(originColumn, originRow);
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