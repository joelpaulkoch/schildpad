import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SchildpadApp());

    expect(find.text('this is home'), findsOneWidget);
  });
}
