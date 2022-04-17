import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'installed_apps.dart';

class InstalledAppsView extends StatelessWidget {
  const InstalledAppsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        pinned: false,
        snap: false,
        floating: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: InstalledAppsGrid()),
    ]));
  }
}

class InstalledAppsGrid extends ConsumerWidget {
  const InstalledAppsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installedApps = ref.watch(installedAppsProvider);
    return SliverGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        // crossAxisSpacing: 16,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: IconButton(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          icon: icon,
          onPressed: onTap,
        )),
        Text(
          appName,
          style: Theme.of(context).textTheme.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class InstalledAppsList extends ConsumerWidget {
  const InstalledAppsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installedApps = ref.watch(installedAppsProvider);
    return SliverList(
        delegate: SliverChildListDelegate(installedApps.maybeWhen(
            data: (appsList) => appsList
                .map((app) => InstalledAppListTile(
                    appIcon: Image.memory(app.icon),
                    appName: app.appName,
                    onTap: app.openApp))
                .toList(),
            orElse: () => [])));
  }
}

class InstalledAppListTile extends StatelessWidget {
  const InstalledAppListTile(
      {Key? key, required this.appIcon, required this.appName, this.onTap})
      : super(key: key);

  final Image appIcon;

  final Function? onTap;

  final String appName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: appIcon,
        title: Text(
          appName,
          maxLines: 1,
        ),
        onTap: () => onTap,
        horizontalTitleGap: 40,
      ),
    );
  }
}
