import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/flexible_grid.dart';
import 'package:schildpad/home/model/home_tile.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_app_widgets/installed_application_widgets.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';

final homeColumnCountProvider = Provider<int>((ref) {
  return 4;
});
final homeRowCountProvider = Provider<int>((ref) {
  return 5;
});

double approxHomeViewAspectRatio(
    BuildContext context, int homeRowCount, int totalRows) {
  final homeViewWidth = MediaQuery.of(context).size.width;
  final displayHeight = MediaQuery.of(context).size.height;
  final homeViewHeight = displayHeight * homeRowCount / totalRows;
  return homeViewWidth / homeViewHeight;
}

double homeGridColumnWidth(BuildContext context, int columnCount) {
  final homeViewWidth = MediaQuery.of(context).size.width;
  return homeViewWidth / columnCount;
}

double homeGridRowHeight(BuildContext context, int rowCount) {
  final homeViewWidth = MediaQuery.of(context).size.width;
  return homeViewWidth / rowCount;
}

final homeIsarProvider = FutureProvider<IsarCollection<HomeTile>>((ref) async {
  final isar = await Isar.open([HomeTileSchema]);
  return isar.homeTiles;
});

final isarUpdateProvider = StreamProvider<void>((ref) async* {
  final isar = await Isar.open([HomeTileSchema]);
  yield* isar.homeTiles.watchLazy().cast();
});

final homeGridTilesProvider =
    Provider.family<List<FlexibleGridTile>, int>((ref, pageIndex) {
  ref.watch(isarUpdateProvider);
  final tiles = ref.watch(homeIsarProvider).whenOrNull(data: (tiles) => tiles);

  final gridTiles = tiles?.filter().pageEqualTo(pageIndex).findAllSync();
  final flexibleGridTiles = gridTiles?.map((e) => FlexibleGridTile(
      column: e.column!,
      row: e.row!,
      columnSpan: e.columnSpan!,
      rowSpan: e.rowSpan!,
      child: HomeGridCell(
        pageIndex: pageIndex,
        column: e.column!,
        row: e.row!,
      )));
  return flexibleGridTiles?.toList() ?? List.empty();
});

