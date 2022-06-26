import 'dart:developer' as dev;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home_view.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';

final homeColumnCountProvider = Provider<int>((ref) {
  return 4;
});
final homeRowCountProvider = Provider<int>((ref) {
  return 5;
});

final appProvider =
    StateProvider.family<AppData?, GridCell>((ref, cell) => null);

final homeGridPlacementsProvider =
    StateNotifierProvider<HomeGridStateNotifier, List<HomeGridPlacement>>(
        (ref) {
  final columns = ref.watch(homeColumnCountProvider);
  final rows = ref.watch(homeRowCountProvider);
  return HomeGridStateNotifier(columns, rows);
});

class HomeGridStateNotifier extends StateNotifier<List<HomeGridPlacement>> {
  HomeGridStateNotifier(this.columnCount, this.rowCount)
      : isOccupied = List.generate(
            columnCount, (_) => List.generate(rowCount, (_) => false)),
        super(List.generate(
            columnCount,
            (colIndex) => List.generate(
                rowCount,
                (rowIndex) => HomeGridPlacement(
                    columnStart: colIndex,
                    rowStart: rowIndex,
                    columnSpan: 1,
                    rowSpan: 1))).expand((element) => element).toList());

  final int columnCount;
  final int rowCount;
  final List<List<bool>> isOccupied;

  void _occupyCells(GridPlacement placement) {
    final colStart = placement.columnStart;
    final rowStart = placement.rowStart;

    assert(colStart != null);
    assert(rowStart != null);

    for (var col = colStart!; col < colStart + placement.columnSpan; col++) {
      for (var row = rowStart!; row < rowStart + placement.rowSpan; row++) {
        isOccupied[col][row] = true;
      }
    }
  }

  void _freeCells(GridPlacement placement) {
    final colStart = placement.columnStart;
    final rowStart = placement.rowStart;

    assert(colStart != null);
    assert(rowStart != null);

    for (var col = colStart!; col < colStart + placement.columnSpan; col++) {
      for (var row = rowStart!; row < rowStart + placement.rowSpan; row++) {
        isOccupied[col][row] = false;
      }
    }
  }

  bool addPlacement(HomeGridPlacement placement) {
    final columnStart = placement.columnStart;
    final rowStart = placement.rowStart;

    if (columnStart != null &&
        rowStart != null &&
        canAdd(
            columnStart, rowStart, placement.columnSpan, placement.rowSpan)) {
      _occupyCells(placement);
      final placementsToRemove =
          state.where((p) => p.isInside(placement)).toList();
      for (var p in placementsToRemove) {
        state.remove(p);
      }
      state = [...state, placement];
      return true;
    }
    return false;
  }

  void removePlacement(int columnStart, int rowStart) {
    final placementToRemove = state.firstWhere(
        (placement) =>
            placement.columnStart == columnStart &&
            placement.rowStart == rowStart,
        orElse: () => HomeGridPlacement(
            columnStart: -1, rowStart: -1, columnSpan: 0, rowSpan: 0));

    if (state.remove(placementToRemove)) {
      _freeCells(placementToRemove);
      state = [...state];
    }
  }

  bool canAdd(int columnStart, int rowStart, int columnSpan, int rowSpan) {
    if (columnStart + columnSpan > columnCount ||
        rowStart + rowSpan > rowCount) {
      return false;
    }
    for (var col = columnStart; col < columnStart + columnSpan; col++) {
      for (var row = rowStart; row < rowStart + rowSpan; row++) {
        if (isOccupied[col][row]) return false;
      }
    }
    return true;
  }
}

class GridCell extends Equatable {
  const GridCell(this.col, this.row);

  final int col;
  final int row;

  @override
  List<Object> get props => [col, row];
}

class HomeGridPlacement extends GridPlacement {
  HomeGridPlacement({
    Key? key,
    required int columnStart,
    required int rowStart,
    required int columnSpan,
    required int rowSpan,
  }) : super(
            key: key,
            columnStart: columnStart,
            rowStart: rowStart,
            columnSpan: columnSpan,
            rowSpan: rowSpan,
            child: HomeGridTile(columnStart, rowStart));

  bool isInside(HomeGridPlacement other) {
    final colStart = columnStart;
    final otherColStart = other.columnStart;
    final rowStart = this.rowStart;
    final otherRowStart = other.rowStart;
    if (colStart != null &&
        otherColStart != null &&
        rowStart != null &&
        otherRowStart != null) {
      bool colInside = otherColStart <= colStart &&
          colStart + columnSpan <= otherColStart + other.columnSpan;
      bool rowInside = otherRowStart <= rowStart &&
          rowStart + rowSpan <= otherRowStart + other.rowSpan;
      return colInside && rowInside;
    }
    return false;
  }
}

class HomeGridTile extends ConsumerWidget {
  const HomeGridTile(
    this.columnStart,
    this.rowStart, {
    Key? key,
  }) : super(key: key);

  final int columnStart;
  final int rowStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<AppData>(
        onWillAccept: (_) {
          final willAccept =
              ref.read(homeGridPlacementsProvider.notifier).canAdd(
                    columnStart,
                    rowStart,
                    1,
                    1,
                  );
          dev.log('($columnStart, $rowStart) will accept: $willAccept');
          return willAccept;
        },
        onAccept: (AppData? data) {
          dev.log('dropped: ${data?.name} in ($columnStart, $rowStart)');

          if (ref
              .read(homeGridPlacementsProvider.notifier)
              .addPlacement(HomeGridPlacement(
                columnStart: columnStart,
                rowStart: rowStart,
                columnSpan: 1,
                rowSpan: 1,
              ))) {
            ref
                .read(appProvider(GridCell(columnStart, rowStart)).notifier)
                .state = data;
          }

          ref.read(showTrashProvider.notifier).state = false;
        },
        builder: (_, __, ___) => HomeGridElement(columnStart, rowStart));
  }
}

class HomeGridElement extends ConsumerWidget {
  const HomeGridElement(
    this.columnStart,
    this.rowStart, {
    Key? key,
  }) : super(key: key);

  final int columnStart;
  final int rowStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appProvider(GridCell(columnStart, rowStart)));
    if (app != null) {
      return InstalledAppIcon(
          app: app,
          onDragStarted: () {
            ref.read(showTrashProvider.notifier).state = true;
          },
          onDragCompleted: () {
            dev.log('removing ${app.name} from ($columnStart, $rowStart)');
            ref
                .read(appProvider(GridCell(columnStart, rowStart)).notifier)
                .state = null;
            ref
                .read(homeGridPlacementsProvider.notifier)
                .removePlacement(columnStart, rowStart);
          },
          onDraggableCanceled: (_, __) {
            ref.read(showTrashProvider.notifier).state = false;
          });
    }
    return const SizedBox.expand();
  }
}
