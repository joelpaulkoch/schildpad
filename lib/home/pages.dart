import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

const _pagesBoxName = 'pages';

final _pagesBoxProvider = FutureProvider<Box<int>>((ref) async {
  return await Hive.openBox<int>(_pagesBoxName);
});

final pagesProvider =
    StateNotifierProvider<PagesStateNotifier, PageCounter>((ref) {
  final hiveBox = ref.watch(_pagesBoxProvider).valueOrNull;
  return PagesStateNotifier(hiveBox: hiveBox);
});

class PagesStateNotifier extends StateNotifier<PageCounter> {
  PagesStateNotifier({this.hiveBox}) : super(const PageCounter(0, 0)) {
    final leftPages = hiveBox?.get('leftPages') ?? 0;
    final rightPages = hiveBox?.get('rightPages') ?? 0;

    state = PageCounter(leftPages, rightPages);
  }

  final Box<int>? hiveBox;

  void addLeftPage() {
    state = PageCounter(state.leftPages + 1, state.rightPages);
    hiveBox?.put('leftPages', state.leftPages);
  }

  void addRightPage() {
    state = PageCounter(state.leftPages, state.rightPages + 1);
    hiveBox?.put('rightPages', state.rightPages);
  }

  void removeLeftPage() {
    if (state.leftPages > 0) {
      state = PageCounter(state.leftPages - 1, state.rightPages);
      hiveBox?.put('leftPages', state.leftPages);
    }
  }

  void removeRightPage() {
    if (state.rightPages > 0) {
      state = PageCounter(state.leftPages, state.rightPages - 1);
      hiveBox?.put('rightPages', state.rightPages);
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
