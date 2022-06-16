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

  group('add to HomeView tests', () {
    testWidgets(
        'Long pressing app icon should enable drag and drop to home view',
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
      // expect(installedAppsViewFinder, findsOneWidget);

      // When:
      // I swipe up

      // Then:
      // A list of all installed apps is shown
    });
  });
}
