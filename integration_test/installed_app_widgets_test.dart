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
}
