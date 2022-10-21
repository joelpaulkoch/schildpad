import 'package:isar/isar.dart';

part 'home_tile.g.dart';

@collection
class HomeTile {
  Id id = Isar.autoIncrement;

  HomeTile(
      {this.page,
      this.column,
      this.row,
      this.columnSpan,
      this.rowSpan,
      this.appData,
      this.appWidgetData});

  int? page;
  int? column;
  int? row;

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
