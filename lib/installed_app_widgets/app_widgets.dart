import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<String>> getAllApplicationWidgetIds() async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final List applicationWidgetIds =
      await platform.invokeMethod('getAllApplicationWidgetIds');
  return applicationWidgetIds.cast<String>();
}

Future<List<String>> getApplicationWidgetIds(String packageName) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final List applicationWidgetIds =
      await platform.invokeMethod('getApplicationWidgetIds', [packageName]);
  return applicationWidgetIds.cast<String>();
}

Future<String> getApplicationId(String applicationWidgetId) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final String applicationId =
      await platform.invokeMethod('getApplicationId', [applicationWidgetId]);
  return applicationId;
}

Future<List<String>> getAllApplicationIdsWithWidgets() async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final List applicationWidgetIds =
      await platform.invokeMethod('getAllApplicationIdsWithWidgets');
  return applicationWidgetIds.cast<String>();
}

// TODO description
Future<String> getApplicationWidgetLabel(String applicationWidgetId) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final String label = await platform
      .invokeMethod('getApplicationWidgetLabel', [applicationWidgetId]);
  return label;
}

Future<Uint8List> getApplicationWidgetPreview(
    String applicationWidgetId) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final Uint8List preview = await platform
      .invokeMethod('getApplicationWidgetPreview', [applicationWidgetId]);
  return preview;
}

Future<AppWidgetSizes> getApplicationWidgetSizes(
    String applicationWidgetId) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final Map sizes = await platform
      .invokeMethod('getApplicationWidgetSizes', [applicationWidgetId]);
  return AppWidgetSizes(
    minWidth: sizes['minWidth'] ?? 0,
    minHeight: sizes['minHeight'] ?? 0,
    targetWidth: sizes['targetWidth'] ?? 0,
    targetHeight: sizes['targetHeight'] ?? 0,
    maxWidth: sizes['maxWidth'] ?? 0,
    maxHeight: sizes['maxHeight'] ?? 0,
  );
}

class AppWidgetSizes {
  AppWidgetSizes(
      {required this.minWidth,
      required this.minHeight,
      required this.targetWidth,
      required this.targetHeight,
      required this.maxWidth,
      required this.maxHeight});

  final int minWidth;
  final int minHeight;
  final int targetWidth;
  final int targetHeight;
  final int maxWidth;
  final int maxHeight;
}

final applicationWidgetIdsProvider = FutureProvider<List<String>>((ref) async {
  return await getAllApplicationWidgetIds();
});

final appPackageApplicationWidgetIdsProvider =
    FutureProvider.family<List<String>, String>((ref, packageName) async {
  return await getApplicationWidgetIds(packageName);
});

final appWidgetSizesProvider = FutureProvider.family<AppWidgetSizes, String>(
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
