import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/installed_apps/proto/installed_apps.pb.dart';

final installedAppsProvider = FutureProvider<List<AppData>>((ref) async {
  const platform = MethodChannel('schildpad.schildpad.app/apps');
  final Uint8List result = await platform.invokeMethod('getInstalledApps');
  final installedApps = InstalledApps.fromBuffer(result);

  final appData = installedApps.apps
      .map<AppData>((app) => AppData(
            packageName: app.packageName,
          ))
      .toList();

  return appData;
});

class AppData {
  const AppData({
    required this.packageName,
  });

  final String packageName;
}
