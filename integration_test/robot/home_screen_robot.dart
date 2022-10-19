import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/home/dock.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/installed_apps/installed_apps.dart';

class HomeScreenRobot {
  HomeScreenRobot(this.tester,
      {required this.homeGridColumns, required this.homeGridRows})
      : assert(homeGridColumns > 0),
        assert(homeGridRows > 0);

  final WidgetTester tester;
  final int homeGridColumns;
  final int homeGridRows;

  Future<void> openAppList() async {
    final homeScreenFinder = find.byType(HomeScreen);
    expect(homeScreenFinder, findsOneWidget);
    await tester.fling(homeScreenFinder, const Offset(0, -100), 500,
        warnIfMissed: false);
    await tester.pumpAndSettle();

    final installedAppsViewFinder = find.byType(InstalledAppsView);
    expect(installedAppsViewFinder, findsOneWidget);
  }

  Future<void> dragAndDropApp({Offset? dragOffset}) async {
    final installedAppFinder = find.byType(InstalledAppDraggable).first;
    expect(installedAppFinder, findsOneWidget);

    final offset = dragOffset ?? const Offset(100, 100);

    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(installedAppFinder));
    await tester.pumpAndSettle();
    await longPressDragGesture.moveBy(offset);
    await tester.pumpAndSettle();
    await longPressDragGesture.up();
    await tester.pumpAndSettle();
  }

  Future<void> dragAppBy(Finder appFinder, Offset offset) async {
    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(appFinder));
    await tester.pumpAndSettle();
    await longPressDragGesture.moveBy(offset);
  }

  Future<void> dragAppTo(Finder appFinder, Offset position) async {
    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(appFinder));
    await tester.pumpAndSettle();
    await longPressDragGesture.moveTo(position);
  }

  Future<void> addAppToHome(int column, int row) async {
    await openAppList();

    final installedAppFinder =
        find.byType(InstalledAppDraggable).hitTestable().first;
    expect(installedAppFinder, findsOneWidget);

    const smallOffset = Offset(100, 100);

    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(installedAppFinder));
    await tester.pumpAndSettle();
    await longPressDragGesture.moveBy(smallOffset);
    await tester.pumpAndSettle();

    final dropOffset = _getHomeGridCellPosition(column, row);
    await longPressDragGesture.moveTo(dropOffset);
    await longPressDragGesture.up();
    await tester.pumpAndSettle();
  }

  Future<void> addAppToDock(int column) async {
    await openAppList();

    final installedAppFinder =
        find.byType(InstalledAppDraggable).hitTestable().first;
    expect(installedAppFinder, findsOneWidget);

    const smallOffset = Offset(100, 100);

    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(installedAppFinder));
    await tester.pumpAndSettle();
    await longPressDragGesture.moveBy(smallOffset);
    await tester.pumpAndSettle();

    final dropOffset = _getDockGridCellPosition(column);
    await longPressDragGesture.moveTo(dropOffset);
    await longPressDragGesture.up();
    await tester.pumpAndSettle();
  }

  Future<void> moveAppTo(Finder appFinder, int column, int row) async {
    const smallOffset = Offset(100, 100);
    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(appFinder));
    await tester.pumpAndSettle();
    await longPressDragGesture.moveBy(smallOffset);
    await tester.pumpAndSettle();

    final dropOffset = _getHomeGridCellPosition(column, row);
    await longPressDragGesture.moveTo(dropOffset);
    await longPressDragGesture.up();
    await tester.pumpAndSettle();
  }

  Future<void> dropAppInTrash(Finder appFinder) async {
    const smallOffset = Offset(100, 100);
    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(appFinder));
    await tester.pumpAndSettle();
    await longPressDragGesture.moveBy(smallOffset);
    await tester.pumpAndSettle();

    final trashAreaFinder = find.byType(TrashArea);
    expect(trashAreaFinder, findsOneWidget);
    final trashPosition = tester.getCenter(trashAreaFinder);
    await longPressDragGesture.moveTo(trashPosition);
    await tester.pumpAndSettle();

    await longPressDragGesture.up();
    await tester.pumpAndSettle();
  }

  Offset _getHomeGridCellPosition(int column, int row) {
    final homeGridFinder = find.byType(HomeViewGrid);
    expect(homeGridFinder, findsOneWidget);
    final homeGridOrigin = tester.getTopLeft(homeGridFinder);
    final homeGridSize = tester.getSize(homeGridFinder);

    final xPos = column / homeGridColumns * homeGridSize.width;
    final yPos = row / homeGridRows * homeGridSize.height;
    return homeGridOrigin + Offset(xPos, yPos);
  }

  Offset _getDockGridCellPosition(int column) {
    final dockGridFinder = find.byType(DockGrid);
    expect(dockGridFinder, findsOneWidget);
    final dockGridOrigin = tester.getTopLeft(dockGridFinder);
    final dockGridSize = tester.getSize(dockGridFinder);

    final xPos = column / homeGridColumns * dockGridSize.width +
        0.5 * dockGridSize.width;
    return dockGridOrigin + Offset(xPos, dockGridSize.height / 2);
  }
}
