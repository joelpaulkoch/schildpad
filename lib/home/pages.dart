import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leftPagesProvider = Provider<int>((ref) {
  return ref.watch(pagesProvider).leftPages;
});

final rightPagesProvider = Provider<int>((ref) {
  return ref.watch(pagesProvider).rightPages;
});

final initialPageProvider = Provider<int>((ref) {
  return ref.watch(leftPagesProvider);
});

final pageCountProvider = Provider<int>((ref) {
  final left = ref.watch(leftPagesProvider);
  final right = ref.watch(rightPagesProvider);
  return left + 1 + right;
});

final pagesProvider =
    StateNotifierProvider<PagesStateNotifier, PageCounter>((ref) {
  return PagesStateNotifier();
});

class PagesStateNotifier extends StateNotifier<PageCounter> {
  PagesStateNotifier() : super(const PageCounter(0, 0));

  void addLeftPage() {
    state = PageCounter(state.leftPages + 1, state.rightPages);
  }

  void addRightPage() {
    state = PageCounter(state.leftPages, state.rightPages + 1);
  }

  void removeLeftPage() {
    if (state.leftPages > 0) {
      state = PageCounter(state.leftPages - 1, state.rightPages);
    }
  }

  void removeRightPage() {
    if (state.rightPages > 0) {
      state = PageCounter(state.leftPages, state.rightPages - 1);
    }
  }
}

class PageCounter extends Equatable {
  const PageCounter(this.leftPages, this.rightPages)
      : assert(leftPages >= 0),
        assert(rightPages >= 0);

  final int leftPages;
  final int rightPages;

  @override
  List<Object?> get props => [leftPages, rightPages];
}

class PagedGridCell extends Equatable {
  const PagedGridCell(this.pageIndex, this.col, this.row);

  final int pageIndex;
  final int col;
  final int row;

  @override
  List<Object> get props => [pageIndex, col, row];
}
