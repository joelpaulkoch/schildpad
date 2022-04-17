import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

void main() {
  testWidgets('InstalledAppsView should give user access to apps',
      (WidgetTester tester) async {
    //Given: the user is on the installed apps view
    await tester.pumpWidget(const InstalledAppsView());

    //When: the user taps on the app icon

    //Then: the user is taken to the app
  });
  testWidgets('InstalledAppsView should give user access to settings',
      (WidgetTester tester) async {
    //Given: the user is on the installed apps view
    await tester.pumpWidget(const InstalledAppsView());

    //When: the user taps the settings button

    //Then: the user should be taken to the settings view
  });
}
