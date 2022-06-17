import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schildpad/home/home_view.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';
import 'package:schildpad/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('navigate to InstalledAppsView tests', () {
    testWidgets('Swiping down should not open InstalledAppsView',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);

      // When:
      // I swipe down
      await tester.fling(homeViewFinder, const Offset(0, 100), 500);
      await tester.pumpAndSettle();

      // Then:
      // InstalledAppsView is not openend
      expect(find.byType(InstalledAppsView), findsNothing);
    });
    testWidgets('Swiping up should open InstalledAppsView',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      // Given:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);

      // When:
      // I swipe up
      await tester.fling(homeViewFinder, const Offset(0, -100), 500);
      await tester.pumpAndSettle();

      // Then:
      // A list of all installed apps is shown
      expect(find.byType(InstalledAppsView), findsOneWidget);
    });
  });

  group('manage apps on HomeView tests', () {
    testWidgets(
        'Long pressing app icon from installed apps list should enable drag and drop to home view',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the InstalledAppsView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);

      await tester.fling(homeViewFinder, const Offset(0, -100), 500);
      await tester.pumpAndSettle();

      final installedAppsViewFinder = find.byType(InstalledAppsView);
      expect(installedAppsViewFinder, findsOneWidget);

      // wait to load apps
      await Future.delayed(const Duration(seconds: 5), () {});
      await tester.pumpAndSettle();

      // When:
      // I long press and drag an InstalledAppButton
      final installedAppFinder = find.byType(InstalledAppIcon).first;
      expect(installedAppFinder, findsOneWidget);

      final longPressDragGesture =
          await tester.startGesture(tester.getCenter(installedAppFinder));
      await tester.pumpAndSettle();

      await longPressDragGesture.moveBy(const Offset(100, 100));
      await tester.pumpAndSettle();

      // Then:
      // I can drop it on the HomeView and it is added
      await longPressDragGesture.up();
      await tester.pumpAndSettle();
      expect(homeViewFinder, findsOneWidget);
      expect(installedAppFinder, findsOneWidget);
    });
    testWidgets('Moving an app on the home view to an empty spot should work',
        (WidgetTester tester) async {
      final testApp = AppData(
          icon: const Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          name: 'testApp',
          launch: () {});

      runApp(ProviderScope(overrides: [
        appProvider(const GridCell(0, 0))
            .overrideWithValue(StateController(testApp))
      ], child: app.SchildpadApp()));
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);
      // and there is exactly one app
      final testAppFinder = find.byType(InstalledAppIcon);
      expect(testAppFinder, findsOneWidget);
      final firstPosition = tester.getCenter(testAppFinder);

      // When:
      // I long press
      final longPressDragGesture =
          await tester.startGesture(tester.getCenter(testAppFinder));
      await tester.pumpAndSettle();
      // and drag it to somewhere else
      await longPressDragGesture.moveBy(const Offset(0, 200));
      await tester.pumpAndSettle();
      // and drop it there
      await longPressDragGesture.up();
      await tester.pumpAndSettle();

      // Then:
      // it is moved to this place
      final newTestAppFinder = find.byType(InstalledAppIcon);
      expect(newTestAppFinder, findsOneWidget);
      final newPosition = tester.getCenter(newTestAppFinder);
      expect(newPosition, isNot(firstPosition));
    });
    testWidgets(
        'Moving an app on the home view to an occupied spot should not work',
        (WidgetTester tester) async {
      final firstTestApp = AppData(
          icon: const Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          name: 'firstTestApp',
          launch: () {});
      final secondTestApp = AppData(
          icon: const Icon(
            Icons.account_balance,
            color: Colors.deepOrange,
          ),
          name: 'secondTestApp',
          launch: () {});

      runApp(ProviderScope(overrides: [
        appProvider(const GridCell(0, 0))
            .overrideWithValue(StateController(firstTestApp)),
        appProvider(const GridCell(0, 1))
            .overrideWithValue(StateController(secondTestApp)),
      ], child: app.SchildpadApp()));
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);
      // and there are two apps
      final testAppFinder = find.byType(InstalledAppIcon);
      expect(testAppFinder, findsNWidgets(2));

      final firstTestAppPosition = tester.getCenter(testAppFinder.first);
      final secondTestAppPosition = tester.getCenter(testAppFinder.at(1));

      // When:
      // I long press the first app
      final longPressDragGesture =
          await tester.startGesture(firstTestAppPosition);
      await tester.pumpAndSettle();
      // and drag it on the other app
      await longPressDragGesture.moveTo(secondTestAppPosition);
      await tester.pumpAndSettle();
      // and drop it there
      await longPressDragGesture.up();
      await tester.pumpAndSettle();

      // Then:
      // it is not moved to this place and everything is still the same
      final newTestAppFinder = find.byType(InstalledAppIcon);
      expect(newTestAppFinder, findsNWidgets(2));
      final newFirstTestAppPosition = tester.getCenter(newTestAppFinder.first);
      final newSecondTestAppPosition = tester.getCenter(newTestAppFinder.at(1));

      expect(newFirstTestAppPosition, firstTestAppPosition);
      expect(newSecondTestAppPosition, secondTestAppPosition);
    });
  });
}
