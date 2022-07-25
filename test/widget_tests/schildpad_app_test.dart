import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:schildpad/main.dart';

void main() {
  setUp(() async {
    await setUpHive();
  });
  tearDown(() async {
    await Hive.deleteFromDisk();
  });
  testWidgets('App starts', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(child: SchildpadApp()));
  });
}
