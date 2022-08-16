import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/dock.dart';
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

double homeViewAspectRatio(
    BuildContext context, int homeRowCount, int totalRows) {
  final homeViewWidth = MediaQuery.of(context).size.width;
  final displayHeight = MediaQuery.of(context).size.height;
  final homeViewHeight = displayHeight * homeRowCount / totalRows;
  return homeViewWidth / homeViewHeight;
}

String _getHomeDataHiveBoxName(int pageIndex) => 'home_data_$pageIndex';

String _getHomeDataHiveKey(int column, int row) => '${column}_$row';

final homeGridTilesProvider =
    Provider.family<List<FlexibleGridTile>, int>((ref, pageIndex) {
  final tiles = ref.watch(homeGridStateProvider(pageIndex));
  return tiles;
});

final _homeGridHiveBoxProvider =
    FutureProvider.family<Box<List<String>>, int>((ref, pageIndex) async {
  final box = Hive.openBox<List<String>>(_getHomeDataHiveBoxName(pageIndex));
  return box;
});

final homeGridStateProvider = StateNotifierProvider.family<
    HomeGridStateNotifier, List<FlexibleGridTile>, int>((ref, pageIndex) {
  final columns = ref.watch(homeColumnCountProvider);
  final rows = ref.watch(homeRowCountProvider);
  final hiveBox = ref.watch(_homeGridHiveBoxProvider(pageIndex)).valueOrNull;
  return HomeGridStateNotifier(pageIndex, columns, rows, hiveBox: hiveBox);
});

class HomeGridStateNotifier extends StateNotifier<List<FlexibleGridTile>> {
  HomeGridStateNotifier(this.pageIndex, this.columnCount, this.rowCount,
      {this.hiveBox})
      : super([]) {
    final box = hiveBox;
    if (box != null) {
      var tiles = <FlexibleGridTile>[];

      for (String key in box.keys) {
        final colRow = key.split('_');
        final column = int.parse(colRow[0]);
        final row = int.parse(colRow[1]);
        final List elementData = box.get(key) ?? [];

        Widget? tileChild;
        var columnSpan = 1;
        var rowSpan = 1;
        if (elementData.length == 1) {
          final appPackage = elementData.cast<String>().first;
          tileChild = InstalledAppDraggable(
              app: AppData(packageName: appPackage),
              appIcon: AppIcon(packageName: appPackage),
              origin: GlobalElementCoordinates.onHome(
                pageIndex: pageIndex,
                column: column,
                row: row,
              ));
        } else if (elementData.length == 4) {
          final appWidgetData = elementData.cast<String>();
          final componentName = appWidgetData.first;
          final appWidgetId = int.tryParse(appWidgetData.elementAt(1));
          if (appWidgetId == null) {
            box.delete(key);
            tileChild = HomeGridEmptyCell(
                pageIndex: pageIndex, column: column, row: row);
          }
          columnSpan = int.parse(appWidgetData.elementAt(2));
          rowSpan = int.parse(appWidgetData.elementAt(3));
          tileChild = HomeGridWidget(
              appWidgetData: AppWidgetData(
                  componentName: componentName, appWidgetId: appWidgetId),
              columnSpan: columnSpan,
              rowSpan: rowSpan,
              origin: GlobalElementCoordinates.onHome(
                  pageIndex: pageIndex, column: column, row: row));
        } else {
          box.delete(key);
          tileChild =
              HomeGridEmptyCell(pageIndex: pageIndex, column: column, row: row);
        }

        final tile = FlexibleGridTile(
            column: column,
            row: row,
            columnSpan: columnSpan,
            rowSpan: rowSpan,
            child: Center(child: tileChild));

        tiles = addTile(tiles, columnCount, rowCount, tile);
      }
      state = tiles;
    }
  }

  final int pageIndex;
  final int columnCount;
  final int rowCount;

  final Box<List<String>>? hiveBox;

  bool canAddElement(int column, int row, ElementData data) {
    return canAdd(state, columnCount, rowCount, column, row, data.columnSpan,
        data.rowSpan);
  }

  void addElement(int column, int row, ElementData data) async {
    Widget? widgetToAdd;
    List<String> dataToPersist = [];

    final app = data.appData;
    final appWidget = data.appWidgetData;

    if (app != null) {
      widgetToAdd = InstalledAppDraggable(
          app: app,
          appIcon: AppIcon(packageName: app.packageName),
          origin: GlobalElementCoordinates.onHome(
            pageIndex: pageIndex,
            column: column,
            row: row,
          ));
      dataToPersist.add(app.packageName);
    } else if (appWidget != null) {
      ElementData elementData = data;
      if (elementData.isAppWidgetData) {
        final widgetId = await createWidget(data.appWidgetData!.componentName);
        elementData = data.copyWithAppWidgetData(
            data.appWidgetData!.componentName, widgetId);
      }
      widgetToAdd = HomeGridWidget(
          appWidgetData: elementData.appWidgetData!,
          columnSpan: elementData.columnSpan,
          rowSpan: elementData.rowSpan,
          origin: GlobalElementCoordinates.onHome(
              pageIndex: pageIndex, column: column, row: row));
      dataToPersist.add(appWidget.componentName);
      dataToPersist.add('${elementData.appWidgetData!.appWidgetId}');
      dataToPersist.add('${elementData.columnSpan}');
      dataToPersist.add('${elementData.rowSpan}');
    }

    final tileToAdd = FlexibleGridTile(
        column: column,
        row: row,
        columnSpan: data.columnSpan,
        rowSpan: data.rowSpan,
        child: Center(child: widgetToAdd));

    final stateBefore = state;
    state = addTile(state, columnCount, rowCount, tileToAdd);
    if (state != stateBefore) {
      dev.log('saving element in ($column, $row)');
      hiveBox?.put(_getHomeDataHiveKey(column, row), dataToPersist);
    }
  }

