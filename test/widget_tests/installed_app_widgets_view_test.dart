import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets_view.dart';

void main() {
  testWidgets('AppWidgetsList should show widgets',
      (WidgetTester tester) async {
    // GIVEN: A list containing a app widget
    const firstAppWidget = AppWidgetData(
        icon: Icon(Icons.account_balance),
        label: 'firstWidget',
        packageName: 'com.widget.first',
        componentName: 'firstComp');
    final appWidgetsList = [firstAppWidget];

    // WHEN: we visualize it using AppWidgetsList
    await tester.pumpWidget(ProviderScope(overrides: [
      installedAppWidgetsProvider.overrideWithValue(AsyncData(appWidgetsList))
    ], child: const MaterialApp(home: AppWidgetsList())));

    //THEN: the widgets icon and label are shown
    final firstAppWidgetIconFinder = find.text(firstAppWidget.label);
    expect(firstAppWidgetIconFinder, findsOneWidget);
    final firstAppWidgetLabelFinder = find.text(firstAppWidget.label);
    expect(firstAppWidgetLabelFinder, findsOneWidget);
  });
  testWidgets('AppWidgetsList should show app widgets grouped by app',
      (WidgetTester tester) async {
    // GIVEN: A list of app widgets from different apps
    const firstAppWidget = AppWidgetData(
        icon: Icon(Icons.account_balance),
        label: 'firstWidget',
        packageName: 'com.widget.first',
        componentName: 'firstComp');
    const secondAppWidget = AppWidgetData(
        icon: Icon(Icons.add_business),
        label: 'secondWidget',
        packageName: 'com.widget.second',
        componentName: 'secondComp');
    final appWidgetsList = [firstAppWidget, secondAppWidget];

    // WHEN: we visualize them using AppWidgetsList
    await tester.pumpWidget(ProviderScope(overrides: [
      installedAppWidgetsProvider.overrideWithValue(AsyncData(appWidgetsList))
    ], child: const MaterialApp(home: AppWidgetsList())));

    //THEN: they are shown grouped by app
    final firstAppWidgetFinder = find.text(firstAppWidget.label);
    final secondAppWidgetFinder = find.text(secondAppWidget.label);
  });
}
