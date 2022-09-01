import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/main.dart';

void main() {
  setUp(() async {
    DartPluginRegistrant.ensureInitialized();
    await Hive.initFlutter('schildpad/app_test');
  });
  tearDown(() async {
    await Hive.deleteFromDisk();
  });
  testWidgets('App starts', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(child: SchildpadApp()));
  });
}
