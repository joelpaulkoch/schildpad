import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/home/trash.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rowCount = ref.watch(homeRowCountProvider);
    final showTrash = ref.watch(showTrashProvider);
    final pageCount = ref.watch(pageCountProvider);
    final leftPagesCount = ref.watch(leftPagesProvider);
    final initialPage = ref.watch(initialPageProvider);
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTrash) const TrashArea(),
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
                onLongPress: () => context.push('/widgets'),
                child: PageView(
                    controller: PageController(initialPage: initialPage),
                    children: List.generate(pageCount,
                        (index) => HomeViewGrid(index - leftPagesCount))))),
      ],
    ));
  }
}
