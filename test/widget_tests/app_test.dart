import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:schildpad/main.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  tearDown(() async {
    tearDownTestHive();
  });
  testWidgets('App starts', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(child: SchildpadApp()));
  });
}
