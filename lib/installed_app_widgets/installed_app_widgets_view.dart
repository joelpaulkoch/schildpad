import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          final appName = widgets.map((w) => w.appName).toSet();
          return ListView(
            children: ListTile.divideTiles(
                    color: Colors.white,
                    context: context,
                    tiles: appName
                        .map((a) => Material(
                            color: Colors.transparent,
                            child: ListTile(
                              title: Text(
                                a,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                children: widgets
                                    .where((widget) => (widget.appName == a))
                                    .map((widget) => Card(
                                          color: Colors.transparent,
                                          child: ListTile(
                                            leading: widget.icon,
                                            title: Text(
                                              widget.label,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white),
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
