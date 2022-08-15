import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/installed_apps/apps.dart';
import 'package:schildpad/settings/settings.dart';

final _columnCountProvider = Provider<int>((ref) {
  return 3;
});

const double _gridPadding = 16;
const double _appIconSize = 60;

class InstalledAppsView extends StatelessWidget {
  const InstalledAppsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      Material(
        child: ListTile(
          trailing: SettingsIconButton(),
        ),
      ),
      Expanded(child: InstalledAppsGrid())
    ]);
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
    return GridView.count(
        padding: const EdgeInsets.fromLTRB(
            _gridPadding, 0, _gridPadding, _gridPadding),
        crossAxisCount: columnCount,
        children: appPackages.maybeWhen(
            data: (appsList) => appsList
                .map((packageName) => InstalledAppDraggable(
                      app: AppData(packageName: packageName),
                      appIcon: AppIcon(
                        packageName: packageName,
                        showAppName: true,
                      ),
                      origin: GlobalElementCoordinates.onList(),
                      onDragStarted: Backdrop.of(context).revealBackLayer,
                    ))
                .toList(),
            orElse: () => []));
  }
}

class InstalledAppDraggable extends ConsumerWidget {
  const InstalledAppDraggable({
    Key? key,
    required this.app,
    required this.appIcon,
    this.showAppName = false,
    this.onDragStarted,
    this.onDragCompleted,
    this.onDraggableCanceled,
    this.onDragEnd,
    required this.origin,
  }) : super(key: key);

  final AppData app;
  final bool showAppName;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragCompleted;
  final Function(Velocity, Offset)? onDraggableCanceled;
  final Function(DraggableDetails)? onDragEnd;

  final GlobalElementCoordinates origin;

  final Widget appIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIconImage = ref.watch(appIconImageProvider(app.packageName));
    return LongPressDraggable(
      data: ElementData(
        appData: app,
        columnSpan: 1,
        rowSpan: 1,
        origin: origin,
      ),
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
