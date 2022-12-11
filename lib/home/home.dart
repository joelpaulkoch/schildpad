import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/flexible_grid.dart';
import 'package:schildpad/home/grid.dart';
import 'package:schildpad/home/model/tile.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/home/tile.dart';

final homeColumnCountProvider = Provider<int>((ref) {
  return 4;
});
final homeRowCountProvider = Provider<int>((ref) {
  return 5;
});

final homeTilesProvider =
    FutureProvider.family<List<FlexibleGridTile>, int>((ref, pageIndex) async {
  ref.watch(isarTilesUpdateProvider);

  final columnCount = ref.watch(homeColumnCountProvider);
  final rowCount = ref.watch(homeRowCountProvider);

  final tiles = await ref.watch(isarTilesProvider.future);
  return tiles
      .filter()
      .coordinates(
          (q) => q.locationEqualTo(Location.home).pageEqualTo(pageIndex))
      .findAllSync()
      .map((e) => FlexibleGridTile(
          column: e.coordinates.column,
          row: e.coordinates.row,
          columnSpan: e.columnSpan,
          rowSpan: e.rowSpan,
          child: GridElement(
            coordinates: e.coordinates,
            columnCount: columnCount,
            rowCount: rowCount,
          )))
      .toList();
});

final homePageControllerProvider = Provider<PageController?>((ref) {
  final leftPagesCount = ref.watch(leftPagesProvider);
  final currentPage = ref.watch(currentPageProvider);
  final pagesIsarLoaded = ref
      .watch(pagesIsarProvider)
      .maybeMap(data: (_) => true, orElse: () => false);

  if (pagesIsarLoaded) {
    final pageController = PageController(
        initialPage: schildpadToPageViewIndex(currentPage, leftPagesCount));
    return pageController;
  } else {
    return null;
  }
});

class HomePageView extends ConsumerWidget {
  const HomePageView({Key? key, required this.pageController})
      : super(key: key);

  final PageController? pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageCount = ref.watch(pageCountProvider);
    final leftPagesCount = ref.watch(leftPagesProvider);
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);

    if (pageController != null) {
      return PageView(
          controller: pageController,
          onPageChanged: (page) {
            final schildpadPage =
                pageViewToSchildpadIndex(page, leftPagesCount);
            ref.read(currentPageProvider.notifier).state = schildpadPage;
          },
          physics: const _HomePageViewScrollPhysics(),
          children: List.generate(
              pageCount,
              (index) => HomePage(
                  pageViewToSchildpadIndex(index, leftPagesCount),
                  columnCount,
                  rowCount)));
    } else {
      return const SizedBox.expand();
    }
  }
}

class _HomePageViewScrollPhysics extends ScrollPhysics {
  const _HomePageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  _HomePageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _HomePageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 0.7,
      );
}

class HomePage extends ConsumerWidget {
  const HomePage(
    this.pageIndex,
    this.columnCount,
    this.rowCount, {
    Key? key,
  }) : super(key: key);

  final int pageIndex;
  final int columnCount;
  final int rowCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnCount = ref.watch(homeColumnCountProvider);
    final rowCount = ref.watch(homeRowCountProvider);
    final homeGridTiles = ref.watch(homeTilesProvider(pageIndex)).maybeWhen(
        data: (tiles) => tiles, orElse: () => List<FlexibleGridTile>.empty());

    return Grid(
        location: Location.home,
        page: pageIndex,
        columnCount: columnCount,
        rowCount: rowCount,
        tiles: homeGridTiles);
  }
}
