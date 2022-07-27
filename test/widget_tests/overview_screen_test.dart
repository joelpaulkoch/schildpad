import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/overview/overview_screen.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
  });
  setUp(() async {
    await Hive.openBox<int>(pagesBoxName);
  });
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
    expect(find.byType(AddPageButton), findsNWidgets(2));
  });
}