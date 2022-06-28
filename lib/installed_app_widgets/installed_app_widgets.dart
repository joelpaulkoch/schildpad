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
          componentName: w.componentName));
  return installedAppWidgetsData.toList();
});

class AppWidgetData {
  const AppWidgetData(
      {required this.icon,
      required this.label,
      required this.appName,
      required this.packageName,
      required this.componentName,
      this.appWidgetId});

  final Widget icon;
  final String label;
  final String appName;
  final String packageName;
  final String componentName;

  final int? appWidgetId;
//TODO add size
}

Future<int> createWidget(String componentName) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final int appWidgetId =
      await platform.invokeMethod('createAndBindWidget', [componentName]);
  return appWidgetId;
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
    return LongPressDraggable(
        data: HomeGridElementData(appWidgetData: appWidgetData),
        maxSimultaneousDrags: 1,
        feedback: Card(
          color: Colors.amber,
          child: Text(appWidgetData.label),
        ),
        child: (appWidgetId != null)
            ? InstalledAppWidgetView(appWidgetId: appWidgetId)
            : SizedBox.expand(
                child: Card(
                color: Colors.deepOrangeAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.bubble_chart_outlined,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.adb,
                      color: Colors.white,
                    ),
                  ],
                ),
              )));
  }
}
