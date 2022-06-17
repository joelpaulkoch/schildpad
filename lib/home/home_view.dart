import 'dart:developer' as dev;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

const _columnCount = 4;
const _rowCount = 5;

final _appProvider =
    StateProvider.family<AppData?, GridCell>((ref, cell) => null);

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragEnd: (details) {
              final primaryVelocity = details.primaryVelocity ?? 0;
              // on swipe up
              if (primaryVelocity < 0) {
                context.push('/apps');
              }
            },
            child: const HomeViewGrid()));
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
                    child: DragTarget<AppData>(onAccept: (AppData? data) {
                      dev.log(
                          'dropped: ${data?.name} in ($colIndex, $rowIndex)');
                      ref
                          .read(_appProvider(GridCell(colIndex, rowIndex))
                              .notifier)
                          .state = data;
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
    final app = ref.watch(_appProvider(GridCell(col, row)));
    if (app != null) {
      return InstalledAppIcon(
        app: app,
        onDragCompleted: () {
          ref.read(_appProvider(GridCell(col, row)).notifier).state = null;
          dev.log('removing ${app.name} from ($col, $row)');
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
