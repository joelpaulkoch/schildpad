import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schildpad/home/home_view.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';
import 'package:schildpad/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('basic InstalledAppsView tests', () {
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
      await tester.drag(homeViewFinder, const Offset(0, 500));
      await tester.pumpAndSettle();

      // Then:
      // A list of all installed apps is shown
      expect(find.byType(InstalledAppsView), findsOneWidget);
    });
  });
}
