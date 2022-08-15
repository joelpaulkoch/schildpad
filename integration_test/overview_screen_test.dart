import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/main.dart' as app;
import 'package:schildpad/overview/overview_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Long press on HomeScreen should open OverviewScreen',
      (WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle();

    // Given:
    // I am on the HomeView
    final homeScreenFinder = find.byType(HomeScreen);
    expect(homeScreenFinder, findsOneWidget);

    // When:
    // I do a long press
    await tester.longPress(homeScreenFinder);
    await tester.pumpAndSettle();

    // Then:
    // OverviewScreen is opened
    expect(find.byType(OverviewScreen), findsOneWidget);
  });
}
