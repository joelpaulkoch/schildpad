import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/flexible_grid/flexible_grid.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/home/home_view.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

AppData _getTestApp() => AppData(
    icon: const Icon(
      Icons.ac_unit_sharp,
      color: Colors.cyanAccent,
    ),
    name: 'testApp',
    packageName: 'testPackage',
    launch: () {});
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

      final testAppFinder = find.byType(InstalledAppIcon);
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
      final newTestAppFinder = find.byType(InstalledAppIcon);
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
      final testAppFinder = find.byType(InstalledAppIcon);
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
      final newTestAppFinder = find.byType(InstalledAppIcon);
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
      final movedBackTestAppFinder = find.byType(InstalledAppIcon);
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
      final testAppFinder = find.byType(InstalledAppIcon);
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
      final testAppFinder = find.byType(InstalledAppIcon);
      expect(testAppFinder, findsOneWidget);

      // WHEN:
      // I long press
      final longPressDragGesture =
          await tester.startGesture(tester.getCenter(testAppFinder));
      await tester.pumpAndSettle();
      // and drag it to somewhere else
      await longPressDragGesture.moveBy(const Offset(0, 200));
      await tester.pumpAndSettle();

      // THEN:
      // the trash area shows up
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsOneWidget);
    });
    testWidgets(
        'After dropping a dragged app on an empty spot on the home view the trash area should not be shown',
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
      final testAppFinder = find.byType(InstalledAppIcon);
      expect(testAppFinder, findsOneWidget);

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
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'After dropping a dragged app on an occupied spot on the home view the trash area should not be shown',
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
      final testAppFinder = find.byType(InstalledAppIcon);
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
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'After dropping a dragged app in the trash area the trash area should not be shown',
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
                StateController(HomeGridElementData(appData: _getTestApp()))),
      ], child: const MaterialApp(home: HomeView())));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);
      // and there is exactly one app
      final testAppFinder = find.byType(InstalledAppIcon);
      expect(testAppFinder, findsOneWidget);

      // WHEN:
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

      // THEN:
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'Moving an app on the home view to the trash area should remove the app',
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
      final testAppFinder = find.byType(InstalledAppIcon);
      expect(testAppFinder, findsOneWidget);

      // WHEN:
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

      // THEN:
      // it is removed from the home view
      final newTestAppFinder = find.byType(InstalledAppIcon);
      expect(newTestAppFinder, findsNothing);
    });
  });
  group('app widgets', () {
    testWidgets(
        'Using the trash in the context menu should remove the app widget from the home view',
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

      final GoRouter router = GoRouter(
        routes: <GoRoute>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) =>
                const HomeView(),
          ),
        ],
      );

      await tester.pumpWidget(ProviderScope(
          overrides: [
            homeGridTilesProvider(0).overrideWithValue(homeGridStateNotifier),
            homeGridElementDataProvider(const PagedGridCell(0, 0, 0))
                .overrideWithValue(StateController(
                    HomeGridElementData(appWidgetData: testAppWidget))),
            nativeAppWidgetProvider(testAppWidget.appWidgetId!)
                .overrideWithValue(Card(
              color: Colors.deepOrange,
              child: testAppWidget.icon,
            ))
          ],
          child: MaterialApp.router(
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
          )));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);
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
