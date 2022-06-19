import 'dart:developer' as dev;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

const _columnCount = 4;
const _rowCount = 5;

final appProvider =
    StateProvider.family<AppData?, GridCell>((ref, cell) => null);

final showTrashProvider = StateProvider<bool>((ref) {
  return false;
});

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: _rowCount,
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragEnd: (details) {
                  final primaryVelocity = details.primaryVelocity ?? 0;
                  // on swipe up
                  if (primaryVelocity < 0) {
                    context.push('/apps');
                  }
                },
                child: const HomeViewGrid())),
        const TrashArea()
      ],
    ));
  }
}

class TrashArea extends ConsumerWidget {
  const TrashArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showTrash = ref.watch(showTrashProvider);
    return showTrash
        ? Expanded(
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
            ))
        : const SizedBox.shrink();
  }
}

class HomeViewGrid extends ConsumerWidget {
  const HomeViewGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dev.log('rebuilding HomeViewGrid');
    return Row(
        children: List.generate(
            _columnCount,
            (colIndex) => Expanded(
                    child: Column(
                        children: List.generate(
                  _rowCount,
                  (rowIndex) => Expanded(
                    child: DragTarget<AppData>(onWillAccept: (_) {
                      final currentElement = ref
                          .read(appProvider(GridCell(colIndex, rowIndex))
                              .notifier)
                          .state;
                      return currentElement == null;
                    }, onAccept: (AppData? data) {
                      dev.log(
                          'dropped: ${data?.name} in ($colIndex, $rowIndex)');
                      ref
                          .read(appProvider(GridCell(colIndex, rowIndex))
                              .notifier)
                          .state = data;
                      ref.read(showTrashProvider.notifier).state = false;
                    }, builder: (context, candidates, rejects) {
                      return GridElement(col: colIndex, row: rowIndex);
                    }),
                  ),
                )))));
  }
}

class GridElement extends ConsumerWidget {
  const GridElement({
    Key? key,
    required this.col,
    required this.row,
  }) : super(key: key);

  final int col;
  final int row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dev.log('rebuilding GridElement($col, $row)');
    final app = ref.watch(appProvider(GridCell(col, row)));
    if (app != null) {
      return InstalledAppIcon(
        app: app,
        onDragStarted: () {
          ref.read(showTrashProvider.notifier).state = true;
        },
        onDragCompleted: () {
          ref.read(appProvider(GridCell(col, row)).notifier).state = null;
          dev.log('removing ${app.name} from ($col, $row)');
          ref.read(showTrashProvider.notifier).state = false;
        },
      );
    } else {
      return const SizedBox.expand();
    }
  }
}

class GridCell extends Equatable {
  const GridCell(this.col, this.row);

  final int col;
  final int row;

  @override
  List<Object> get props => [col, row];
}
