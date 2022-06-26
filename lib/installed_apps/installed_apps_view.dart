import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home_view.dart';

import 'installed_apps.dart';

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
    final installedApps = ref.watch(installedAppsProvider);
    final columnCount = ref.watch(_columnCountProvider);
    return SliverGrid.count(
        crossAxisCount: columnCount,
        children: installedApps.maybeWhen(
            data: (appsList) => appsList
                .map((app) => InstalledAppIcon(
                    app: app,
                    showAppName: true,
                    onDragStarted: () {
                      context.go('/');
                      ref.read(showTrashProvider.notifier).state = true;
                    }))
                .toList(),
            orElse: () => []));
  }
}

class InstalledAppIcon extends ConsumerWidget {
  const InstalledAppIcon(
      {Key? key,
      required this.app,
      this.showAppName = false,
      this.onDragStarted,
      this.onDragCompleted,
      this.onDraggableCanceled})
      : super(key: key);

  final AppData app;
  final bool showAppName;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragCompleted;
  final Function(Velocity, Offset)? onDraggableCanceled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LongPressDraggable(
      data: (app),
      maxSimultaneousDrags: 1,
      feedback:
          SizedBox(width: _appIconSize, height: _appIconSize, child: app.icon),
      childWhenDragging: const SizedBox.shrink(),
      onDragStarted: onDragStarted,
      onDragCompleted: onDragCompleted,
      onDraggableCanceled: onDraggableCanceled,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              iconSize: _appIconSize,
              padding: EdgeInsets.zero,
              icon: app.icon,
              onPressed: app.launch,
              splashColor: Colors.transparent,
            ),
            if (showAppName)
              Text(
                app.name,
                style: Theme.of(context).textTheme.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
