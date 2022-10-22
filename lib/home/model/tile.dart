import 'package:isar/isar.dart';

part 'tile.g.dart';

@collection
class Tile {
  Id id = Isar.autoIncrement;

  Tile(
      {this.coordinates = defaultCoordinates,
      this.columnSpan = 1,
      this.rowSpan = 1,
      this.tileData});

  GlobalElementCoordinates coordinates;

  int columnSpan;
  int rowSpan;

  ElementData? tileData;
}

enum Location { list, dock, home }

const defaultCoordinates = GlobalElementCoordinates();

@embedded
class GlobalElementCoordinates {
  const GlobalElementCoordinates(
      {this.location = Location.list,
      this.page,
      this.column = 0,
      this.row = 0});

  @enumerated
  final Location location;
  final int? page;
  final int column;
  final int row;
}

@embedded
class ElementData {
  ElementData(
      {this.appData,
      this.appWidgetData,
      this.columnSpan = 1,
      this.rowSpan = 1,
      this.origin = defaultCoordinates});

  final AppData? appData;
  final AppWidgetData? appWidgetData;
  final int columnSpan;
  final int rowSpan;
  final GlobalElementCoordinates origin;
}

@embedded
class AppData {
  const AppData({
    this.packageName = '',
  });

  final String packageName;
}

@embedded
class AppWidgetData {
  const AppWidgetData({
    this.componentName = '',
    this.appWidgetId,
  });

  final String componentName;

  final int? appWidgetId;
}
