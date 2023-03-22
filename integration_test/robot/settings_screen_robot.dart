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
    final appGridListTileFinder = find.byType(AppGridHeadingListTile);
    expect(appGridListTileFinder, findsOneWidget);

    await tester.tap(appGridListTileFinder);
  }
}
