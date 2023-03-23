import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/grid.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/main.dart' as app;
import 'package:schildpad/settings/layout_settings_screen.dart';
import 'package:schildpad/settings/settings_screen.dart';

import 'robot/home_screen_robot.dart';
import 'robot/settings_screen_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() {
    final isar = Isar.getInstance();
    isar?.writeTxnSync(() => isar.clearSync());
  });

  group('layout', () {
    testWidgets('navigating to layout settings screen should be possible',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      final settingsScreenRobot = SettingsScreenRobot(tester);
      await homeScreenRobot.openSettings();

      // Given:
      // I am on the settings screen
      expect(find.byType(SettingsScreen), findsOneWidget);

      // When:
      // I click on the layouts button
      await settingsScreenRobot.openLayoutSettings();

      // Then:
      // a screen containing the layouts settings is opened
      expect(find.byType(LayoutSettingsScreen), findsOneWidget);
    });
    testWidgets('layout settings should allow to change app grid dimensions',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      const defaultColumns = 4;
      const defaultRows = 5;

      final homeScreenRobot = HomeScreenRobot(tester,
          homeGridColumns: defaultColumns, homeGridRows: defaultRows);
      final settingsScreenRobot = SettingsScreenRobot(tester);

      // Given:
      // I have a 4x5 app grid layout
      final homePageFinder = find.byType(HomePage);
      expect(homePageFinder, findsOneWidget);
      final appGridElementsFinder = find.descendant(
          of: homePageFinder, matching: find.byType(GridElement));
      expect(
          appGridElementsFinder, findsNWidgets(defaultColumns * defaultRows));

      // and I am on the layout settings screen
      await homeScreenRobot.openSettings();
      await settingsScreenRobot.openLayoutSettings();
      expect(find.byType(LayoutSettingsScreen), findsOneWidget);

      // When:
      // I set the app grid layout to 5x5
      const newColumns = 5;
      const newRows = 5;
      await settingsScreenRobot.setAppGridLayout(newColumns, newRows);
      await tester.pumpAndSettle();

      // Then:
      // I have a 3x3 app grid on my home screen
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(appGridElementsFinder, findsNWidgets(newColumns * newRows));
    });
  });
}