  void removeElement(int columnStart, int rowStart) {
    state = [...removeTile(state, columnStart, rowStart)];
    dev.log('deleting element in ($columnStart, $rowStart)');
    hiveBox?.delete(_getHomeDataHiveKey(columnStart, rowStart));
  }

  void removeAll() {
    hiveBox?.deleteAll(hiveBox?.keys ?? []);
    state = [];
  }
}

final pageControllerProvider = Provider<PageController>((ref) {
  final initialPage = ref.watch(initialPageProvider);
  return PageController(initialPage: initialPage);
});

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageCount = ref.watch(pageCountProvider);
    final leftPagesCount = ref.watch(leftPagesProvider);
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);
    final dockRowCount = ref.watch(dockRowCountProvider);
    final totalRows = rowCount + dockRowCount;
    final pageController = ref.watch(pageControllerProvider);
    return AspectRatio(
        aspectRatio: homeViewAspectRatio(context, rowCount, totalRows),
        child: PageView(
            controller: pageController,
            children: List.generate(
                pageCount,
                (index) => HomeViewGrid(
                    index - leftPagesCount, columnCount, rowCount))));
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
    dev.log('rebuilding HomeViewGrid $pageIndex');
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
    return DragTarget<ElementData>(
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
        final elementOrigin = data.origin;
        final originPageIndex = elementOrigin.pageIndex;
        final originColumn = elementOrigin.column;
        final originRow = elementOrigin.row;

        if (elementOrigin.isOnDock &&
            originColumn != null &&
            originRow != null) {
          dev.log('removing element from dock ($originColumn, $originRow)');
          ref
              .read(dockGridStateProvider.notifier)
              .removeElement(originColumn, originRow);
        } else if (elementOrigin.isOnHome &&
            originPageIndex != null &&
            originColumn != null &&
            originRow != null) {
          dev.log(
              'removing element from page $originPageIndex ($originColumn, $originRow)');
          ref
              .read(homeGridStateProvider(originPageIndex).notifier)
              .removeElement(originColumn, originRow);
        }
        ref.read(showTrashProvider.notifier).state = false;
      },
      builder: (_, __, ___) => const SizedBox.expand(),
    );
  }
}

class HomeGridWidget extends StatelessWidget {
  const HomeGridWidget({
    Key? key,
    required this.appWidgetData,
    required this.columnSpan,
    required this.rowSpan,
    required this.origin,
  }) : super(key: key);

  final AppWidgetData appWidgetData;
  final GlobalElementCoordinates origin;
  final int columnSpan;
  final int rowSpan;

  @override
  Widget build(BuildContext context) {
    final widgetId = appWidgetData.appWidgetId;
    assert(widgetId != null);

    if (widgetId != null) {
      return LongPressDraggable(
          data: ElementData(
            appWidgetData: appWidgetData,
            columnSpan: columnSpan,
            rowSpan: rowSpan,
            origin: origin,
          ),
          maxSimultaneousDrags: 1,
          feedback:
              Container(color: Colors.cyanAccent, width: 200, height: 100),
          child: AppWidget(
            appWidgetData: appWidgetData,
          ));
    } else {
      return const AppWidgetError();
    }
  }
}

class AppWidgetError extends StatelessWidget {
  const AppWidgetError({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Card(
      color: Colors.amber,
      child: Column(
        children: const [
          Icon(
            Icons.bubble_chart,
            color: Colors.white,
          ),
          Icon(
            Icons.adb_outlined,
            color: Colors.white,
          )
        ],
      ),
    ));
  }
}

class ElementData {
  ElementData(
      {this.appData,
      this.appWidgetData,
      required this.columnSpan,
      required this.rowSpan,
      required this.origin});

  ElementData.fromAppData(
      {required AppData this.appData,
      required this.columnSpan,
      required this.rowSpan,
      required this.origin})
      : appWidgetData = null;

  ElementData.fromAppWidgetData(
      {required AppWidgetData this.appWidgetData,
      required this.columnSpan,
      required this.rowSpan,
      required this.origin})
      : appData = null;

  final AppData? appData;
  final AppWidgetData? appWidgetData;
  final int columnSpan;
  final int rowSpan;
  final GlobalElementCoordinates origin;

  ElementData copyWithAppWidgetData(String componentName, int appWidgetId) =>
      ElementData.fromAppWidgetData(
          appWidgetData: AppWidgetData(
              componentName: componentName, appWidgetId: appWidgetId),
          columnSpan: columnSpan,
          rowSpan: rowSpan,
          origin: origin);

  bool get isAppData => appData != null;

  bool get isAppWidgetData => !isAppData && appWidgetData != null;

  bool get isEmpty => !isAppData && !isAppWidgetData;
}

class GlobalElementCoordinates {
  GlobalElementCoordinates.onDock(
      {required int this.column, required int this.row})
      : isOnDock = true,
        pageIndex = null;

  GlobalElementCoordinates.onHome(
      {required int this.pageIndex,
      required int this.column,
      required int this.row})
      : isOnDock = false;

  GlobalElementCoordinates.onList()
      : isOnDock = false,
        pageIndex = null,
        column = null,
        row = null;

  final bool isOnDock;
  final int? pageIndex;
  final int? column;
  final int? row;

  bool get isOnHome =>
      !isOnDock && (pageIndex != null) && (column != null) && (row != null);

  bool get isOnList => !isOnDock && !isOnHome;
}
