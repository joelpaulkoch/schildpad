import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar/isar.dart';
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
  });
}
