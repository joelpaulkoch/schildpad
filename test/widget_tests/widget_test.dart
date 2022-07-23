import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.runAsync(() => setUpHive());
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(child: SchildpadApp()));
  });
}
