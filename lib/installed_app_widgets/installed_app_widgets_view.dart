import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';

class InstalledAppWidgetsView extends StatelessWidget {
  const InstalledAppWidgetsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        body: AppWidgetsList(),
      ),
    );
  }
}

class AppWidgetsList extends ConsumerWidget {
  const AppWidgetsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appWidgets = ref.watch(installedAppWidgetsProvider);
    return appWidgets.maybeWhen(
        data: (widgets) {
          widgets.sort((a, b) =>
              a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
          final appNames = widgets.map((w) => w.appName).toSet();
          return ListView(
            children: ListTile.divideTiles(
                    color: Colors.white,
                    context: context,
                    tiles: appNames
                        .map((appName) => AppWidgetGroupListTile(
                              groupTitle: appName,
                              appWidgets: widgets
                                  .where((appWidget) =>
                                      (appWidget.appName == appName))
                                  .toList(),
                            ))
                        .toList())
                .toList(),
          );
        },
        orElse: SizedBox.shrink);
  }
}

class AppWidgetGroupListTile extends StatelessWidget {
  const AppWidgetGroupListTile({
    Key? key,
    required this.groupTitle,
    required this.appWidgets,
  }) : super(key: key);

  final String groupTitle;
  final List<AppWidgetData> appWidgets;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Column(
          children: [
            ListTile(
              title: Text(
                groupTitle,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Column(
              children: appWidgets
                  .where((appWidget) => (appWidget.appName == groupTitle))
                  .map((appWidget) => AppWidgetListTile(
                        appWidgetData: appWidget,
                      ))
                  .toList(),
            )
          ],
        ));
  }
}

class AppWidgetListTile extends ConsumerWidget {
  const AppWidgetListTile({
    Key? key,
    required this.appWidgetData,
  }) : super(key: key);

  final AppWidgetData appWidgetData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);
    final widgetColumnSpan = appWidgetData.getColumnSpan(context, columnCount);
    final widgetRowSpan = appWidgetData.getRowSpan(context, rowCount);
    return LongPressDraggable(
      data: HomeGridElementData(appWidgetData: appWidgetData),
      maxSimultaneousDrags: 1,
      feedback: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(
              appWidgetData.getWidth(context, columnCount),
              appWidgetData.getHeight(context, rowCount))),
          child: appWidgetData.preview),
      childWhenDragging: const SizedBox.shrink(),
      onDragStarted: () {
        context.push('/');
        ref.read(showTrashProvider.notifier).state = true;
      },
      onDraggableCanceled: (_, __) {
        ref.read(showTrashProvider.notifier).state = false;
        context.go('/');
      },
      onDragEnd: (_) {
        ref.read(showTrashProvider.notifier).state = false;
        context.go('/');
      },
      child: Card(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints.loose(const Size(200, 300)),
                    child: appWidgetData.preview),
                Text(
                  '$widgetColumnSpan x $widgetRowSpan',
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
            Text(
              appWidgetData.label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class InstalledAppWidgetView extends StatelessWidget {
  const InstalledAppWidgetView({Key? key, required this.appWidgetId})
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
