import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/app_drawer/installed_applications.dart';
import 'package:schildpad/home/model/tile.dart';
import 'package:schildpad/settings/settings.dart';

final _columnCountProvider = Provider<int>((ref) {
  return 3;
});

const double _gridPadding = 16;
const double _appIconSize = 60;

class AppsView extends StatelessWidget {
  const AppsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      Material(
        child: ListTile(
          trailing: SettingsIconButton(),
        ),
      ),
      Expanded(child: AppDrawerGrid())
    ]);
  }
}

class AppDrawerGrid extends ConsumerWidget {
  const AppDrawerGrid({
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
                .map((packageName) => AppDraggable(
                      app: AppData(packageName: packageName),
                      appIcon: AppIcon(
                        packageName: packageName,
                        showAppName: true,
                      ),
                      origin: const GlobalElementCoordinates(
                          location: Location.list),
                      onDragStarted: Backdrop.of(context).revealBackLayer,
                    ))
                .toList(),
            orElse: () => []));
  }
}

class AppDraggable extends ConsumerWidget {
  const AppDraggable({
    Key? key,
    required this.app,
    required this.appIcon,
    this.onDragStarted,
    this.onDragCompleted,
    this.onDraggableCanceled,
    this.onDragEnd,
    required this.origin,
  }) : super(key: key);

  final AppData app;
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
      child: appIcon,
    );
  }
}

final appsUpdateProvider = Provider<int>((ref) {
  final updateCount = ref.watch(_appsUpdateStreamProvider);
  return updateCount.maybeWhen(data: (data) => data, orElse: () => 0);
});

final _appsUpdateStreamProvider = StreamProvider<int>((ref) async* {
  final stream = getApplicationsUpdateStream();

  await for (final counter in stream) {
    yield counter;
  }
});

final appPackagesProvider = FutureProvider<List<String>>((ref) async {
  ref.watch(appsUpdateProvider);
  return await getApplicationIds();
});

final appLabelProvider =
    FutureProvider.family<String, String>((ref, packageName) async {
  return await getApplicationLabel(packageName);
});

final _appLaunchFunctionProvider =
    FutureProvider.family<VoidCallback, String>((ref, packageName) async {
  return await getApplicationLaunchFunction(packageName);
});

final appIconImageProvider =
    FutureProvider.family<Image, String>((ref, packageName) async {
  final appIcon = await getApplicationIcon(packageName);
  return Image.memory(appIcon);
});

final _appIconSizeProvider = Provider<double>((ref) {
  return 60;
});

class AppIcon extends ConsumerWidget {
  const AppIcon({Key? key, required this.packageName, this.showAppName = false})
      : super(key: key);

  final String packageName;
  final bool showAppName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIconSize = ref.watch(_appIconSizeProvider);
    final appIconImage = ref.watch(appIconImageProvider(packageName)).maybeWhen(
        data: (appIcon) => appIcon,
        error: (_, __) => const Icon(
              Icons.android_outlined,
              color: Colors.red,
            ),
        orElse: () => const Icon(Icons.android_outlined));
    final appLaunch =
        ref.watch(_appLaunchFunctionProvider(packageName)).maybeWhen(
            data: (launchFunction) => launchFunction,
            orElse: () {
              return null;
            });
    final appLabel = ref.watch(appLabelProvider(packageName)).maybeWhen(
        data: (label) => label, error: (_, __) => 'error', orElse: () => '...');
    return ApplicationIcon(
      applicationIconSize: appIconSize,
      applicationIconImage: appIconImage,
      applicationLaunchFunction: appLaunch,
      applicationLabel: appLabel,
      showApplicationLabel: showAppName,
    );
  }
}
