import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/overview/overview.dart';
import 'package:schildpad/overview/overview_screen.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter('schildpad/overview_screen_test');
  });
  setUp(() async {});
  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('Overview shows up', (WidgetTester tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OverviewScreen())));
  });

  testWidgets('Overview shows two add pages buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OverviewScreen())));
    expect(find.byType(AddLeftPageButton), findsOneWidget);
    expect(find.byType(AddRightPageButton), findsOneWidget);
  });
}
