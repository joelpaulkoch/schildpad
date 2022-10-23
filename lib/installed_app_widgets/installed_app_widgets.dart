import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/model/tile.dart';
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
  return await getApplicationWidgetSizes(applicationWidgetId);
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

    if (appWidgetId != null) {
      return ApplicationWidget(
        appWidgetId: appWidgetId,
      );
    } else {
      return const AppWidgetError();
    }
  }
}

class AppWidgetsList extends ConsumerWidget {
  const AppWidgetsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(appsWithWidgetsProvider).maybeWhen(
        data: (appPackages) => appPackages, orElse: () => List<String>.empty());
    return AppWidgetExpansionPanelList(
      apps: apps,
    );
  }
}

class AppWidgetExpansionPanelList extends StatefulWidget {
  const AppWidgetExpansionPanelList({Key? key, required this.apps})
      : super(key: key);

  final List<String> apps;

  @override
  State<AppWidgetExpansionPanelList> createState() =>
      _AppWidgetExpansionPanelListState();
}

class _AppWidgetExpansionPanelListState
    extends State<AppWidgetExpansionPanelList> {
  int? _lastExpandedIndex;
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ExpansionPanelList.radio(
            expansionCallback: (index, isExpanded) {
              setState(() {
                if (!isExpanded) {
                  // this panel was closed and is expanding now
                  if (index != _lastExpandedIndex) {
                    // remember the last expanded panel
                    _lastExpandedIndex = _expandedIndex;
                    _expandedIndex = index;
                  }
                  // or it is called directly afterwards and is the last expanded panel which is closing
                  else {
                    // remember the currently expanded panel
                    _lastExpandedIndex = _expandedIndex;
                  }
                } else if (isExpanded) {
                  // this panel was expanded and is closing now
                  // no panel should be expanded => reset state
                  _lastExpandedIndex = null;
                  _expandedIndex = null;
                }
              });
            },
            children: [
          for (var i = 0; i < widget.apps.length; i++)
            ExpansionPanelRadio(
              value: widget.apps[i],
              headerBuilder: (BuildContext context, bool isExpanded) =>
                  AppWidgetGroupHeader(
                appPackage: widget.apps[i],
              ),
              canTapOnHeader: true,
              body: (_expandedIndex == i)
                  ? AppWidgetGroupListTile(
                      appPackage: widget.apps[i],
                    )
                  : const SizedBox.shrink(),
            )
        ]));
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
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: appIconImage,
      ),
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
                  origin:
                      const GlobalElementCoordinates(location: Location.list)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ConstrainedBox(
                                constraints:
                                    BoxConstraints.loose(const Size(200, 300)),
                                child: appWidgetPreview),
                          ),
                        ),
                        Flexible(
                          child: Align(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppWidgetDimensionInfo(
                                columnSpan: widgetColumnSpan,
                                rowSpan: widgetRowSpan,
                              ),
                            ),
                          ),
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

class AppWidgetDimensionInfo extends ConsumerWidget {
  const AppWidgetDimensionInfo({
    Key? key,
    required this.columnSpan,
    required this.rowSpan,
  }) : super(key: key);

  final int columnSpan;
  final int rowSpan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int columnCount = ref.watch(homeColumnCountProvider);
    final int rowCount = ref.watch(homeRowCountProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        WidgetDimensionVisualization(
            columnSpan: columnSpan,
            rowSpan: rowSpan,
            columnCount: columnCount,
            rowCount: rowCount),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$columnSpan x $rowSpan',
          ),
        ),
      ],
    );
  }
}

class WidgetDimensionVisualization extends StatelessWidget {
  const WidgetDimensionVisualization(
      {Key? key,
      required this.columnSpan,
      required this.rowSpan,
      required this.columnCount,
      required this.rowCount})
      : super(key: key);

  final int columnSpan;
  final int rowSpan;
  final int columnCount;
  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (var column = 0; column < columnCount; column++)
        Column(children: [
          for (var row = 0; row < rowCount; row++)
            DecoratedBox(
              decoration: BoxDecoration(
                  color: (column < columnSpan && row < rowSpan)
                      ? Theme.of(context).unselectedWidgetColor
                      : Colors.transparent,
                  border: Border.all(color: Theme.of(context).dividerColor)),
              child: const SizedBox(width: 20, height: 20),
            ),
        ])
    ]);
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

class AppWidgetError extends StatelessWidget {
  const AppWidgetError({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
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

class AppWidgetDraggable extends ConsumerWidget {
  const AppWidgetDraggable({
    Key? key,
    required this.appWidgetData,
    required this.columnSpan,
    required this.rowSpan,
    required this.origin,
  }) : super(key: key);

  final AppWidgetData appWidgetData;
  final GlobalElementCoordinates origin;
  final int columnSpan;
  final int rowSpan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);

    final appWidgetPreview = ref
        .watch(appWidgetPreviewProvider(appWidgetData.componentName))
        .maybeWhen(
            data: (preview) => preview,
            orElse: () => Container(color: Colors.amber));

    final widgetId = appWidgetData.appWidgetId;
    assert(widgetId != null);

    if (widgetId != null) {
      return LongPressDraggable(
          data: ElementData(
            appWidgetData: appWidgetData,
            columnSpan: columnSpan,
            rowSpan: rowSpan,
            origin: origin,
          ),
          maxSimultaneousDrags: 1,
          feedback: ConstrainedBox(
              constraints: BoxConstraints.tight(Size(
                  _getWidth(context, columnSpan, columnCount),
                  _getHeight(context, rowSpan, rowCount))),
              child: appWidgetPreview),
          child: AppWidget(
            appWidgetData: appWidgetData,
          ));
    } else {
      return const AppWidgetError();
    }
  }
}
