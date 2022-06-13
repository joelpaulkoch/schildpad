import 'package:device_apps/device_apps.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final installedAppsProvider =
    FutureProvider<List<ApplicationWithIcon>>((ref) async {
  List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: false,
      includeAppIcons: true);

  //get icons
  final appsWithIcons = apps.cast<ApplicationWithIcon>();

  //sort alphabetically
  appsWithIcons.sort(
      (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

  return appsWithIcons;
});
