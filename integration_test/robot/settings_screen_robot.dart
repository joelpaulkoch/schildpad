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

  Future<void> setAppGridLayout(int newColumns, int newRows) async {
    // columns
    final columnsListTileFinder = find.byType(AppGridColumnsListTile);
    expect(columnsListTileFinder, findsOneWidget);

    final columnsSwitchFinder = find.descendant(
        of: columnsListTileFinder, matching: find.text('$newColumns'));
    expect(columnsSwitchFinder, findsOneWidget);

    await tester.tap(columnsSwitchFinder);

    // rows
    final rowsListTileFinder = find.byType(AppGridRowsListTile);
    expect(rowsListTileFinder, findsOneWidget);

    final rowsSwitchFinder = find.descendant(
        of: rowsListTileFinder, matching: find.text('$newRows'));
    expect(rowsSwitchFinder, findsOneWidget);

    await tester.tap(rowsSwitchFinder);
  }
}
