import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/settings/settings.dart';

class SettingsScreenRobot {
  SettingsScreenRobot(this.tester);

  final WidgetTester tester;

  Future<void> openLayoutSettings() async {
    final layoutButtonFinder = find.byType(LayoutListTile);
    expect(layoutButtonFinder, findsOneWidget);

    await tester.tap(layoutButtonFinder);
    await tester.pumpAndSettle();
  }
}
