import 'dart:io';
import 'dart:typed_data';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppData {
  const AppData({
    required this.packageName,
  });

  final String packageName;
}

Future<List<String>> getApplicationIds() async {
  const platform = MethodChannel('schildpad.schildpad.app/apps');
  final List applicationIds = await platform.invokeMethod('getApplicationIds');
  return applicationIds.cast<String>();
}

Future<String> getApplicationLabel(String applicationId) async {
  const platform = MethodChannel('schildpad.schildpad.app/apps');
  final String label =
      await platform.invokeMethod('getApplicationLabel', [applicationId]);
  return label;
}

Future<VoidCallback> getApplicationLaunchFunction(String applicationId) async {
  const platform = MethodChannel('schildpad.schildpad.app/apps');
  final String launchComponent = await platform
      .invokeMethod('getApplicationLaunchComponent', [applicationId]);
  return () => _launchApp(applicationId, launchComponent);
}

Future<Uint8List> getApplicationIcon(String applicationId) async {
  const platform = MethodChannel('schildpad.schildpad.app/apps');
  final Uint8List icon =
      await platform.invokeMethod('getApplicationIcon', [applicationId]);
  return icon;
}

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

final appPackagesProvider = FutureProvider<List<String>>((ref) async {
  return await getApplicationIds();
});

final appLabelProvider =
    FutureProvider.family<String, String>((ref, packageName) async {
  return await getApplicationLabel(packageName);
});

final _appLaunchFunctionProvider =
    FutureProvider.family<VoidCallback, String>((ref, packageName) async {
  return await getApplicationLaunchFunction(packageName);
});

final appIconImageProvider =
    FutureProvider.family<Image, String>((ref, packageName) async {
  final appIcon = await getApplicationIcon(packageName);
  return Image.memory(appIcon);
});

final _appIconSizeProvider = Provider<double>((ref) {
  return 60;
});

class AppIcon extends ConsumerWidget {
  const AppIcon({Key? key, required this.packageName, this.showAppName = false})
      : super(key: key);

  final String packageName;
  final bool showAppName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIconSize = ref.watch(_appIconSizeProvider);
    final appIconImage = ref.watch(appIconImageProvider(packageName));
    final appLaunch = ref.watch(_appLaunchFunctionProvider(packageName));
    final appLabel = ref.watch(appLabelProvider(packageName));
    return Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: appIconSize,
              padding: EdgeInsets.zero,
              icon: appIconImage.maybeWhen(
                  data: (appIcon) => appIcon,
                  orElse: () => const Icon(Icons.android_outlined)),
              onPressed: appLaunch.maybeWhen(
                  data: (launchFunction) => launchFunction,
                  orElse: () {
                    return null;
                  }),
              splashColor: Colors.transparent,
            ),
            if (showAppName)
              Text(
                appLabel.maybeWhen(data: (label) => label, orElse: () => ''),
                style: Theme.of(context).textTheme.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
          ],
        ));
  }
}
