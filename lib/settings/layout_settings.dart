import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/app_drawer/app_drawer.dart';
import 'package:schildpad/home/dock.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/model/layout_settings.dart';
import 'package:schildpad/home/model/tile.dart';
import 'package:schildpad/home/tile.dart';
import 'package:schildpad/main.dart';
import 'package:toggle_switch/toggle_switch.dart';

final layoutSettingsProvider = Provider<LayoutSettings>((ref) {
  ref.watch(isarLayoutSettingsUpdateProvider);
  final layoutSettings = ref
      .watch(layoutSettingsIsarProvider)
      .whenOrNull(data: (layout) => layout);
  return layoutSettings?.getSync(0) ?? LayoutSettings();
});

final layoutSettingsIsarProvider =
    FutureProvider<IsarCollection<LayoutSettings>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return isar.layoutSettings;
});

final isarLayoutSettingsUpdateProvider = StreamProvider<void>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield* isar.layoutSettings.watchLazy();
});

final layoutSettingsManagerProvider = Provider<LayoutSettingsManager>((ref) {
  final isarCollection = ref
      .watch(layoutSettingsIsarProvider)
      .whenOrNull(data: (collection) => collection);
  return LayoutSettingsManager(isarCollection);
});

class LayoutSettingsManager {
  LayoutSettingsManager(this.isarCollection);

  final IsarCollection<LayoutSettings>? isarCollection;

  Future<void> setAppGridColumns(int columns) async {
    final layoutCollection = isarCollection;

    await layoutCollection?.isar.writeTxn(() async {
      final gridLayout = await layoutCollection.get(0);
      final newLayout = gridLayout?.copyWith(appGridColumns: columns) ??
          LayoutSettings(appGridColumns: columns);
      await layoutCollection.put(newLayout);
    });
  }

  Future<void> setAppGridRows(int rows) async {
    final layoutCollection = isarCollection;

    await layoutCollection?.isar.writeTxn(() async {
      final gridLayout = await layoutCollection.get(0);
      final newLayout = gridLayout?.copyWith(appGridRows: rows) ??
          LayoutSettings(appGridColumns: rows);
      await layoutCollection.put(newLayout);
    });
  }

  Future<void> setAppDrawerColumns(int columns) async {
    final layoutCollection = isarCollection;

    await layoutCollection?.isar.writeTxn(() async {
      final layout = await layoutCollection.get(0);
      final newLayout = layout?.copyWith(appDrawerColumns: columns) ??
          LayoutSettings(appDrawerColumns: columns);
      await layoutCollection.put(newLayout);
    });
  }

  Future<void> setDockColumns(int columns) async {
    final layoutCollection = isarCollection;

    await layoutCollection?.isar.writeTxn(() async {
      final layout = await layoutCollection.get(0);
      final newLayout = layout?.copyWith(dockColumns: columns) ??
          LayoutSettings(dockColumns: columns);
      await layoutCollection.put(newLayout);
    });
  }
}

class AppGridHeadingListTile extends StatelessWidget {
  const AppGridHeadingListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.appGridListTile,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class AppGridColumnsListTile extends ConsumerWidget {
  const AppGridColumnsListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutManager = ref.watch(layoutSettingsManagerProvider);
    final tileManager = ref.watch(tileManagerProvider);
    final columns = ref.watch(homeColumnCountProvider);
    return ListTile(
        title: Text(AppLocalizations.of(context)!.columns),
        trailing: ToggleSwitch(
          initialLabelIndex: columns - 3,
          totalSwitches: 3,
          labels: const ['3', '4', '5'],
          cancelToggle: (index) async {
            var cancel = false;
            if (index != null) {
              if (index + 3 < columns) {
                // less columns than before
                cancel = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .layoutAlertTitle),
                              content: Text(AppLocalizations.of(context)!
                                  .appGridLayoutAlertContent),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.cancel)),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.confirm)),
                              ],
                            ),
                        barrierDismissible: false) ??
                    false;
              }
            }
            return cancel;
          },
          onToggle: (index) async {
            if (index != null) {
              if (index + 3 < columns) {
                tileManager.removeAllFromLocation(Location.home);
              }
              await layoutManager.setAppGridColumns(index + 3);
            }
          },
        ));
  }
}

