import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'installed_apps.dart';

final _columnCountProvider = Provider<int>((ref) {
  return 3;
});

class InstalledAppsView extends StatelessWidget {
  const InstalledAppsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const FlutterLogoDecoration(),
      child: CustomScrollView(slivers: <Widget>[
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
              splashColor: Colors.transparent,
              splashRadius: 20,
            ),
          ],
        ),
        const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                .map((app) => InstalledAppButton(
                    icon: Image.memory(
                      app.icon,
                      fit: BoxFit.contain,
                    ),
                    appName: app.appName,
                    onTap: app.openApp))
                .toList(),
            orElse: () => []));
  }
}

class InstalledAppButton extends StatelessWidget {
  const InstalledAppButton(
      {Key? key, required this.icon, required this.appName, this.onTap})
      : super(key: key);

  final Widget icon;
  final String appName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
            iconSize: 60,
            padding: EdgeInsets.zero,
            icon: icon,
            onPressed: onTap,
            splashColor: Colors.transparent,
          ),
          Text(
            appName,
            style: Theme.of(context).textTheme.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
