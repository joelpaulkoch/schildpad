import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/home/trash.dart';
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
      this.onDraggableCanceled,
      this.onDragEnd})
      : super(key: key);

  final AppData app;
  final bool showAppName;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragCompleted;
  final Function(Velocity, Offset)? onDraggableCanceled;
  final Function(DraggableDetails)? onDragEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LongPressDraggable(
      data: HomeGridElementData(appData: app),
      maxSimultaneousDrags: 1,
      feedback:
          SizedBox(width: _appIconSize, height: _appIconSize, child: app.icon),
      childWhenDragging: const SizedBox.shrink(),
      onDragStarted: onDragStarted,
      onDragCompleted: onDragCompleted,
      onDraggableCanceled: onDraggableCanceled,
      onDragEnd: onDragEnd,
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
