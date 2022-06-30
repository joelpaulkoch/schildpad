import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schildpad/flexible_grid/flexible_grid.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/home/home_view.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
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

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appData: testApp)))
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
        'After moving an app on the home view to an empty spot it should be possible to move it back',
        (WidgetTester tester) async {
      final testApp = AppData(
          icon: const Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          name: 'testApp',
          packageName: 'testPackage',
          launch: () {});

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appData: testApp)))
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

      // And:
      // When I drag it back to its place inside the grid
      final moveBackGesture = await tester.startGesture(newPosition);
      await tester.pumpAndSettle();
      await moveBackGesture.moveBy(const Offset(50, 0));
      await tester.pumpAndSettle();
      final homeGridPosition = tester.getTopLeft(find.byType(HomeViewGrid));
      await moveBackGesture.moveTo(homeGridPosition + firstPosition);
      await tester.pumpAndSettle();
      await moveBackGesture.up();
      await tester.pumpAndSettle();

      // Then:
      // it is moved back
      final movedBackTestAppFinder = find.byType(InstalledAppIcon);
      expect(movedBackTestAppFinder, findsOneWidget);
      final movedBackPosition = tester.getCenter(movedBackTestAppFinder);
      expect(movedBackPosition, firstPosition);
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

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      ));
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appData: firstTestApp))),
        homeGridElementDataProvider(const GridCell(0, 1)).overrideWithValue(
            StateController(HomeGridElementData(appData: secondTestApp)))
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
  group('trash area', () {
    testWidgets(
        'Moving an app on the home view should cause the trash area to show up',
        (WidgetTester tester) async {
      final testApp = AppData(
          icon: const Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          name: 'testApp',
          packageName: 'testPackage',
          launch: () {});

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appData: testApp)))
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
      // and drag it to somewhere else
      await longPressDragGesture.moveBy(const Offset(0, 200));
      await tester.pumpAndSettle();

      // Then:
      // the trash area shows up
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsOneWidget);
    });
    testWidgets(
        'Dragging an app from the installed apps view to the home view should cause the trash area to show up',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the InstalledAppsView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);

      await tester.fling(homeViewFinder, const Offset(0, -100), 500,
          warnIfMissed: false);
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
      // the trash area shows up
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsOneWidget);
    });
    testWidgets(
        'After dropping a dragged app on an empty spot on the home view the trash area should not be shown',
        (WidgetTester tester) async {
      final testApp = AppData(
          icon: const Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          name: 'testApp',
          packageName: 'testPackage',
          launch: () {});

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appData: testApp)))
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
      // and drag it to somewhere else
      await longPressDragGesture.moveBy(const Offset(0, 200));
      await tester.pumpAndSettle();
      // and drop it there
      await longPressDragGesture.up();
      await tester.pumpAndSettle();

      // Then:
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'After dropping a dragged app on an occupied spot on the home view the trash area should not be shown',
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

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      ));
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appData: firstTestApp))),
        homeGridElementDataProvider(const GridCell(0, 1)).overrideWithValue(
            StateController(HomeGridElementData(appData: secondTestApp)))
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
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'After dropping a dragged app in the trash area the trash area should not be shown',
        (WidgetTester tester) async {
      final testApp = AppData(
          icon: const Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          name: 'testApp',
          packageName: 'testPackage',
          launch: () {});

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appData: testApp))),
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
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'After dropping an app dragged from the installed apps view to the home view on an occupied spot the trash area should not be shown',
        (WidgetTester tester) async {
      final appOnHomeView = AppData(
          icon: const Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          name: 'testApp',
          packageName: 'testPackage',
          launch: () {});

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appData: appOnHomeView))),
      ], child: app.SchildpadApp()));
      await tester.pumpAndSettle();

      // Given:
      // I am on the InstalledAppsView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);

      await tester.fling(homeViewFinder, const Offset(0, -100), 500,
          warnIfMissed: false);
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

      final appFinder = find.byType(InstalledAppIcon);
      expect(appFinder, findsOneWidget);
      // And:
      // I drop it on a spot occupied by an app
      await longPressDragGesture.moveTo(tester.getCenter(appFinder));
      await tester.pumpAndSettle();
      await longPressDragGesture.up();
      await tester.pumpAndSettle();

      // Then:
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsNothing);
    });
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

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 1,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appData: testApp)))
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
  group('app widgets', () {
    testWidgets('Long press on an app widget should show its context menu',
        (WidgetTester tester) async {
      const testAppWidget = AppWidgetData(
          icon: Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          packageName: 'testPackage',
          label: 'testAppWidget',
          preview: Icon(
            Icons.ac_unit_sharp,
            color: Colors.cyanAccent,
          ),
          appName: 'testApp',
          targetWidth: 3,
          targetHeight: 1,
          componentName: 'testComponent',
          minHeight: 0,
          minWidth: 0,
          appWidgetId: 0);

      final homeGridStateNotifier = FlexibleGridStateNotifier(4, 5);
      homeGridStateNotifier.addTile(const FlexibleGridTile(
        column: 0,
        row: 0,
        columnSpan: 3,
        rowSpan: 1,
      ));

      runApp(ProviderScope(overrides: [
        homeGridTilesProvider.overrideWithValue(homeGridStateNotifier),
        homeGridElementDataProvider(const GridCell(0, 0)).overrideWithValue(
            StateController(HomeGridElementData(appWidgetData: testAppWidget))),
        nativeAppWidgetProvider(testAppWidget.appWidgetId!)
            .overrideWithValue(Card(
          color: Colors.deepOrange,
          child: testAppWidget.icon,
        ))
      ], child: app.SchildpadApp()));
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);
      // and there is exactly one app widget
      final testAppWidgetFinder = find.byType(AppWidget);
      expect(testAppWidgetFinder, findsOneWidget);

      // When:
      // I long press
      await tester.longPress(testAppWidgetFinder);
      await tester.pumpAndSettle();

      // Then:
      // its context menu is shown
      final appWidgetContextMenuFinder = find.byType(AppWidgetContextMenu);
      expect(appWidgetContextMenuFinder, findsOneWidget);
    });
  });
}
