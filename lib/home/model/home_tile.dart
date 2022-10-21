import 'package:isar/isar.dart';

part 'home_tile.g.dart';

//TODO remove nullables
@collection
class HomeTile {
  Id id = Isar.autoIncrement;

  HomeTile(
      {this.coordinates,
      this.columnSpan,
      this.rowSpan,
      this.appData,
      this.appWidgetData});

  GlobalElementCoordinates? coordinates;

  int? columnSpan;
  int? rowSpan;

  HomeTileAppData? appData;
  HomeTileAppWidgetData? appWidgetData;
}

@embedded
class HomeTileAppData {
  const HomeTileAppData({
    this.packageName,
  });

  final String? packageName;
}

@embedded
class HomeTileAppWidgetData {
  const HomeTileAppWidgetData({
    this.componentName,
    this.appWidgetId,
  });

  final String? componentName;

  final int? appWidgetId;
}

@embedded
class GlobalElementCoordinates {
  GlobalElementCoordinates(
      {this.location = Location.list, this.page, this.column, this.row});

  @enumerated
  Location location;
  int? page;
  int? column;
  int? row;
}

enum Location { list, dock, home }
