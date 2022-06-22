import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/installed_apps/proto/installed_apps.pb.dart';

final installedAppsProvider = FutureProvider<List<AppData>>((ref) async {
  const platform = MethodChannel('schildpad.schildpad.app/apps');
  final Uint8List result = await platform.invokeMethod('getInstalledApps');
  final installedApps = InstalledApps.fromBuffer(result);

  final appData = installedApps.apps
      .map<AppData>((app) => AppData(
          icon: Image.memory(
            app.icon.data as Uint8List,
            fit: BoxFit.contain,
          ),
          name: app.name,
          packageName: app.packageName,
          launch: () => _launchApp(app.packageName, app.launchComponent)))
      .toList();

  //sort alphabetically
  appData.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  return appData;
});

void _launchApp(String package, String launchComponent) {
  if (Platform.isAndroid) {
    AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: package,
        category: 'android.intent.category.LAUNCHER',
        componentName: launchComponent,
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK]);
    intent.launch();
  }
}

class AppData {
  const AppData(
      {required this.icon,
      required this.name,
      required this.packageName,
      required this.launch});

  final Widget icon;
  final String name;
  final String packageName;
  final VoidCallback launch;
}