class HomeGridCell extends ConsumerWidget {
  const HomeGridCell({
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
    final tile = ref.watch(tileProvider(GlobalElementCoordinates.onHome(
        pageIndex: pageIndex, column: column, row: row)));

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
      if (appData?.packageName != null) {
        final appPackage = appData?.packageName ?? '';
        child = InstalledAppDraggable(
          app: AppData(packageName: appPackage),
          appIcon: AppIcon(
            packageName: appPackage,
          ),
          origin: GlobalElementCoordinates.onHome(
              pageIndex: pageIndex, column: column, row: row),
        );
      } else if (appWidgetData != null) {
        final componentName = appWidgetData.componentName!;
        final widgetId = appWidgetData.appWidgetId!;
        child = HomeGridWidget(
            appWidgetData: AppWidgetData(
                componentName: componentName, appWidgetId: widgetId),
            columnSpan: tile.columnSpan!,
            rowSpan: tile.rowSpan!,
            origin: GlobalElementCoordinates.onHome(
                pageIndex: pageIndex, column: column, row: row));
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

final tileProvider = Provider.family<HomeTile, GlobalElementCoordinates>(
    (ref, globalCoordinates) {
  ref.watch(isarUpdateProvider);
  final tiles = ref.watch(homeIsarProvider).whenOrNull(data: (tiles) => tiles);

  final homeTile = tiles
      ?.filter()
      .pageEqualTo(globalCoordinates.pageIndex)
      .columnEqualTo(globalCoordinates.column)
      .rowEqualTo(globalCoordinates.row)
      .findFirstSync();

  return homeTile ??
      HomeTile(
          page: globalCoordinates.pageIndex,
          column: globalCoordinates.column,
          row: globalCoordinates.row);
});

class HomePageViewScrollPhysics extends ScrollPhysics {
  const HomePageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  HomePageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HomePageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 0.7,
      );
}

final currentHomePageProvider = StateProvider<int>((ref) {
  final initialPage = ref.read(initialPageProvider);
  return initialPage;
});

int pageViewToSchildpadIndex(int pageViewIndex, int leftPages) =>
    pageViewIndex - leftPages;

int schildpadToPageViewIndex(int schildpadIndex, int leftPages) =>
    schildpadIndex + leftPages;

final homePageControllerProvider = Provider<PageController>((ref) {
  final leftPagesCount = ref.watch(leftPagesProvider);
  final currentPage = ref.watch(currentHomePageProvider);

  final pageController = PageController(
      initialPage: schildpadToPageViewIndex(currentPage, leftPagesCount));
  return pageController;
});

class HomeView extends ConsumerWidget {
  const HomeView({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageCount = ref.watch(pageCountProvider);
    final leftPagesCount = ref.watch(leftPagesProvider);
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);

    return PageView(
        controller: pageController,
        onPageChanged: (page) {
          final schildpadPage = pageViewToSchildpadIndex(page, leftPagesCount);
          ref.read(currentHomePageProvider.notifier).state = schildpadPage;
        },
        physics: const HomePageViewScrollPhysics(),
        children: List.generate(
            pageCount,
            (index) => HomeViewGrid(
                pageViewToSchildpadIndex(index, leftPagesCount),
                columnCount,
                rowCount)));
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
    final homeGridTiles = ref.watch(homeGridTilesProvider(pageIndex));
    final defaultTiles = [];
    for (var col = 0; col < columnCount; col++) {
      for (var row = 0; row < rowCount; row++) {
        if (!homeGridTiles.any((tile) => isInsideTile(col, row, tile))) {
          defaultTiles.add(FlexibleGridTile(
              column: col,
              row: row,
              child:
                  HomeGridCell(pageIndex: pageIndex, column: col, row: row)));
        }
      }
    }

    return FlexibleGrid(
        columnCount: columnCount,
        rowCount: rowCount,
        gridTiles: [...homeGridTiles, ...defaultTiles]);
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

final tileManagerProvider = Provider<TileManager>((ref) {
  final isarCollection =
      ref.watch(homeIsarProvider).whenOrNull(data: (collection) => collection);
  return TileManager(isarCollection);
});

class TileManager {
  TileManager(this.isarCollection);

  final IsarCollection<HomeTile>? isarCollection;

  bool canAddElement(int columnCount, int rowCount, int? pageIndex, int column,
      int row, ElementData data) {
    final homeTileCollection = isarCollection;
    if (homeTileCollection != null) {
      final gridTiles =
          homeTileCollection.filter().pageEqualTo(pageIndex).findAllSync();
      final flexibleGridTiles = gridTiles
          .map((e) => FlexibleGridTile(
                column: e.column!,
                row: e.row!,
                columnSpan: e.columnSpan!,
                rowSpan: e.rowSpan!,
              ))
          .toList();
      return canAdd(flexibleGridTiles, columnCount, rowCount, column, row,
          data.columnSpan, data.rowSpan);
    }
    return false;
  }

  Future<void> addElement(int columnCount, int rowCount, int? pageIndex,
      int column, int row, ElementData data) async {
    if (!canAddElement(columnCount, rowCount, pageIndex, column, row, data)) {
      return;
    }
    final homeTileCollection = isarCollection;
    if (homeTileCollection != null) {
      // delete current elements at same position
      await removeElement(pageIndex, column, row);

      // add new element
      final app = data.appData;
      final appWidget = data.appWidgetData;
      final int? widgetId;
      if (app == null && appWidget != null) {
        widgetId = await createApplicationWidget(appWidget.componentName);
      } else {
        widgetId = null;
      }
      final tileToAdd = HomeTile(
          page: pageIndex,
          column: column,
          row: row,
          columnSpan: data.columnSpan,
          rowSpan: data.rowSpan,
          appData: HomeTileAppData(packageName: app?.packageName),
          appWidgetData: HomeTileAppWidgetData(
              componentName: appWidget?.componentName, appWidgetId: widgetId));
      await homeTileCollection.isar
          .writeTxn(() async => await homeTileCollection.put(tileToAdd));
    }
  }

  Future<void> removeElement(int? pageIndex, int column, int row) async {
    final homeTileCollection = isarCollection;
    if (homeTileCollection != null) {
      await homeTileCollection.isar.writeTxn(() async =>
          await homeTileCollection
              .filter()
              .pageEqualTo(pageIndex)
              .columnEqualTo(column)
              .rowEqualTo(row)
              .deleteAll());
    }
  }

  Future<void> removeAll() async {
    final homeTileCollection = isarCollection;
    if (homeTileCollection != null) {
      await homeTileCollection.isar
          .writeTxn(() async => await homeTileCollection.clear());
    }
  }
}
