import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schildpad/home/home_view.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets_view.dart';
import 'package:schildpad/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('navigate to InstalledAppWidgetsView tests', () {
    testWidgets('Long press should open InstalledAppWidgetsView',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the HomeView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);

      // When:
      // I do a long press
      await tester.longPress(homeViewFinder);
      await tester.pumpAndSettle();

      // Then:
      // InstalledAppWidgetsView is opened
      expect(find.byType(InstalledAppWidgetsView), findsOneWidget);
    });
  });
  group('add app widgets to home view', () {
    testWidgets(
        'Long pressing an app widget from installed app widgets view should enable drag and drop to home view',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Given:
      // I am on the InstalledAppWidgetsView
      final homeViewFinder = find.byType(HomeView);
      expect(homeViewFinder, findsOneWidget);

      await tester.longPress(homeViewFinder);
      await tester.pumpAndSettle();

      final installedAppWidgetsViewFinder =
          find.byType(InstalledAppWidgetsView);
      expect(installedAppWidgetsViewFinder, findsOneWidget);

      // wait to load widgets
      await Future.delayed(const Duration(seconds: 5), () {});
      await tester.pumpAndSettle();

      // When:
      // I long press and drag an app widget
      final installedAppWidgetFinder = find.byType(Card).first;
      expect(installedAppWidgetFinder, findsOneWidget);

      final longPressDragGesture =
          await tester.startGesture(tester.getCenter(installedAppWidgetFinder));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1), () {});
      await tester.pumpAndSettle();

      await longPressDragGesture.moveBy(const Offset(0, 300));
      await tester.pumpAndSettle();

      // Then:
      // I can drop it on the HomeView and it is added
      await longPressDragGesture.up();
      await tester.pumpAndSettle();

      expect(homeViewFinder, findsOneWidget);
      expect(installedAppWidgetFinder, findsOneWidget);
    });
  });
}
