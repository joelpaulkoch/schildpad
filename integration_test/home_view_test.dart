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
  group('move apps on HomeView tests', () {
    testWidgets('Moving an app on the home view to an empty spot should work',
        (WidgetTester tester) async {
      final testApp = AppData(
          icon: const Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          name: 'testApp',
          packageName: 'testPackage',
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
          packageName: 'testPackage',
          launch: () {});
      final secondTestApp = AppData(
          icon: const Icon(
            Icons.account_balance,
            color: Colors.deepOrange,
          ),
          name: 'secondTestApp',
          packageName: 'testPackage',
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
  group('manage apps on HomeView tests', () {
    testWidgets(
        'Moving an app on the home view to the trash area should remove the app',
        (WidgetTester tester) async {
      final testApp = AppData(
          icon: const Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          name: 'testApp',
          packageName: 'testPackage',
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

      // When:
      // I long press
      final longPressDragGesture =
          await tester.startGesture(tester.getCenter(testAppFinder));
      await tester.pumpAndSettle();
      // and drag it to to the trash area
      final trashAreaFinder = find.byType(TrashArea);
      expect(trashAreaFinder, findsOneWidget);
      await longPressDragGesture.moveTo(tester.getCenter(trashAreaFinder));
      await tester.pumpAndSettle();
      // and drop it there
      await longPressDragGesture.up();
      await tester.pumpAndSettle();

      // Then:
      // it is removed from the home view
      final newTestAppFinder = find.byType(InstalledAppIcon);
      expect(newTestAppFinder, findsNothing);
    });
  });
}
