import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home_grid.dart';

final showTrashProvider = StateProvider<bool>((ref) {
  return false;
});

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rowCount = ref.watch(homeRowCountProvider);
    final showTrash = ref.watch(showTrashProvider);
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
                child: const HomeViewGrid())),
      ],
    ));
  }
}

class HomeViewGrid extends ConsumerWidget {
  const HomeViewGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridPlacements = ref.watch(homeGridPlacementsProvider);
    final columns = ref.watch(homeColumnCountProvider);
    final rows = ref.watch(homeRowCountProvider);
    dev.log('rebuilding HomeViewGrid');

    return LayoutGrid(
      columnSizes: List.filled(columns, 1.fr),
      rowSizes: List.filled(rows, 1.fr),
      children: gridPlacements,
    );
  }
}

class TrashArea extends ConsumerWidget {
  const TrashArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        flex: 1,
        child: DragTarget(
          onWillAccept: (_) => true,
          onAccept: (_) {
            ref.read(showTrashProvider.notifier).state = false;
          },
          builder: (_, __, ___) => Material(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2)),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ));
  }
}
