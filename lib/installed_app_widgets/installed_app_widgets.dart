import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/model/home_tile.dart';
import 'package:schildpad/installed_app_widgets/installed_application_widgets.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';

final applicationWidgetIdsProvider = FutureProvider<List<String>>((ref) async {
  return await getAllApplicationWidgetIds();
});

final appPackageApplicationWidgetIdsProvider =
    FutureProvider.family<List<String>, String>((ref, packageName) async {
  return await getApplicationWidgetIds(packageName);
});

final appWidgetSizesProvider =
    FutureProvider.family<ApplicationWidgetSizes, String>(
        (ref, applicationWidgetId) async {
  return getApplicationWidgetSizes(applicationWidgetId);
});

final appWidgetPreviewProvider = FutureProvider.autoDispose
    .family<Widget, String>((ref, applicationWidgetId) async {
  final preview = await getApplicationWidgetPreview(applicationWidgetId);
  return Image.memory(preview);
});

final appWidgetLabelProvider = FutureProvider.autoDispose
    .family<String, String>((ref, applicationWidgetId) async {
  return await getApplicationWidgetLabel(applicationWidgetId);
});

final appsWithWidgetsProvider = FutureProvider<List<String>>((ref) async {
  return await getAllApplicationIdsWithWidgets();
});

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
  final widget = ApplicationWidget(
    appWidgetId: appWidgetId,
  );
  return widget;
});

class AppWidgetsList extends ConsumerWidget {
  const AppWidgetsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref
        .watch(appsWithWidgetsProvider)
        .maybeWhen(data: (appPackages) => appPackages, orElse: () => []);
    return SingleChildScrollView(
        child: ExpansionPanelList.radio(
            children: apps
                .map((appPackage) => ExpansionPanelRadio(
                    value: appPackage,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) =>
                        AppWidgetGroupHeader(
                          appPackage: appPackage,
                        ),
                    body: AppWidgetGroupListTile(
                      appPackage: appPackage,
                    )))
                .toList()));
  }
}

class AppWidgetGroupHeader extends ConsumerWidget {
  const AppWidgetGroupHeader({
    Key? key,
    required this.appPackage,
  }) : super(key: key);

  final String appPackage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupTitle = ref
        .watch(appLabelProvider(appPackage))
        .maybeWhen(data: (appName) => appName, orElse: () => '');
    final appIconImage = ref
        .watch(appIconImageProvider(appPackage))
        .maybeWhen(data: (data) => data, orElse: () => const Icon(Icons.adb));
    return ListTile(
      leading: appIconImage,
      title: Text(groupTitle),
    );
  }
}

class AppWidgetGroupListTile extends ConsumerWidget {
  const AppWidgetGroupListTile({
    Key? key,
    required this.appPackage,
  }) : super(key: key);

  final String appPackage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appWidgetIds = ref
        .watch(appPackageApplicationWidgetIdsProvider(appPackage))
        .maybeWhen(data: (appWidgetIds) => appWidgetIds, orElse: () => []);

    return Material(
      child: Column(
        children: appWidgetIds
            .map((e) => AppWidgetListTile(
                  applicationWidgetId: e,
                ))
            .toList(),
      ),
    );
  }
}

class AppWidgetListTile extends ConsumerWidget {
  const AppWidgetListTile({
    Key? key,
    required this.applicationWidgetId,
  }) : super(key: key);

  final String applicationWidgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);

    final appWidgetPreview = ref
        .watch(appWidgetPreviewProvider(applicationWidgetId))
        .maybeWhen(data: (preview) => preview, orElse: () => Container());

    final appWidgetLabel = ref
        .watch(appWidgetLabelProvider(applicationWidgetId))
        .maybeWhen(data: (label) => label, orElse: () => '');

    final appWidgetSizes = ref
        .watch(appWidgetSizesProvider(applicationWidgetId))
        .maybeWhen(
            data: (sizes) => sizes,
            orElse: () => ApplicationWidgetSizes(
                minWidth: 0,
                minHeight: 0,
                targetWidth: 1,
                targetHeight: 1,
                maxWidth: 0,
                maxHeight: 0));

    final widgetColumnSpans =
        _getColumnSpans(context, columnCount, appWidgetSizes);
    final widgetRowSpans = _getRowSpans(context, rowCount, appWidgetSizes);

    return Column(
      children: [
        for (var widgetColumnSpan in widgetColumnSpans)
          for (var widgetRowSpan in widgetRowSpans)
            LongPressDraggable(
              data: ElementData(
                  appWidgetData:
                      AppWidgetData(componentName: applicationWidgetId),
                  columnSpan: widgetColumnSpan,
                  rowSpan: widgetRowSpan,
                  origin: GlobalElementCoordinates(location: Location.list)),
              maxSimultaneousDrags: 1,
              feedback: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(
                      _getWidth(context, widgetColumnSpan, columnCount),
                      _getHeight(context, widgetRowSpan, rowCount))),
                  child: appWidgetPreview),
              childWhenDragging: const SizedBox.shrink(),
              onDragStarted: () {
                context.go(HomeScreen.routeName);
              },
              child: Card(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ConstrainedBox(
                            constraints:
                                BoxConstraints.loose(const Size(200, 300)),
                            child: appWidgetPreview),
                        Text(
                          '$widgetColumnSpan x $widgetRowSpan',
                        )
                      ],
                    ),
                    Text(
                      appWidgetLabel,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

double _getWidth(BuildContext context, int widgetColumns, int columnCount) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth * widgetColumns / columnCount.toDouble();
}

double _getHeight(BuildContext context, int widgetRows, int rowCount) {
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight * widgetRows / rowCount.toDouble();
}

List<int> _getColumnSpans(
    BuildContext context, int columnCount, ApplicationWidgetSizes sizes) {
  final screenWidth = MediaQuery.of(context).size.width;
  final columnWidth = screenWidth / columnCount;

  var minColumnSpan = (sizes.minWidth / columnWidth).ceil();
  if (minColumnSpan > columnCount) {
    minColumnSpan = columnCount;
  }
  int maxColumnSpan;
  if (sizes.maxWidth != 0) {
    maxColumnSpan = (sizes.maxWidth / columnWidth).floor();
  } else if (sizes.targetWidth != 0) {
    maxColumnSpan = sizes.targetWidth;
  } else {
    maxColumnSpan = columnCount;
  }
  if (maxColumnSpan > columnCount) {
    maxColumnSpan = columnCount;
  }

  final columnSpans = [for (var c = minColumnSpan; c <= maxColumnSpan; c++) c];

  return columnSpans;
}

List<int> _getRowSpans(
    BuildContext context, int rowCount, ApplicationWidgetSizes sizes) {
  final screenHeight = MediaQuery.of(context).size.height;
  final rowHeight = screenHeight / rowCount;

  var minRowSpan = (sizes.minHeight / rowHeight).ceil();
  if (minRowSpan > rowCount) {
    minRowSpan = rowCount;
  }
  int maxRowSpan;
  if (sizes.maxHeight != 0) {
    maxRowSpan = (sizes.maxHeight / rowHeight).floor();
  } else if (sizes.targetHeight != 0) {
    maxRowSpan = sizes.targetHeight;
  } else {
    maxRowSpan = rowCount;
  }
  if (maxRowSpan > rowCount) {
    maxRowSpan = rowCount;
  }

  final rowSpans = [for (var c = minRowSpan; c <= maxRowSpan; c++) c];

  return rowSpans;
}
