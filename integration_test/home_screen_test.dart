import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';
import 'package:schildpad/main.dart' as app;
import 'package:schildpad/overview/overview_screen.dart';

import 'robot/home_screen_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() async {
    await Hive.deleteFromDisk();
  });
  group('navigate', () {
    testWidgets('Swiping down should not open InstalledAppsView',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);

      // When:
      // I swipe down
      await tester.fling(homeScreenFinder, const Offset(0, 100), 500,
          warnIfMissed: false);
      await tester.pumpAndSettle();

      // Then:
      // InstalledAppsView is not opened
      expect(find.byType(InstalledAppsView).hitTestable(), findsNothing);
    });
    testWidgets('Swiping up should open InstalledAppsView',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();
      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);

      // When:
      // I swipe up
      await tester.fling(homeScreenFinder, const Offset(0, -100), 500,
          warnIfMissed: false);
      await tester.pumpAndSettle();

      // Then:
      // A list of all installed apps is shown
      expect(find.byType(InstalledAppsView), findsOneWidget);
    });
    testWidgets('Long press on HomeScreen should open OverviewScreen',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);

      // When:
      // I do a long press
      await tester.longPress(homeScreenFinder);
      await tester.pumpAndSettle();

      // Then:
      // OverviewScreen is opened
      expect(find.byType(OverviewScreen), findsOneWidget);
    });
  });
  group('move apps', () {
    testWidgets('A dropped app should be added to the home grid',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);

      // When:
      // I drop an app on it
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.openAppList();
      await homeScreenRobot.dragAndDropApp();

      // Then:
      // the app is added to the HomeScreen
      expect(find.byType(AppIcon).hitTestable(), findsOneWidget);
    });
    testWidgets('Dropping an app on the dock should add it to the dock',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);

      // When:
      // I drop an app on the dock
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.addAppToDock(0);

      // Then:
      // the app is added to the dock
      expect(find.byType(AppIcon).hitTestable(), findsOneWidget);
    });
    testWidgets('Moving an app on the home screen to an empty spot should work',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      // and there is exactly one app
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.addAppToHome(0, 0);
      final testAppFinder = find.byType(InstalledAppDraggable).hitTestable();
      expect(testAppFinder, findsOneWidget);
      final firstPosition = tester.getCenter(testAppFinder);

      // When:
      // I move it to an empty spot
      await homeScreenRobot.moveAppTo(testAppFinder, 1, 0);

      // Then:
      // it is moved to this place
      expect(testAppFinder, findsOneWidget);
      final newPosition = tester.getCenter(testAppFinder);
      expect(newPosition, isNot(firstPosition));

      // And:
      // When I drag it back to the first position
      await homeScreenRobot.moveAppTo(testAppFinder, 0, 0);

      // Then:
      // it is moved back
      expect(testAppFinder, findsOneWidget);
      final movedBackPosition = tester.getCenter(testAppFinder);
      expect(movedBackPosition, firstPosition);
    });

    testWidgets(
        'Moving an app on the home screen to an occupied spot should not work',
        (WidgetTester tester) async {
      //TODO reactivate this test when drag detection is fixed
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      // and there are two apps
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.addAppToHome(0, 0);
      await homeScreenRobot.addAppToHome(0, 1);
      final testAppFinder = find.byType(InstalledAppDraggable).hitTestable();
      expect(testAppFinder, findsNWidgets(2));

      final firstTestAppPosition = tester.getCenter(testAppFinder.first);
      final secondTestAppPosition = tester.getCenter(testAppFinder.at(1));

      // When:
      // I move the first app on the second
      await homeScreenRobot.moveAppTo(testAppFinder.first, 0, 1);

      // Then:
      // it is not moved to this place and everything is still the same
      expect(testAppFinder, findsNWidgets(2));
      final newFirstTestAppPosition = tester.getCenter(testAppFinder.first);
      final newSecondTestAppPosition = tester.getCenter(testAppFinder.at(1));

      expect(newFirstTestAppPosition, firstTestAppPosition);
      expect(newSecondTestAppPosition, secondTestAppPosition);
    }, skip: true);

    testWidgets(
        'Moving an app on the home screen to the trash area should remove the app',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      // and there is exactly one app
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.addAppToHome(0, 0);
      final testAppFinder = find.byType(InstalledAppDraggable).hitTestable();
      expect(testAppFinder, findsOneWidget);

      // When:
      // I drag it to to the trash area and drop it there
      await homeScreenRobot.dropAppInTrash(testAppFinder);

      // Then:
      // it is removed from the home screen
      final newTestAppFinder = find.byType(InstalledAppDraggable).hitTestable();
      expect(newTestAppFinder, findsNothing);
    });
  });
  group('trash area', () {
    testWidgets(
        'Moving an app on the home screen should cause the trash area to show up',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      // and there is exactly one app
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.addAppToHome(0, 0);
      final testAppFinder = find.byType(InstalledAppDraggable).hitTestable();
      expect(testAppFinder, findsOneWidget);

      // When:
      // I drag it to somewhere else
      await homeScreenRobot.dragAppBy(testAppFinder, const Offset(0, 200));

      // Then:
      // the trash area shows up
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsOneWidget);
    });
    testWidgets(
        'Dragging an app from the installed apps view to the home screen should cause the trash area to show up',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);

      // When:
      // I drag an app on it
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.openAppList();
      final appFinder = find.byType(InstalledAppDraggable).hitTestable().first;
      expect(appFinder, findsOneWidget);
      await homeScreenRobot.dragAppBy(appFinder, const Offset(200, 200));

      // Then:
      // the trash area shows up
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsOneWidget);
    });
    testWidgets(
        'After dropping a dragged app on an empty spot on the home screen the trash area should not be shown',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);

      // When:
      // I drop an app on it
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.openAppList();
      await homeScreenRobot.dragAndDropApp();

      // Then:
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea).hitTestable();
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'After dropping a dragged app on an occupied spot on the home screen the trash area should not be shown',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      // and there are two apps
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.addAppToHome(0, 0);
      await homeScreenRobot.addAppToHome(0, 1);
      final testAppFinder = find.byType(InstalledAppDraggable).hitTestable();
      expect(testAppFinder, findsNWidgets(2));

      // When:
      // I move the first app on the second
      await homeScreenRobot.moveAppTo(testAppFinder.first, 0, 1);

      // Then:
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea).hitTestable();
      expect(trashFinder, findsNothing);
    }, skip: true);
    testWidgets(
        'After dropping a dragged app in the trash area the trash area should not be shown',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeScreen
      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      // and there is exactly one app
      final homeScreenRobot =
          HomeScreenRobot(tester, homeGridColumns: 4, homeGridRows: 5);
      await homeScreenRobot.addAppToHome(0, 0);
      final testAppFinder = find.byType(InstalledAppDraggable).hitTestable();
      expect(testAppFinder, findsOneWidget);

      // When:
      // I drag it to to the trash area and drop it there
      await homeScreenRobot.dropAppInTrash(testAppFinder);

      // Then:
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea).hitTestable();
      expect(trashFinder, findsNothing);
    });
  });
}
