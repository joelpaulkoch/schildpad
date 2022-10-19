import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/installed_app_widgets/installed_application_widgets.dart';

final applicationWidgetIdsProvider = FutureProvider<List<String>>((ref) async {
  return await getAllApplicationWidgetIds();
});

final appPackageApplicationWidgetIdsProvider =
    FutureProvider.family<List<String>, String>((ref, packageName) async {
  return await getApplicationWidgetIds(packageName);
});

final appWidgetSizesProvider =
    FutureProvider.family<ApplicationWidgetSizes, String>(
        (ref, applicationWidgetId) async {
  return getApplicationWidgetSizes(applicationWidgetId);
});

final appWidgetPreviewProvider = FutureProvider.autoDispose
    .family<Widget, String>((ref, applicationWidgetId) async {
  final preview = await getApplicationWidgetPreview(applicationWidgetId);
  return Image.memory(preview);
});

final appWidgetLabelProvider = FutureProvider.autoDispose
    .family<String, String>((ref, applicationWidgetId) async {
  return await getApplicationWidgetLabel(applicationWidgetId);
});

final appsWithWidgetsProvider = FutureProvider<List<String>>((ref) async {
  return await getAllApplicationIdsWithWidgets();
});

class AppWidgetData {
  const AppWidgetData({
    required this.componentName,
    this.appWidgetId,
  });

  final String componentName;

  final int? appWidgetId;

  AppWidgetData copyWith(int appWidgetId) => AppWidgetData(
        componentName: componentName,
        appWidgetId: appWidgetId,
      );
}

class AppWidget extends ConsumerWidget {
  const AppWidget({
    Key? key,
    required this.appWidgetData,
  }) : super(key: key);

  final AppWidgetData appWidgetData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appWidgetId = appWidgetData.appWidgetId;
    assert(appWidgetId != null);
    final nativeWidget = ref.watch(nativeAppWidgetProvider(appWidgetId!));
    return nativeWidget;
  }
}

final nativeAppWidgetProvider =
    Provider.family<Widget, int>((ref, appWidgetId) {
  final widget = ApplicationWidget(
    appWidgetId: appWidgetId,
  );
  return widget;
});
