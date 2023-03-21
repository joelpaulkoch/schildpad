import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

Future<int> createApplicationWidget(String componentName) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final int appWidgetId =
      await platform.invokeMethod('createWidget', [componentName]);
  return appWidgetId;
}

Future<void> deleteApplicationWidget(int widgetId) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  await platform.invokeMethod('deleteWidget', [widgetId]);
}

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

Future<ApplicationWidgetSizes> getApplicationWidgetSizes(
    String applicationWidgetId) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final Map sizes = await platform
      .invokeMethod('getApplicationWidgetSizes', [applicationWidgetId]);
  return ApplicationWidgetSizes(
    minWidth: sizes['minWidth'] ?? 0,
    minHeight: sizes['minHeight'] ?? 0,
    targetWidth: sizes['targetWidth'] ?? 0,
    targetHeight: sizes['targetHeight'] ?? 0,
    maxWidth: sizes['maxWidth'] ?? 0,
    maxHeight: sizes['maxHeight'] ?? 0,
  );
}

class ApplicationWidgetSizes {
  ApplicationWidgetSizes(
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

class ApplicationWidget extends StatelessWidget {
  const ApplicationWidget({Key? key, required this.appWidgetId})
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
        return PlatformViewsService.initSurfaceAndroidView(
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
