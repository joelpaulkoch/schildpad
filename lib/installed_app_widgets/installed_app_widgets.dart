import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets_view.dart';
import 'package:schildpad/installed_app_widgets/proto/installed_app_widgets.pb.dart';

final installedAppWidgetsProvider =
    FutureProvider<List<AppWidgetData>>((ref) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final Uint8List result =
      await platform.invokeMethod('getInstalledAppWidgets');
  final installedAppWidgets = InstalledAppWidgets.fromBuffer(result);
  final installedAppWidgetsData = installedAppWidgets.appWidgets.map((w) =>
      AppWidgetData(
          icon: Image.memory(w.icon.data as Uint8List),
          label: w.label,
          appName: w.appName,
          packageName: w.packageName,
          componentName: w.componentName,
          targetWidth: w.targetWidth,
          targetHeight: w.targetHeight,
          minWidth: w.minWidth,
          minHeight: w.minHeight));
  return installedAppWidgetsData.toList();
});

final appWidgetIdProvider =
    FutureProvider.family<int, String>((ref, componentName) async {
  return await _createWidget(componentName);
});

Future<int> _createWidget(String componentName) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final int appWidgetId =
      await platform.invokeMethod('getWidgetId', [componentName]);
  dev.log('got widget id for $componentName: $appWidgetId');
  return appWidgetId;
}

class AppWidgetData {
  const AppWidgetData(
      {required this.icon,
      required this.label,
      required this.appName,
      required this.packageName,
      required this.componentName,
      this.appWidgetId,
      required this.targetWidth,
      required this.targetHeight,
      required this.minWidth,
      required this.minHeight});

  final Widget icon;
  final String label;
  final String appName;
  final String packageName;
  final String componentName;

  final int? appWidgetId;

  final int targetWidth;
  final int targetHeight;
  final int minWidth;
  final int minHeight;

  AppWidgetData copyWith(int appWidgetId) => AppWidgetData(
      icon: icon,
      label: label,
      appName: appName,
      packageName: packageName,
      componentName: componentName,
      appWidgetId: appWidgetId,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
      minWidth: minWidth,
      minHeight: minHeight);
}

class AppWidget extends ConsumerWidget {
  const AppWidget(
      {Key? key,
      required this.appWidgetData,
      this.onDragStarted,
      this.onDragCompleted,
      this.onDraggableCanceled,
      this.onDragEnd})
      : super(key: key);

  final AppWidgetData appWidgetData;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragCompleted;
  final Function(Velocity, Offset)? onDraggableCanceled;
  final Function(DraggableDetails)? onDragEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appWidgetId = appWidgetData.appWidgetId;
    assert(appWidgetId != null);
    return LongPressDraggable(
        data: HomeGridElementData(appWidgetData: appWidgetData),
        maxSimultaneousDrags: 1,
        childWhenDragging: const SizedBox.shrink(),
        feedback: SizedBox(
          width: 200,
          height: 100,
          child: Card(
            color: Colors.amber,
            child: Text(appWidgetData.label),
          ),
        ),
        onDragStarted: onDragStarted,
        onDragCompleted: onDragCompleted,
        onDraggableCanceled: onDraggableCanceled,
        onDragEnd: onDragEnd,
        child: (appWidgetId != null)
            ? InstalledAppWidgetView(appWidgetId: appWidgetId)
            : SizedBox.expand(
                child: Card(
                color: Colors.amber,
                child: Column(
                  children: const [
                    Icon(
                      Icons.bubble_chart,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.adb_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              )));
  }
}
