import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Stream<int> getApplicationsUpdateStream() {
  const stream = EventChannel('schildpad.schildpad.app/apps_update');
  return stream.receiveBroadcastStream().cast<int>();
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

class ApplicationIcon extends StatelessWidget {
  const ApplicationIcon({
    Key? key,
    required this.applicationIconSize,
    required this.applicationIconImage,
    required this.applicationLabel,
    this.showApplicationLabel = true,
    this.applicationLaunchFunction,
  })  : assert(applicationIconSize > 0),
        super(key: key);

  final double applicationIconSize;
  final Widget applicationIconImage;
  final String applicationLabel;
  final bool showApplicationLabel;
  final VoidCallback? applicationLaunchFunction;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: IconButton(
                  iconSize: applicationIconSize,
                  padding: EdgeInsets.zero,
                  icon: SizedBox(
                    width: applicationIconSize,
                    height: applicationIconSize,
                    child: applicationIconImage,
                  ),
                  onPressed: applicationLaunchFunction),
            ),
            if (showApplicationLabel)
              Text(
                applicationLabel,
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
          ],
        ));
  }
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
