import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final installedAppsProvider = FutureProvider<List<AppData>>((ref) async {
  List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: false,
      includeAppIcons: true);

  //get icons
  final appsWithIcons = apps.cast<ApplicationWithIcon>();

  final appData = appsWithIcons
      .map<AppData>((app) => AppData(
          icon: Image.memory(
            app.icon,
            fit: BoxFit.contain,
          ),
          name: app.appName,
          launch: app.openApp))
      .toList();

  //sort alphabetically
  appData.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  return appData;
});

class AppData {
  const AppData({required this.icon, required this.name, required this.launch});

  final Widget icon;
  final String name;
  final VoidCallback launch;
}
