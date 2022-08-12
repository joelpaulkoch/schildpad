import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home_grid.dart';

final appWidgetIdProvider =
    FutureProvider.family<int, String>((ref, componentName) async {
  return await _createWidget(componentName);
});

Future<int> _createWidget(String componentName) async {
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

final showAppWidgetContextMenuProvider = StateProvider<bool>((ref) {
  return false;
});

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
    return (appWidgetId != null)
        ? ref.watch(nativeAppWidgetProvider(appWidgetId))
        : SizedBox.expand(
            child: Card(
            color: Colors.amber,
            child: Column(
              children: const [
                Icon(
                  Icons.bubble_chart,
                  color: Colors.white,
                ),
                Icon(
                  Icons.adb_outlined,
                  color: Colors.white,
                )
              ],
            ),
          ));
  }
}

class AppWidgetContextMenu extends ConsumerWidget {
  const AppWidgetContextMenu({
    Key? key,
    required this.pageIndex,
    required this.columnStart,
    required this.rowStart,
  }) : super(key: key);

  final int pageIndex;
  final int columnStart;
  final int rowStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.greenAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OutlinedButton(
              onPressed: () {
                ref.read(showAppWidgetContextMenuProvider.notifier).state =
                    false;
              },
              child: const Icon(Icons.cancel_outlined)),
          OutlinedButton(
              onPressed: () {
                dev.log('removing app widget from ($columnStart, $rowStart)');
                ref
                    .read(homeGridTilesProvider(pageIndex).notifier)
                    .removeTile(columnStart, rowStart);
                ref.read(showAppWidgetContextMenuProvider.notifier).state =
                    false;
              },
              child: const Icon(Icons.delete_outline_rounded))
        ],
      ),
    );
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
