import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/dock.dart';
import 'package:schildpad/home/drag_detector.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';
import 'package:schildpad/overview/overview_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeRowCount = ref.watch(homeRowCountProvider);
    final dockRowCount = ref.watch(dockRowCountProvider);
    final homePageController = ref.watch(homePageControllerProvider);
    return SafeArea(
      top: true,
      bottom: true,
      left: false,
      right: false,
      child: BackdropScaffold(
          backgroundColor: Colors.transparent,
          backLayerBackgroundColor: Colors.transparent,
          frontLayerActiveFactor: 0.92,
          headerHeight: 0,
          revealBackLayerAtStart: true,
          frontLayer: Builder(builder: (context) {
            return GestureDetector(
                onVerticalDragEnd: (details) {
                  final primaryVelocity = details.primaryVelocity ?? 0;
                  // on swipe down
                  if (primaryVelocity > 0) {
                    Backdrop.of(context).revealBackLayer();
                  }
                },
                child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is OverscrollNotification) {
                        // overscroll at the top
                        if (scrollNotification.overscroll < 0 &&
                            scrollNotification.velocity == 0) {
                          Backdrop.of(context).revealBackLayer();
                        }
                      }
                      return false;
                    },
                    child: const InstalledAppsView()));
          }),
          backLayer: DragDetector(
            child: Builder(builder: (context) {
              return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onLongPress: () => context.push(OverviewScreen.routeName),
                  onVerticalDragEnd: (details) {
                    final primaryVelocity = details.primaryVelocity ?? 0;
                    // on swipe up
                    if (primaryVelocity < 0) {
                      Backdrop.of(context).concealBackLayer();
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const TrashArea(),
                      Expanded(
                        flex: homeRowCount,
                        child: Align(
                            child: Hero(
                                tag: 'home',
                                child: HomeView(
                                  pageController: homePageController,
                                ))),
                      ),
                      Expanded(
                        flex: dockRowCount,
                        child: const Dock(),
                      )
                    ],
                  ));
            }),
            onDragDetected: () {
              ref.read(showTrashProvider.notifier).state = true;
            },
            onDragEnd: () {},
          )),
    );
  }
}
