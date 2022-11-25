import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/installed_app_widgets/app_widgets_screen.dart';
import 'package:schildpad/main.dart' as app;
import 'package:schildpad/overview/overview.dart';
import 'package:schildpad/overview/overview_screen.dart';

import 'robot/overview_screen_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() {
    final isar = Isar.getInstance();
    isar?.writeTxnSync(() => isar.clearSync());
  });
  group('navigate', () {
    testWidgets('navigating to appwidgets screen should be possible',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      await tester.longPress(homeScreenFinder);
      await tester.pumpAndSettle();

      // Given:
      // I am on the overview screen
      expect(find.byType(OverviewScreen), findsOneWidget);

      // When:
      // I open the appwidgets screen
      final overviewScreenRobot = OverviewScreenRobot(tester);
      await overviewScreenRobot.openAppWidgetsScreen();

      // Then:
      // it is opened
      expect(find.byType(AppWidgetsScreen), findsOneWidget);
    });
  });
  group('pages', () {
    testWidgets('adding a page should be possible',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      await tester.longPress(homeScreenFinder);
      await tester.pumpAndSettle();

      // Given:
      // I am on the overview screen
      expect(find.byType(OverviewScreen), findsOneWidget);
      // and there is only one page
      final pageFinder = find.byType(MoveToRightButton);
      expect(pageFinder, findsNothing);

      // When:
      // I add a page
      final overviewScreenRobot = OverviewScreenRobot(tester);
      await overviewScreenRobot.addPageOnRightSide();
      await tester.pumpAndSettle();

      // Then:
      // there are two pages
      expect(pageFinder, findsOneWidget);
    });
    testWidgets('deleting an outer page should be possible',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      await tester.longPress(homeScreenFinder);
      await tester.pumpAndSettle();

      // Given:
      // I am on the overview screen
      expect(find.byType(OverviewScreen), findsOneWidget);
      // and there are two pages
      final overviewScreenRobot = OverviewScreenRobot(tester);
      await overviewScreenRobot.addPageOnRightSide();
      await tester.pumpAndSettle();
      final pageFinder = find.byType(MoveToRightButton);
      expect(pageFinder, findsOneWidget);

      // When:
      // I delete the outer page
      await overviewScreenRobot.moveToRightPage();
      await overviewScreenRobot.deletePage();

      // Then:
      // there there is only one page left
      expect(pageFinder, findsNothing);
    });
  });
}
