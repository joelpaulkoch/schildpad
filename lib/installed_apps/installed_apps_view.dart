import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/installed_apps/apps.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';

final _columnCountProvider = Provider<int>((ref) {
  return 3;
});

const double _gridPadding = 16;
const double _appIconSize = 60;

class InstalledAppsView extends StatelessWidget {
  const InstalledAppsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.transparent,
          pinned: false,
          snap: false,
          floating: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
              splashRadius: 20,
            ),
          ],
        ),
        const SliverPadding(
            padding: EdgeInsets.fromLTRB(
                _gridPadding, 0, _gridPadding, _gridPadding),
            sliver: InstalledAppsGrid())
      ]),
    );
  }
}

class InstalledAppsGrid extends ConsumerWidget {
  const InstalledAppsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appPackages = ref.watch(appPackagesProvider);
    final columnCount = ref.watch(_columnCountProvider);
    return SliverGrid.count(
        crossAxisCount: columnCount,
        children: appPackages.maybeWhen(
            data: (appsList) => appsList
                .map((packageName) => InstalledAppDraggable(
                      app: AppData(packageName: packageName),
                      appIcon: AppIcon(
                        packageName: packageName,
                        showAppName: true,
                      ),
                      onDragStarted: context.pop,
                    ))
                .toList(),
            orElse: () => []));
  }
}

class InstalledAppDraggable extends ConsumerWidget {
  const InstalledAppDraggable(
      {Key? key,
      required this.app,
      required this.appIcon,
      this.showAppName = false,
      this.onDragStarted,
      this.onDragCompleted,
      this.onDraggableCanceled,
      this.onDragEnd,
      this.pageIndex,
      this.column,
      this.row})
      : super(key: key);

  final AppData app;
  final bool showAppName;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragCompleted;
  final Function(Velocity, Offset)? onDraggableCanceled;
  final Function(DraggableDetails)? onDragEnd;

  final int? pageIndex;
  final int? column;
  final int? row;

  final Widget appIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIconImage = ref.watch(appIconImageProvider(app.packageName));
    return LongPressDraggable(
      data: HomeGridElementData(
          appData: app,
          originPageIndex: pageIndex,
          originColumn: column,
          originRow: row),
      maxSimultaneousDrags: 1,
      feedback: SizedBox(
          width: _appIconSize,
          height: _appIconSize,
          child: appIconImage.maybeWhen(
              data: (icon) => icon, orElse: () => const Icon(Icons.adb))),
      childWhenDragging: const SizedBox.shrink(),
      onDragStarted: onDragStarted,
      onDragCompleted: onDragCompleted,
      onDraggableCanceled: onDraggableCanceled,
      onDragEnd: onDragEnd,
      child: Material(type: MaterialType.transparency, child: appIcon),
    );
  }
}
