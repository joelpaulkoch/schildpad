import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/home/tile_manager.dart';
import 'package:schildpad/installed_app_widgets/app_widgets_screen.dart';
import 'package:schildpad/overview/overview_screen.dart';

class ShowAppWidgetsButton extends StatelessWidget {
  const ShowAppWidgetsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => context.push(AppWidgetsScreen.routeName),
        icon: const Icon(
          Icons.now_widgets_outlined,
        ));
  }
}

class DeletePageButton extends ConsumerWidget {
  const DeletePageButton({Key? key, required this.page}) : super(key: key);

  final int page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leftPages = ref.watch(leftPagesProvider);
    final rightPages = ref.watch(rightPagesProvider);
    final onLeftMostPage = page == -leftPages;
    final onRightMostPage = page == rightPages;
    final onOuterPage = (onLeftMostPage || onRightMostPage) && (page != 0);
    final tileManager = ref.watch(tileManagerProvider);
    final pageCounterManager = ref.watch(pageCounterManagerProvider);

    return IconButton(
        onPressed: onOuterPage
            ? () async {
                await tileManager.removeAll();
                if (page < 0) {
                  await pageCounterManager.removeLeftPage();
                  ref.read(currentHomePageProvider.notifier).state++;
                }
                if (page > 0) {
                  await pageCounterManager.removeRightPage();
                  ref.read(currentHomePageProvider.notifier).state--;
                }
              }
            : null,
        icon: const Icon(Icons.delete_outline_rounded));
  }
}

class AddLeftPageButton extends ConsumerWidget {
  const AddLeftPageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageCounterManager = ref.watch(pageCounterManagerProvider);
    return IconButton(
        onPressed: () async => await pageCounterManager.addLeftPage(),
        icon: const Icon(Icons.add));
  }
}

class AddRightPageButton extends ConsumerWidget {
  const AddRightPageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageCounterManager = ref.watch(pageCounterManagerProvider);
    return IconButton(
        onPressed: () async => await pageCounterManager.addRightPage(),
        icon: const Icon(Icons.add));
  }
}

class MoveToLeftButton extends ConsumerWidget {
  const MoveToLeftButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewPageController = ref.watch(overviewPageControllerProvider);
    final leftPagesCount = ref.watch(leftPagesProvider);
    final currentPage = ref.watch(currentHomePageProvider);
    final page = schildpadToPageViewIndex(currentPage, leftPagesCount);
    return IconButton(
        onPressed: () {
          overviewPageController.jumpToPage(page - 1);
        },
        icon: const Icon(Icons.chevron_left));
  }
}

class MoveToRightButton extends ConsumerWidget {
  const MoveToRightButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewPageController = ref.watch(overviewPageControllerProvider);
    final leftPagesCount = ref.watch(leftPagesProvider);
    final currentPage = ref.watch(currentHomePageProvider);
    final page = schildpadToPageViewIndex(currentPage, leftPagesCount);
    return IconButton(
        onPressed: () {
          overviewPageController.jumpToPage(page + 1);
        },
        icon: const Icon(Icons.chevron_right));
  }
}
