import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:schildpad/overview/overview.dart';
import 'package:schildpad/overview/overview_screen.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  tearDown(() async {
    tearDownTestHive();
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
