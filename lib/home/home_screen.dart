import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/drag_detector.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/home/home_view.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rowCount = ref.watch(homeRowCountProvider);
    final showTrash = ref.watch(showTrashProvider);
    return SafeArea(
        child: DragDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showTrash) const Expanded(flex: 1, child: TrashArea()),
          Expanded(
              flex: rowCount,
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onVerticalDragEnd: (details) {
                    final primaryVelocity = details.primaryVelocity ?? 0;
                    // on swipe up
                    if (primaryVelocity < 0) {
                      context.push('/apps');
                    }
                  },
                  onLongPress: () => context.push(AppWidgetsScreen.routeName),
                  child: const HomeView())),
        ],
      ),
      onDragDetected: () {},
    ));
  }
}
