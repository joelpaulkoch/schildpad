import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/flexible_grid/flexible_grid.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/installed_app_widgets/proto/installed_app_widgets.pb.dart';

final installedAppWidgetsProvider =
    FutureProvider<List<AppWidgetData>>((ref) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final Uint8List result =
      await platform.invokeMethod('getInstalledAppWidgets');
  final installedAppWidgets = InstalledAppWidgets.fromBuffer(result);
  final installedAppWidgetsData = installedAppWidgets.appWidgets.map((w) =>
      AppWidgetData(
          icon: Image.memory(w.icon.data as Uint8List),
          label: w.label,
          appName: w.appName,
          preview: Image.memory(w.preview.data as Uint8List),
          packageName: w.packageName,
          componentName: w.componentName,
          targetWidth: w.targetWidth,
          targetHeight: w.targetHeight,
          minWidth: w.minWidth,
          minHeight: w.minHeight));
  return installedAppWidgetsData.toList();
});

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
  const AppWidgetData(
      {required this.icon,
      required this.label,
      required this.appName,
      required this.preview,
      required this.packageName,
      required this.componentName,
      this.appWidgetId,
      required this.targetWidth,
      required this.targetHeight,
      required this.minWidth,
      required this.minHeight});

  final Widget icon;
  final String label;
  final String appName;
  final Widget preview;
  final String packageName;
  final String componentName;

  final int? appWidgetId;

  final int targetWidth;
  final int targetHeight;
  final int minWidth;
  final int minHeight;

  AppWidgetData copyWith(int appWidgetId) => AppWidgetData(
      icon: icon,
      label: label,
      appName: appName,
      preview: preview,
      packageName: packageName,
      componentName: componentName,
      appWidgetId: appWidgetId,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
      minWidth: minWidth,
      minHeight: minHeight);

  double getWidth(BuildContext context, int columnCount) {
    if (targetWidth == 0) {
      final screenWidth = MediaQuery.of(context).size.width;
      return (minWidth <= screenWidth) ? minWidth.toDouble() : screenWidth;
    }
    return (targetWidth * columnCount).toDouble();
  }

  double getHeight(BuildContext context, int rowCount) {
    if (targetHeight == 0) {
      final screenHeight = MediaQuery.of(context).size.height;
      return (minHeight <= screenHeight) ? minHeight.toDouble() : screenHeight;
    }
    return (targetHeight * rowCount).toDouble();
  }

  int getColumnSpan(BuildContext context, int columnCount) {
    if (targetWidth == 0) {
      final screenWidth = MediaQuery.of(context).size.width;
      final columnWidth = screenWidth / columnCount;
      final columnSpan = (minWidth / columnWidth).ceil();
      return (columnSpan <= columnCount) ? columnSpan : columnCount;
    }
    return targetWidth;
  }

  int getRowSpan(BuildContext context, int rowCount) {
    if (targetHeight == 0) {
      final screenHeight = MediaQuery.of(context).size.height;
      final rowHeight = screenHeight / rowCount;
      final rowSpan = (minHeight / rowHeight).ceil();
      return (rowSpan <= rowCount) ? rowSpan : rowCount;
    }
    return targetHeight;
  }
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
    required this.columnStart,
    required this.rowStart,
  }) : super(key: key);

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
                    .read(homeGridTilesProvider.notifier)
                    .removeTile(columnStart, rowStart);
                // TODO check if necessary
                ref
                    .read(homeGridElementDataProvider(
                            GridCell(columnStart, rowStart))
                        .notifier)
                    .state = HomeGridElementData();
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
