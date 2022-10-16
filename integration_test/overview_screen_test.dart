import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/installed_app_widgets/app_widgets_screen.dart';
import 'package:schildpad/main.dart' as app;
import 'package:schildpad/overview/overview.dart';
import 'package:schildpad/overview/overview_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('navigate', () {
    testWidgets('Button on OverviewScreen should open appwidgets screen',
        (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle();

      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);
      await tester.longPress(homeScreenFinder);
      await tester.pumpAndSettle();

      // Given:
      // I am on the OverviewScreen
      expect(find.byType(OverviewScreen), findsOneWidget);

      // When:
      // I press the app widgets button
      final appWidgetsButtonFinder = find.byType(ShowAppWidgetsButton);
      expect(appWidgetsButtonFinder, findsOneWidget);
      await tester.tap(appWidgetsButtonFinder);
      await tester.pumpAndSettle();

      // Then:
      // AppWidgetsScreen is opened
      expect(find.byType(AppWidgetsScreen), findsOneWidget);
    });
  });
}
