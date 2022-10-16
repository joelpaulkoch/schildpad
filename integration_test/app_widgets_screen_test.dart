import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/installed_app_widgets/app_widgets_screen.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/main.dart' as app;
import 'package:schildpad/overview/overview.dart';
import 'package:schildpad/overview/overview_screen.dart';

import 'robot/app_widgets_screen_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('add app widgets to home view', () {
    testWidgets(
        'Long pressing an app widget from installed app widgets view should enable drag and drop to home view',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      await tester.longPress(homeScreenFinder);
      await tester.pumpAndSettle();
      expect(find.byType(OverviewScreen), findsOneWidget);
      final showAppWidgetsButtonFinder = find.byType(ShowAppWidgetsButton);
      expect(showAppWidgetsButtonFinder, findsOneWidget);
      await tester.tap(showAppWidgetsButtonFinder);
      await tester.pumpAndSettle();

      // Given:
      // I am on the AppWidgetsScreen
      final appWidgetsScreenFinder = find.byType(AppWidgetsScreen);
      expect(appWidgetsScreenFinder, findsOneWidget);
      final appWidgetScreenRobot =
          AppWidgetsScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);

      // wait to load widgets
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // When:
      // I add an app widget to the home screen
      await appWidgetScreenRobot.addAppWidget(0, 0);

      // Then:
      // it is added to the home screen
      expect(homeScreenFinder, findsOneWidget);
      // wait to load widget
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(AppWidget), findsOneWidget);
    }, skip: true);
  });
}
