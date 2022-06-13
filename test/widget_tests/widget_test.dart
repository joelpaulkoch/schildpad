import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(SchildpadApp());
  });
}
