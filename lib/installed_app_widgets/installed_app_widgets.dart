import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          packageName: w.packageName,
          componentName: w.componentName));
  return installedAppWidgetsData.toList();
});

class AppWidgetData {
  const AppWidgetData({
    required this.icon,
    required this.label,
    required this.packageName,
    required this.componentName,
  });

  final Widget icon;
  final String label;
  final String packageName;
  final String componentName;
//TODO add size
}
