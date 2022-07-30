import 'dart:io';
import 'dart:typed_data';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO might change to Stream
Future<List<String>> getApplicationWidgetIds() async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final List<String> applicationWidgetIds =
      await platform.invokeMethod('getApplicationWidgetIds');
  return applicationWidgetIds;
}

Future<String> getApplicationId(String applicationWidgetId) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final String applicationId =
      await platform.invokeMethod('getApplicationId', [applicationWidgetId]);
  return applicationId;
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
  final Map<String, int> sizes = await platform
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
