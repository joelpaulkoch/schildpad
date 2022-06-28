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
                        .map((appName) => Material(
                            color: Colors.transparent,
                            child: ListTile(
                              title: Text(
                                appName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                children: widgets
                                    .where((appWidget) =>
                                        (appWidget.appName == appName))
                                    .map((appWidget) => LongPressDraggable(
                                          data: HomeGridElementData(
                                              appWidgetData: appWidget),
                                          maxSimultaneousDrags: 1,
                                          feedback: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Container(
                                              color: Colors.deepOrange,
                                            ),
                                          ),
                                          childWhenDragging:
                                              const SizedBox.shrink(),
                                          onDragStarted: () {
                                            context.push('/');
                                            ref
                                                .read(
                                                    showTrashProvider.notifier)
                                                .state = true;
                                          },
                                          onDraggableCanceled: (_, __) {
                                            ref
                                                .read(
                                                    showTrashProvider.notifier)
                                                .state = false;
                                            context.go('/');
                                          },
                                          onDragEnd: (_) {
                                            ref
                                                .read(
                                                    showTrashProvider.notifier)
                                                .state = false;
                                            context.go('/');
                                          },
                                          child: Card(
                                            color: Colors.transparent,
                                            child: ListTile(
                                              leading: appWidget.icon,
                                              title: Text(
                                                appWidget.label,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            )))
                        .toList())
                .toList(),
          );
        },
        orElse: SizedBox.shrink);
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
