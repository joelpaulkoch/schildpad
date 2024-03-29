import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/settings/layout_settings.dart';
import 'package:schildpad/settings/settings.dart';

class SettingsScreenRobot {
  SettingsScreenRobot(this.tester);

  final WidgetTester tester;

  Future<void> openLayoutSettings() async {
    final layoutListTileFinder = find.byType(LayoutListTile);
    expect(layoutListTileFinder, findsOneWidget);

    await tester.tap(layoutListTileFinder);
    await tester.pumpAndSettle();
  }

  Future<void> setAppGridColumns(int newColumns) async {
    final columnsListTileFinder = find.byType(AppGridColumnsListTile);
    expect(columnsListTileFinder, findsOneWidget);

    final columnsSwitchFinder = find.descendant(
        of: columnsListTileFinder, matching: find.text('$newColumns'));
    expect(columnsSwitchFinder, findsOneWidget);

    await tester.tap(columnsSwitchFinder, warnIfMissed: false);
  }

  Future<void> setAppGridRows(int newRows) async {
    final rowsListTileFinder = find.byType(AppGridRowsListTile);
    expect(rowsListTileFinder, findsOneWidget);

    final rowsSwitchFinder = find.descendant(
        of: rowsListTileFinder, matching: find.text('$newRows'));
    expect(rowsSwitchFinder, findsOneWidget);

    await tester.tap(rowsSwitchFinder, warnIfMissed: false);
  }

  Future<void> confirmAlertDialog() async {
    final confirmButtonFinder = find.text('Confirm');
    await tester.tap(confirmButtonFinder);
  }

  Future<void> setAppDrawerColumns(int newColumns) async {
    // columns
    final columnsListTileFinder = find.byType(AppDrawerColumnsListTile);
    expect(columnsListTileFinder, findsOneWidget);

    final columnsSwitchFinder = find.descendant(
        of: columnsListTileFinder, matching: find.text('$newColumns'));
    expect(columnsSwitchFinder, findsOneWidget);

    await tester.tap(columnsSwitchFinder, warnIfMissed: false);
  }

  Future<void> setDockColumns(int newColumns) async {
    final columnsListTileFinder = find.byType(DockColumnsListTile);
    expect(columnsListTileFinder, findsOneWidget);

    final columnsSwitchFinder = find.descendant(
        of: columnsListTileFinder, matching: find.text('$newColumns'));
    expect(columnsSwitchFinder, findsOneWidget);

    await tester.tap(columnsSwitchFinder, warnIfMissed: false);
  }

  Future<void> toggleAdditionalDockRow() async {
    final additionalRowListTileFinder = find.byType(DockAdditionalRowListTile);
    expect(additionalRowListTileFinder, findsOneWidget);

    await tester.tap(additionalRowListTileFinder);
  }

  Future<void> toggleTopDock() async {
    final topDockListTileFinder = find.byType(TopDockListTile);
    expect(topDockListTileFinder, findsOneWidget);

    await tester.tap(topDockListTileFinder);
  }
}
