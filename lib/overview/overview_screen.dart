import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/dock.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/overview/overview.dart';
import 'package:schildpad/settings/settings.dart';
import 'package:schildpad/theme/theme.dart';

final overviewPageControllerProvider = Provider<PageController>((ref) {
  final leftPagesCount = ref.watch(leftPagesProvider);
  final currentPage = ref.watch(currentPageProvider);

  final pageController = PageController(
      initialPage: schildpadToPageViewIndex(currentPage, leftPagesCount));
  return pageController;
});

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  static const routeName = '/overview';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeRowCount = ref.watch(homeRowCountProvider);
    final dockRowCount = ref.watch(dockRowCountProvider);
    final totalRows = homeRowCount + dockRowCount;
    final currentPage = ref.watch(currentPageProvider);
    final leftPages = ref.watch(leftPagesProvider);
    final rightPages = ref.watch(rightPagesProvider);
    final onLeftMostPage = currentPage == -leftPages;
    final onRightMostPage = currentPage == rightPages;
    final overviewPageController = ref.watch(overviewPageControllerProvider);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: schildpadSystemUiOverlayStyle,
        actions: const [SettingsIconButton()],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: onLeftMostPage
                        ? const AddLeftPageButton()
                        : const MoveToLeftButton(),
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: () => context.go(HomeScreen.routeName),
                        child: AspectRatio(
                            aspectRatio: _approxHomeViewAspectRatio(
                                context, homeRowCount, totalRows),
                            child: Card(
                                child: Hero(
                                    tag: 'home',
                                    child: HomePageView(
                                      pageController: overviewPageController,
                                    ))))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: onRightMostPage
                        ? const AddRightPageButton()
                        : const MoveToRightButton(),
                  ),
                ],
              )),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: DeletePageButton(page: currentPage),
                ),
                const Expanded(
                  child: ShowAppWidgetsButton(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

double _approxHomeViewAspectRatio(
    BuildContext context, int homeRowCount, int totalRows) {
  final homeViewWidth = MediaQuery.of(context).size.width;
  final displayHeight = MediaQuery.of(context).size.height;
  final homeViewHeight = displayHeight * homeRowCount / totalRows;
  return homeViewWidth / homeViewHeight;
}
