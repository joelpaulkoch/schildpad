import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leftPagesProvider = StateProvider<int>((ref) {
  return 0;
});

final rightPagesProvider = StateProvider<int>((ref) {
  return 0;
});

final initialPageProvider = Provider<int>((ref) {
  return ref.watch(leftPagesProvider);
});

final pageCountProvider = Provider<int>((ref) {
  final left = ref.watch(leftPagesProvider);
  final right = ref.watch(rightPagesProvider);
  return left + 1 + right;
});

class PagedGridCell extends Equatable {
  const PagedGridCell(this.pageIndex, this.col, this.row);

  final int pageIndex;
  final int col;
  final int row;

  @override
  List<Object> get props => [pageIndex, col, row];
}
