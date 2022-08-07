import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/installed_app_widgets/app_widgets.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets_view.dart';
import 'package:schildpad/installed_apps/apps.dart';

void main() {
  testWidgets('AppWidgetsList should show widgets',
      (WidgetTester tester) async {
    // GIVEN: A list containing a app widget
    const testAppPackage = 'com.test.app';
    const testAppLabel = 'testApp';
    const testAppWidgetId = 'com.test.app.widget';
    const testAppWidgetPreview = Icon(Icons.account_balance);

    // WHEN: we visualize it using AppWidgetsList
    await tester.pumpWidget(ProviderScope(overrides: [
      appsWithWidgetsProvider.overrideWithValue(AsyncData([testAppPackage])),
      appLabelProvider(testAppPackage)
          .overrideWithValue(AsyncData(testAppLabel)),
      appPackageApplicationWidgetIdsProvider(testAppPackage)
          .overrideWithValue(AsyncData([testAppWidgetId])),
      appWidgetPreviewProvider(testAppPackage)
          .overrideWithValue(AsyncData(testAppWidgetPreview))
    ], child: const MaterialApp(home: AppWidgetsList())));

    //THEN: the widgets icon and label are shown
    final firstAppWidgetIconFinder = find.text(testAppLabel);
    expect(firstAppWidgetIconFinder, findsOneWidget);
    final firstAppWidgetLabelFinder = find.text(testAppLabel);
    expect(firstAppWidgetLabelFinder, findsOneWidget);
  });
  testWidgets('AppWidgetsList should show app widgets grouped by app',
      (WidgetTester tester) async {
    // GIVEN: A list of app widgets from different apps
    const firstTestAppPackage = 'com.first.app';
    const firstTestAppLabel = 'firstTestApp';
    const firstTestAppWidgetId = 'com.first.app.widget';
    const firstTestAppWidgetPreview = Icon(Icons.account_balance);

    const secondTestAppPackage = 'com.second.app';
    const secondTestAppLabel = 'secondTestApp';
    const secondTestAppWidgetId = 'com.second.app.widget';
    const secondTestAppWidgetPreview = Icon(Icons.access_alarms_rounded);

    // WHEN: we visualize them using AppWidgetsList
    await tester.pumpWidget(ProviderScope(overrides: [
      appsWithWidgetsProvider.overrideWithValue(
          AsyncData([firstTestAppPackage, secondTestAppPackage])),
      appLabelProvider(firstTestAppPackage)
          .overrideWithValue(AsyncData(firstTestAppLabel)),
      appPackageApplicationWidgetIdsProvider(firstTestAppPackage)
          .overrideWithValue(AsyncData([firstTestAppWidgetId])),
      appWidgetPreviewProvider(firstTestAppPackage)
          .overrideWithValue(AsyncData(firstTestAppWidgetPreview)),
      appLabelProvider(secondTestAppPackage)
          .overrideWithValue(AsyncData(secondTestAppLabel)),
      appPackageApplicationWidgetIdsProvider(secondTestAppPackage)
          .overrideWithValue(AsyncData([secondTestAppWidgetId])),
      appWidgetPreviewProvider(secondTestAppPackage)
          .overrideWithValue(AsyncData(secondTestAppWidgetPreview))
    ], child: const MaterialApp(home: AppWidgetsList())));

    //THEN: they are shown grouped by app
    final firstAppWidgetFinder = find.text(firstTestAppLabel);
    expect(firstAppWidgetFinder, findsOneWidget);
    final firstAppGroupFinder = find.ancestor(
        of: firstAppWidgetFinder,
        matching:
            find.widgetWithText(AppWidgetGroupListTile, firstTestAppLabel));
    expect(firstAppGroupFinder, findsOneWidget);

    final secondAppWidgetFinder = find.text(secondTestAppLabel);
    expect(secondAppWidgetFinder, findsOneWidget);
    final secondAppGroupFinder = find.ancestor(
        of: secondAppWidgetFinder,
        matching:
            find.widgetWithText(AppWidgetGroupListTile, secondTestAppLabel));
    expect(secondAppGroupFinder, findsOneWidget);
  });
  /*testWidgets('Long press on an app widget should show its context menu',
      (WidgetTester tester) async {
    const testAppWidget = AppWidgetData(
        icon: Icon(
          Icons.ac_unit_sharp,
          color: Colors.cyanAccent,
        ),
        packageName: 'testPackage',
        label: 'testAppWidget',
        preview: Icon(
          Icons.ac_unit_sharp,
          color: Colors.cyanAccent,
        ),
        appName: 'testApp',
        targetWidth: 3,
        targetHeight: 1,
        componentName: 'testComponent',
        minHeight: 0,
        minWidth: 0,
        appWidgetId: 0);

    await tester.pumpWidget(ProviderScope(
        overrides: [
          nativeAppWidgetProvider(testAppWidget.appWidgetId!)
              .overrideWithValue(Card(
            color: Colors.deepOrange,
            child: testAppWidget.icon,
          ))
        ],
        child: const MaterialApp(
            home: AppWidget(
          appWidgetData: testAppWidget,
        ))));
    await tester.pumpAndSettle();

    // GIVEN:
    // an app widget
    final testAppWidgetFinder = find.byType(AppWidget);
    expect(testAppWidgetFinder, findsOneWidget);

    // WHEN:
    // I long press
    await tester.longPress(testAppWidgetFinder);
    await tester.pumpAndSettle();

    // THEN:
    // its context menu is shown
    final appWidgetContextMenuFinder = find.byType(AppWidgetContextMenu);
    expect(appWidgetContextMenuFinder, findsOneWidget);
  });*/
}
