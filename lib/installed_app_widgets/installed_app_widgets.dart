import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<int> createWidget(String componentName) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final int appWidgetId =
      await platform.invokeMethod('getWidgetId', [componentName]);
  dev.log('got widget id for $componentName: $appWidgetId');
  return appWidgetId;
}

class AppWidgetData {
  const AppWidgetData({
    required this.componentName,
    this.appWidgetId,
  });

  final String componentName;

  final int? appWidgetId;

  AppWidgetData copyWith(int appWidgetId) => AppWidgetData(
        componentName: componentName,
        appWidgetId: appWidgetId,
      );
}

class AppWidget extends ConsumerWidget {
  const AppWidget({
    Key? key,
    required this.appWidgetData,
  }) : super(key: key);

  final AppWidgetData appWidgetData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appWidgetId = appWidgetData.appWidgetId;
    assert(appWidgetId != null);
    final nativeWidget = ref.watch(nativeAppWidgetProvider(appWidgetId!));
    return nativeWidget;
  }
}

final nativeAppWidgetProvider =
    Provider.family<Widget, int>((ref, appWidgetId) {
  return NativeAppWidget._internal(
    appWidgetId: appWidgetId,
  );
});

class NativeAppWidget extends StatelessWidget {
  const NativeAppWidget._internal({Key? key, required this.appWidgetId})
      : super(key: key);

  final int appWidgetId;

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'app.schildpad.schildpad/appwidgetview';
    // Pass parameters to the platform side.
    Map<String, dynamic> creationParams = <String, dynamic>{
      'appWidgetId': appWidgetId
    };

    if (defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError('Unsupported platform view');
    }

    dev.log('building new native widget view with id: $appWidgetId');
    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        // TODO check if initSurfaceAndroidView can be used
        return PlatformViewsService.initExpensiveAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}
