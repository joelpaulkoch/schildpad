import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/flexible_grid.dart';
import 'package:schildpad/home/model/tile.dart';
import 'package:schildpad/installed_app_widgets/installed_application_widgets.dart';
import 'package:schildpad/main.dart';

final isarTilesProvider = FutureProvider<IsarCollection<Tile>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return isar.tiles;
});

final isarTilesUpdateProvider = StreamProvider<void>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield* isar.tiles.watchLazy();
});

final tileProvider =
    Provider.family<Tile, GlobalElementCoordinates>((ref, globalCoordinates) {
  ref.watch(isarTilesUpdateProvider);
  final tiles = ref.watch(isarTilesProvider).whenOrNull(data: (tiles) => tiles);

  final tile = tiles
      ?.filter()
      .coordinates((q) => q
          .locationEqualTo(globalCoordinates.location)
          .pageEqualTo(globalCoordinates.page)
          .columnEqualTo(globalCoordinates.column)
          .rowEqualTo(globalCoordinates.row))
      .findFirstSync();

  return tile ?? Tile(coordinates: globalCoordinates);
});

final tileManagerProvider = Provider<TileManager>((ref) {
  final isarCollection =
      ref.watch(isarTilesProvider).whenOrNull(data: (collection) => collection);
  return TileManager(isarCollection);
});

class TileManager {
  TileManager(this.isarCollection);

  final IsarCollection<Tile>? isarCollection;

  bool canAddElement(int columnCount, int rowCount,
      GlobalElementCoordinates coordinates, ElementData data) {
    final homeTileCollection = isarCollection;
    if (homeTileCollection != null) {
      final gridTiles = homeTileCollection
          .filter()
          .coordinates((c) => c
              .locationEqualTo(coordinates.location)
              .pageEqualTo(coordinates.page)
              .columnEqualTo(coordinates.column)
              .rowEqualTo(coordinates.row))
          .findAllSync();
      final flexibleGridTiles = gridTiles
          .map((e) => FlexibleGridTile(
                column: e.coordinates.column,
                row: e.coordinates.row,
                columnSpan: e.columnSpan,
                rowSpan: e.rowSpan,
              ))
          .toList();
      return canAdd(flexibleGridTiles, columnCount, rowCount,
          coordinates.column, coordinates.row, data.columnSpan, data.rowSpan);
    }
    return false;
  }

  Future<void> addElement(int columnCount, int rowCount,
      GlobalElementCoordinates coordinates, ElementData data) async {
    if (!canAddElement(columnCount, rowCount, coordinates, data)) {
      return;
    }
    final homeTileCollection = isarCollection;
    if (homeTileCollection != null) {
      // delete current elements at same position
      await removeElement(coordinates);

      // add new element
      final app = data.appData;
      final appWidget = data.appWidgetData;
      final int? widgetId;
      if (app == null && appWidget != null) {
        widgetId = await createApplicationWidget(appWidget.componentName);
      } else {
        widgetId = null;
      }
      final tileToAdd = Tile(
        coordinates: coordinates,
        columnSpan: data.columnSpan,
        rowSpan: data.rowSpan,
        tileData: ElementData(
            columnSpan: data.columnSpan,
            rowSpan: data.rowSpan,
            origin: coordinates,
            appData: app,
            appWidgetData: AppWidgetData(
                componentName: appWidget?.componentName ?? '',
                appWidgetId: widgetId)),
      );
      await homeTileCollection.isar
          .writeTxn(() async => await homeTileCollection.put(tileToAdd));
    }
  }

  Future<void> removeElement(GlobalElementCoordinates coordinates) async {
    final homeTileCollection = isarCollection;
    if (homeTileCollection != null) {
      await homeTileCollection.isar.writeTxn(() async =>
          await homeTileCollection
              .filter()
              .coordinates((q) => q
                  .locationEqualTo(coordinates.location)
                  .pageEqualTo(coordinates.page)
                  .columnEqualTo(coordinates.column)
                  .rowEqualTo(coordinates.row))
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
