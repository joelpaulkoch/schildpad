import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home_grid.dart';
import 'package:schildpad/home/pages.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageCount = ref.watch(pageCountProvider);
    final leftPagesCount = ref.watch(leftPagesProvider);
    final initialPage = ref.watch(initialPageProvider);
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);
    final pageController = PageController(initialPage: initialPage);
    return PageView(
        controller: pageController,
        children: List.generate(
            pageCount,
            (index) =>
                HomeViewGrid(index - leftPagesCount, columnCount, rowCount)));
  }
}