class AppGridRowsListTile extends ConsumerWidget {
  const AppGridRowsListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutManager = ref.watch(layoutSettingsManagerProvider);
    final tileManager = ref.watch(tileManagerProvider);
    final rows = ref.watch(homeRowCountProvider);
    return ListTile(
        title: Text(AppLocalizations.of(context)!.rows),
        trailing: ToggleSwitch(
          initialLabelIndex: rows - 3,
          totalSwitches: 3,
          labels: const ['3', '4', '5'],
          cancelToggle: (index) async {
            var cancel = false;
            if (index != null) {
              if (index + 3 < rows) {
                // less columns than before
                cancel = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .layoutAlertTitle),
                              content: Text(AppLocalizations.of(context)!
                                  .appGridLayoutAlertContent),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.cancel)),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.confirm)),
                              ],
                            ),
                        barrierDismissible: false) ??
                    false;
              }
            }
            return cancel;
          },
          onToggle: (index) async {
            if (index != null) {
              if (index + 3 < rows) {
                tileManager.removeAllFromLocation(Location.home);
              }
              await layoutManager.setAppGridRows(index + 3);
            }
          },
        ));
  }
}

class AppDrawerHeadingListTile extends StatelessWidget {
  const AppDrawerHeadingListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.appDrawer,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class AppDrawerColumnsListTile extends ConsumerWidget {
  const AppDrawerColumnsListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutManager = ref.watch(layoutSettingsManagerProvider);
    final appDrawerColumns = ref.watch(appDrawerColumnsProvider);
    return ListTile(
        title: Text(AppLocalizations.of(context)!.columns),
        trailing: ToggleSwitch(
          initialLabelIndex: appDrawerColumns - 3,
          totalSwitches: 3,
          labels: const ['3', '4', '5'],
          onToggle: (index) async {
            if (index != null) {
              await layoutManager.setAppDrawerColumns(index + 3);
            }
          },
        ));
  }
}

class DockHeadingListTile extends StatelessWidget {
  const DockHeadingListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.dock,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class DockColumnsListTile extends ConsumerWidget {
  const DockColumnsListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutManager = ref.watch(layoutSettingsManagerProvider);
    final tileManager = ref.watch(tileManagerProvider);
    final dockColumns = ref.watch(dockColumnCountProvider);
    return ListTile(
        title: Text(AppLocalizations.of(context)!.columns),
        trailing: ToggleSwitch(
          initialLabelIndex: dockColumns - 3,
          totalSwitches: 3,
          labels: const ['3', '4', '5'],
          cancelToggle: (index) async {
            var cancel = false;
            if (index != null) {
              if (index + 3 < dockColumns) {
                // less columns than before
                cancel = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .layoutAlertTitle),
                              content: Text(AppLocalizations.of(context)!
                                  .dockLayoutAlertContent),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.cancel)),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.confirm)),
                              ],
                            ),
                        barrierDismissible: false) ??
                    false;
              }
            }
            return cancel;
          },
          onToggle: (index) async {
            if (index != null) {
              if (index + 3 < dockColumns) {
                tileManager.removeAllFromLocation(Location.dock);
              }
              await layoutManager.setDockColumns(index + 3);
            }
          },
        ));
  }
}

class DockAdditionalRowListTile extends StatelessWidget {
  const DockAdditionalRowListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(AppLocalizations.of(context)!.additionalRow),
        value: false,
        onChanged: (_) {});
  }
}

class DockTopListTile extends StatelessWidget {
  const DockTopListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(AppLocalizations.of(context)!.topDock),
        value: false,
        onChanged: (_) {});
  }
}
