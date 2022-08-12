import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_apps/apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

HomeGridElementData _getTestApp(int page, int col, int row) =>
    HomeGridElementData(
      appData: const AppData(
        packageName: 'testPackage',
      ),
      columnSpan: 1,
      rowSpan: 1,
      originPageIndex: page,
      originColumn: col,
      originRow: row,
    );

void main() {
  setUpAll(() async {
    await Hive.initFlutter('schildpad/home_screen_test');
  });
  setUp(() async {
    await Hive.openBox<int>(pagesBoxName);
    await Hive.openBox<String>(getHiveBoxName(0));
  });
  tearDown(() async {});
  group('trash area', () {
    testWidgets(
        'Moving an app on the home view should cause the trash area to show up',
        (WidgetTester tester) async {
      final homeGridStateNotifier = HomeGridStateNotifier(0, 4, 5)
        ..addElement(0, 0, _getTestApp(0, 0, 0));

      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridStateProvider(0).overrideWithValue(homeGridStateNotifier),
      ], child: const MaterialApp(home: HomeScreen())));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeScreen
      // and there is exactly one app
      final testAppFinder = find.byType(InstalledAppDraggable);
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
      final homeGridStateNotifier = HomeGridStateNotifier(0, 4, 5)
        ..addElement(0, 0, _getTestApp(0, 0, 0));

      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridStateProvider(0).overrideWithValue(homeGridStateNotifier),
      ], child: const MaterialApp(home: HomeScreen())));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeScreen
      // and there is exactly one app
      final testAppFinder = find.byType(InstalledAppDraggable);
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
      final homeGridStateNotifier = HomeGridStateNotifier(0, 4, 5)
        ..addElement(0, 0, _getTestApp(0, 0, 0))
        ..addElement(0, 1, _getTestApp(0, 0, 1));

      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridStateProvider(0).overrideWithValue(homeGridStateNotifier),
      ], child: const MaterialApp(home: HomeScreen())));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeScreen
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
      // the trash area is not shown
      final trashFinder = find.byType(TrashArea);
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'After dropping a dragged app in the trash area the trash area should not be shown',
        (WidgetTester tester) async {
      final homeGridStateNotifier = HomeGridStateNotifier(0, 4, 5)
        ..addElement(0, 0, _getTestApp(0, 0, 0));

      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridStateProvider(0).overrideWithValue(homeGridStateNotifier),
      ], child: const MaterialApp(home: HomeScreen())));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeScreen
      // and there is exactly one app
      final testAppFinder = find.byType(InstalledAppDraggable);
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
      final homeGridStateNotifier = HomeGridStateNotifier(0, 4, 5)
        ..addElement(0, 0, _getTestApp(0, 0, 0));

      await tester.pumpWidget(ProviderScope(overrides: [
        homeGridStateProvider(0).overrideWithValue(homeGridStateNotifier),
      ], child: const MaterialApp(home: HomeScreen())));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeScreen
      // and there is exactly one app
      final testAppFinder = find.byType(InstalledAppDraggable);
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
      final newTestAppFinder = find.byType(InstalledAppDraggable);
      expect(newTestAppFinder, findsNothing);
    });
  });
}
