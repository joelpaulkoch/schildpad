import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  tearDown(() async {
    tearDownTestHive();
  });
  group('trash area', () {
    testWidgets(
        'Moving an app on the home view should cause the trash area to show up',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(
          overrides: [], child: MaterialApp(home: HomeScreen())));
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
      await tester.pumpWidget(const ProviderScope(
          overrides: [], child: MaterialApp(home: HomeScreen())));
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
      final trashFinder = find.byType(TrashArea).hitTestable();
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'After dropping a dragged app on an occupied spot on the home view the trash area should not be shown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(
          overrides: [], child: MaterialApp(home: HomeScreen())));
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
      final trashFinder = find.byType(TrashArea).hitTestable();
      expect(trashFinder, findsNothing);
    });
    testWidgets(
        'After dropping a dragged app in the trash area the trash area should not be shown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(
          overrides: [], child: MaterialApp(home: HomeScreen())));
      await tester.pumpAndSettle();

      // GIVEN:
      // I am on the HomeScreen
      // and there is exactly one app
      final testAppFinder = find.byType(InstalledAppDraggable).hitTestable();
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
      final trashFinder = find.byType(TrashArea).hitTestable();
      expect(trashFinder, findsNothing);
    });
  }, skip: true);
}
