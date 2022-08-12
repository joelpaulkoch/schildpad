import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/installed_app_widgets/app_widgets.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/installed_apps/apps.dart';

class AppWidgetsList extends ConsumerWidget {
  const AppWidgetsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref
        .watch(appsWithWidgetsProvider)
        .maybeWhen(data: (appPackages) => appPackages, orElse: () => []);
    return ListView(
        children: ListTile.divideTiles(
            color: Colors.white,
            context: context,
            tiles: apps.map((appPackage) => AppWidgetGroupListTile(
                  appPackage: appPackage,
                ))).toList());
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
    final groupTitle = ref
        .watch(appLabelProvider(appPackage))
        .maybeWhen(data: (appName) => appName, orElse: () => '');
    final appWidgetIds = ref
        .watch(appPackageApplicationWidgetIdsProvider(appPackage))
        .maybeWhen(data: (appWidgetIds) => appWidgetIds, orElse: () => []);

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
              children: appWidgetIds
                  .map((e) => AppWidgetListTile(
                        applicationWidgetId: e,
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
    required this.applicationWidgetId,
  }) : super(key: key);

  final String applicationWidgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);

    final appWidgetSizes = ref
        .watch(appWidgetSizesProvider(applicationWidgetId))
        .maybeWhen(
            data: (sizes) => sizes,
            orElse: () => AppWidgetSizes(
                minWidth: 0,
                minHeight: 0,
                targetWidth: 1,
                targetHeight: 1,
                maxWidth: 0,
                maxHeight: 0));

    final widgetColumnSpan =
        _getColumnSpan(context, columnCount, appWidgetSizes);
    final widgetRowSpan = _getRowSpan(context, rowCount, appWidgetSizes);

    final appWidgetPreview = ref
        .watch(appWidgetPreviewProvider(applicationWidgetId))
        .maybeWhen(
            data: (preview) => preview,
            orElse: () => const CircularProgressIndicator());

    final appWidgetLabel = ref
        .watch(appWidgetLabelProvider(applicationWidgetId))
        .maybeWhen(data: (label) => label, orElse: () => '');

    return LongPressDraggable(
      data: HomeGridElementData(
          appWidgetData: AppWidgetData(componentName: applicationWidgetId),
          columnSpan: 2,
          rowSpan: 1),
      maxSimultaneousDrags: 1,
      feedback: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(
              _getWidth(context, columnCount, appWidgetSizes),
              _getHeight(context, rowCount, appWidgetSizes))),
          child: appWidgetPreview),
      childWhenDragging: const SizedBox.shrink(),
      onDragStarted: () {
        context.pop();
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
                    child: appWidgetPreview),
                Text(
                  '$widgetColumnSpan x $widgetRowSpan',
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
            Text(
              appWidgetLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

double _getWidth(BuildContext context, int columnCount, AppWidgetSizes sizes) {
  if (sizes.targetWidth == 0) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (sizes.minWidth <= screenWidth)
        ? sizes.minWidth.toDouble()
        : screenWidth;
  }
  return (sizes.targetWidth * columnCount).toDouble();
}

double _getHeight(BuildContext context, int rowCount, AppWidgetSizes sizes) {
  if (sizes.targetHeight == 0) {
    final screenHeight = MediaQuery.of(context).size.height;
    return (sizes.minHeight <= screenHeight)
        ? sizes.minHeight.toDouble()
        : screenHeight;
  }
  return (sizes.targetHeight * rowCount).toDouble();
}

int _getColumnSpan(
    BuildContext context, int columnCount, AppWidgetSizes sizes) {
  if (sizes.targetWidth == 0) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnWidth = screenWidth / columnCount;
    final columnSpan = (sizes.minWidth / columnWidth).ceil();
    return (columnSpan <= columnCount) ? columnSpan : columnCount;
  }
  return sizes.targetWidth;
}

int _getRowSpan(BuildContext context, int rowCount, AppWidgetSizes sizes) {
  if (sizes.targetHeight == 0) {
    final screenHeight = MediaQuery.of(context).size.height;
    final rowHeight = screenHeight / rowCount;
    final rowSpan = (sizes.minHeight / rowHeight).ceil();
    return (rowSpan <= rowCount) ? rowSpan : rowCount;
  }
  return sizes.targetHeight;
}
