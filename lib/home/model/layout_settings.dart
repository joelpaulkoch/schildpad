import 'package:isar/isar.dart';

part 'layout_settings.g.dart';

@collection
class LayoutSettings {
  LayoutSettings(
      {this.appGridColumns = 4,
      this.appGridRows = 5,
      this.appDrawerColumns = 3,
      this.dockColumns = 4,
      this.additionalDockRow = false,
      this.topDock = false});

  Id id = 0;
  int appGridColumns;
  int appGridRows;
  int appDrawerColumns;
  int dockColumns;
  bool additionalDockRow;
  bool topDock;

  LayoutSettings copyWith(
      {int? appGridColumns,
      int? appGridRows,
      int? appDrawerColumns,
      int? dockColumns,
      bool? additionalDockRow,
      bool? topDock}) {
    return LayoutSettings(
        appGridColumns: appGridColumns ?? this.appGridColumns,
        appGridRows: appGridRows ?? this.appGridRows,
        appDrawerColumns: appDrawerColumns ?? this.appDrawerColumns,
        dockColumns: dockColumns ?? this.dockColumns,
        additionalDockRow: additionalDockRow ?? this.additionalDockRow,
        topDock: topDock ?? this.topDock);
  }
}
