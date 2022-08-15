import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_apps/apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

ElementData _getTestApp(int page, int col, int row) => ElementData(
      appData: const AppData(
        packageName: 'testPackage',
      ),
      columnSpan: 1,
      rowSpan: 1,
      originPageIndex: page,
      originColumn: col,
      originRow: row,
    );

main() {
  setUpAll(() async {
    await Hive.initFlutter('schildpad/home_test');
  });
  setUp(() async {});
  tearDown(() async {});
  tearDownAll(() async {});

  group('move apps on HomeView tests', () {
    testWidgets('Moving an app on the home view to an empty spot should work',
        (WidgetTester tester) async {
      final homeGridStateNotifier = HomeGridStateNotifier(0, 4, 5)
        ..removeAll()
        ..addElement(0, 0, _getTestApp(0, 0, 0));

      // GIVEN:
      // I am on the HomeView and there is exactly one app
      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridStateProvider(0).overrideWithValue(homeGridStateNotifier),
      ], child: const MaterialApp(home: HomeView())));
      await tester.pumpAndSettle();

      final testAppFinder = find.byType(InstalledAppDraggable);
      final firstPosition = tester.getCenter(testAppFinder);

      // WHEN:
      // I long press
      final longPressDragGesture =
          await tester.startGesture(tester.getCenter(testAppFinder));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      // and drag it to somewhere else
      final emptyGridCellFinder = find.byType(HomeGridEmptyCell);
      expect(emptyGridCellFinder, findsWidgets);
      await longPressDragGesture
          .moveTo(tester.getCenter(emptyGridCellFinder.first));
      await tester.pumpAndSettle();

      // and drop it there
      await longPressDragGesture.up();
      await tester.pumpAndSettle();

      // THEN:
      // the app is moved to this place
      final newTestAppFinder = find.byType(InstalledAppDraggable);
      final newPosition = tester.getCenter(newTestAppFinder);
      expect(newTestAppFinder, findsOneWidget);
      expect(newPosition, isNot(firstPosition));
    });
    testWidgets(
        'After moving an app on the home view to an empty spot it should be possible to move it back',
        (WidgetTester tester) async {
      final homeGridStateNotifier = HomeGridStateNotifier(0, 2, 1)
        ..removeAll()
        ..addElement(0, 0, _getTestApp(0, 0, 0));

      await tester.pumpWidget(ProviderScope(overrides: [
        homeColumnCountProvider.overrideWithValue(2),
        homeRowCountProvider.overrideWithValue(1),
        homeGridStateProvider(0).overrideWithValue(homeGridStateNotifier),
      ], child: const MaterialApp(home: HomeView())));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);
      // and there is exactly one app
      final testAppFinder = find.byType(InstalledAppDraggable);
      expect(testAppFinder, findsOneWidget);
      final firstPosition = tester.getCenter(testAppFinder);

      // WHEN:
      // I long press
      final longPressDragGesture =
          await tester.startGesture(tester.getCenter(testAppFinder));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      // and drag it to somewhere else
      final emptyGridCellFinder = find.byType(HomeGridEmptyCell);
      expect(emptyGridCellFinder, findsWidgets);

      await longPressDragGesture
          .moveTo(tester.getCenter(emptyGridCellFinder.first));
      await tester.pumpAndSettle();
      // and drop it there
      await longPressDragGesture.up();
      await tester.pumpAndSettle();

      // THEN:
      // it is moved to this place
      final newTestAppFinder = find.byType(InstalledAppDraggable);
      expect(newTestAppFinder, findsOneWidget);
      final newPosition = tester.getCenter(newTestAppFinder);
      expect(newPosition, isNot(firstPosition));

      // And:
      // WHEN I drag it back to its place inside the grid
      final moveBackGesture = await tester.startGesture(newPosition);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await moveBackGesture.moveTo(firstPosition);
      await tester.pumpAndSettle();
      await moveBackGesture.up();
      await tester.pumpAndSettle();

      // THEN:
      // it is moved back
      final movedBackTestAppFinder = find.byType(InstalledAppDraggable);
      expect(movedBackTestAppFinder, findsOneWidget);
      final movedBackPosition = tester.getCenter(movedBackTestAppFinder);
      expect(movedBackPosition, firstPosition);
    });
    testWidgets(
        'Moving an app on the home view to an occupied spot should not work',
        (WidgetTester tester) async {
      final homeGridStateNotifier = HomeGridStateNotifier(0, 4, 5)
        ..removeAll()
        ..addElement(0, 0, _getTestApp(0, 0, 0))
        ..addElement(0, 1, _getTestApp(0, 0, 1));

      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridStateProvider(0).overrideWithValue(homeGridStateNotifier),
      ], child: const MaterialApp(home: HomeView())));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);
      // and there are two apps
      final testAppFinder = find.byType(InstalledAppDraggable);
      expect(testAppFinder, findsNWidgets(2));

      final firstTestAppPosition = tester.getCenter(testAppFinder.first);
      final secondTestAppPosition = tester.getCenter(testAppFinder.at(1));

      // WHEN:
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

      // THEN:
      // it is not moved to this place and everything is still the same
      final newTestAppFinder = find.byType(InstalledAppDraggable);
      expect(newTestAppFinder, findsNWidgets(2));
      final newFirstTestAppPosition = tester.getCenter(newTestAppFinder.first);
      final newSecondTestAppPosition = tester.getCenter(newTestAppFinder.at(1));

      expect(newFirstTestAppPosition, firstTestAppPosition);
      expect(newSecondTestAppPosition, secondTestAppPosition);
    });
  });
  group('app widgets', () {
    testWidgets(
        'Using the trash in the context menu should remove the app widget from the home view',
        (WidgetTester tester) async {
      const testAppWidget =
          AppWidgetData(componentName: 'testComponent', appWidgetId: 0);

      final homeGridStateNotifier = HomeGridStateNotifier(0, 4, 5)
        ..removeAll()
        ..addElement(
            0,
            0,
            ElementData(
                appWidgetData: testAppWidget, columnSpan: 3, rowSpan: 1));

      await tester.pumpWidget(ProviderScope(
          overrides: [
            homeGridStateProvider(0).overrideWithValue(homeGridStateNotifier),
            nativeAppWidgetProvider(testAppWidget.appWidgetId!)
                .overrideWithValue(const Card(
              color: Colors.deepOrange,
              child: Icon(
                Icons.ac_unit_sharp,
                color: Colors.cyanAccent,
              ),
            ))
          ],
          child: const MaterialApp(
            home: HomeView(),
          )));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeView
      // and there is exactly one app widget
      final testAppWidgetFinder = find.byType(HomeGridWidget);
      expect(testAppWidgetFinder, findsOneWidget);

      // And:
      // I open the context menu and click on the trash button
      await tester.longPress(testAppWidgetFinder);
      await tester.pumpAndSettle();
      final trashButtonFinder = find.byIcon(Icons.delete_outline_rounded);
      expect(trashButtonFinder, findsOneWidget);
      await tester.press(trashButtonFinder);
      await tester.pumpAndSettle();

      // THEN:
      // the app widget is removed from the home view
      expect(testAppWidgetFinder, findsNothing);
    }, skip: true);
  });
}
