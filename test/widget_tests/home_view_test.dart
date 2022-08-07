import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/flexible_grid/flexible_grid.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/home/home_view.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_apps/apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

AppData _getTestApp() => const AppData(
      packageName: 'testPackage',
    );

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
  });
  setUp(() async {
    await Hive.openBox<int>(pagesBoxName);
  });
  tearDown(() async {
    await Hive.deleteFromDisk();
  });
  group('move apps on HomeView tests', () {
    testWidgets('Moving an app on the home view to an empty spot should work',
        (WidgetTester tester) async {
      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5)
        ..addTile(const FlexibleGridTile(
          column: 0,
          row: 0,
          columnSpan: 1,
          rowSpan: 1,
        ));

      // GIVEN:
      // I am on the HomeView and there is exactly one app
      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridTilesProvider(0).overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const PagedGridCell(0, 0, 0))
            .overrideWithValue(
                StateController(HomeGridElementData(appData: _getTestApp())))
      ], child: const MaterialApp(home: HomeView())));
      await tester.pumpAndSettle();

      final testAppFinder = find.byType(InstalledAppDraggable);
      final firstPosition = tester.getCenter(testAppFinder);

      // WHEN:
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
      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5)
        ..addTile(const FlexibleGridTile(
          column: 0,
          row: 0,
          columnSpan: 1,
          rowSpan: 1,
        ));

      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridTilesProvider(0).overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const PagedGridCell(0, 0, 0))
            .overrideWithValue(
                StateController(HomeGridElementData(appData: _getTestApp())))
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
      await tester.pumpAndSettle();
      // and drag it to somewhere else
      await longPressDragGesture.moveBy(const Offset(0, 200));
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
      await tester.pumpAndSettle();
      await moveBackGesture.moveBy(const Offset(50, 0));
      await tester.pumpAndSettle();
      final homeGridPosition = tester.getTopLeft(find.byType(HomeViewGrid));
      await moveBackGesture.moveTo(homeGridPosition + firstPosition);
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
      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5)
        ..addTile(const FlexibleGridTile(
          column: 0,
          row: 0,
          columnSpan: 1,
          rowSpan: 1,
        ))
        ..addTile(const FlexibleGridTile(
          column: 0,
          row: 1,
          columnSpan: 1,
          rowSpan: 1,
        ));

      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridTilesProvider(0).overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const PagedGridCell(0, 0, 0))
            .overrideWithValue(
                StateController(HomeGridElementData(appData: _getTestApp()))),
        homeGridElementDataProvider(const PagedGridCell(0, 0, 1))
            .overrideWithValue(
                StateController(HomeGridElementData(appData: _getTestApp())))
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

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5)
        ..addTile(const FlexibleGridTile(
          column: 0,
          row: 0,
          columnSpan: 3,
          rowSpan: 1,
        ));

      await tester.pumpWidget(ProviderScope(
          overrides: [
            homeGridTilesProvider(0).overrideWithValue(homeGridStateNotifier),
            homeGridElementDataProvider(const PagedGridCell(0, 0, 0))
                .overrideWithValue(StateController(
                    HomeGridElementData(appWidgetData: testAppWidget))),
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
      final testAppWidgetFinder = find.byType(AppWidget);
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
    });
  });
}
