import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schildpad/home/home_view.dart';
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
      await tester.fling(homeViewFinder, const Offset(0, 100), 500,
          warnIfMissed: false);
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
      await tester.fling(homeViewFinder, const Offset(0, -100), 500,
          warnIfMissed: false);
      await tester.pumpAndSettle();

      // Then:
      // A list of all installed apps is shown
      expect(find.byType(InstalledAppsView), findsOneWidget);
    });
  });

  group('manage apps on InstalledAppsView tests', () {
    testWidgets(
        'Long pressing app icon from installed apps view should enable drag and drop to home view',
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
      // I can drop it on the HomeView and it is added
      await longPressDragGesture.up();
      await tester.pumpAndSettle();
      expect(homeViewFinder, findsOneWidget);
      expect(installedAppFinder, findsOneWidget);
    });
  });
}
