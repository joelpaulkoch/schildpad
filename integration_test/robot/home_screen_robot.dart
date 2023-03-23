import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/app_drawer/app_drawer.dart';
import 'package:schildpad/home/dock.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/trash.dart';
import 'package:schildpad/settings/settings.dart';

class HomeScreenRobot {
  HomeScreenRobot(this.tester,
      {required this.homeGridColumns,
      required this.homeGridRows,
      this.dockColumns = 4,
      this.dockRows = 1})
      : assert(homeGridColumns > 0),
        assert(homeGridRows > 0);

  final WidgetTester tester;
  final int homeGridColumns;
  final int homeGridRows;
  final int dockColumns;
  final int dockRows;

  Future<void> openAppDrawer() async {
    final homeScreenFinder = find.byType(HomeScreen);
    expect(homeScreenFinder, findsOneWidget);
    await tester.fling(homeScreenFinder, const Offset(0, -100), 500,
        warnIfMissed: false);
    await tester.pumpAndSettle();

    final installedAppsViewFinder = find.byType(AppsView);
    expect(installedAppsViewFinder, findsOneWidget);
  }

  Future<void> openOverview() async {
    final homeScreenFinder = find.byType(HomeScreen);
    expect(homeScreenFinder, findsOneWidget);

    await tester.longPress(homeScreenFinder);
    await tester.pumpAndSettle();
  }

  Future<void> openSettings() async {
    await openOverview();

    final settingsButtonFinder = find.byType(SettingsIconButton);
    expect(settingsButtonFinder, findsOneWidget);

    await tester.tap(settingsButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> openSettingsFromAppDrawer() async {
    final settingsButtonFinder = find.byType(SettingsIconButton);
    expect(settingsButtonFinder, findsOneWidget);

    await tester.tap(settingsButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> dragAndDropApp({Offset? dragOffset}) async {
    final installedAppFinder = find.byType(AppDraggable).first;
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
    await openAppDrawer();

    final installedAppFinder = find.byType(AppDraggable).hitTestable().first;
    expect(installedAppFinder, findsOneWidget);

    const smallOffset = Offset(100, 100);

    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(installedAppFinder));
    await tester.pumpAndSettle();
    await longPressDragGesture.moveBy(smallOffset);
    await tester.pumpAndSettle();

    final dropOffset = _getHomeGridCellCenter(column, row);
    await longPressDragGesture.moveTo(dropOffset);
    await longPressDragGesture.up();
    await tester.pumpAndSettle();
  }

  Future<void> addAppToDock({required int column, int row = 0}) async {
    await openAppDrawer();

    final installedAppFinder = find.byType(AppDraggable).hitTestable().first;
    expect(installedAppFinder, findsOneWidget);

    const smallOffset = Offset(100, 100);

    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(installedAppFinder));
    await tester.pumpAndSettle();
    await longPressDragGesture.moveBy(smallOffset);
    await tester.pumpAndSettle();

    final dropOffset = _getDockGridCellPosition(column, row);
    await longPressDragGesture.moveTo(dropOffset);
    await tester.pumpAndSettle();
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

    final dropOffset = _getHomeGridCellCenter(column, row);
    await longPressDragGesture.moveTo(dropOffset);
    await tester.pumpAndSettle();
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

  Offset _getHomeGridCellCenter(int column, int row) {
    final homeGridFinder = find.byType(HomePage);
    expect(homeGridFinder, findsOneWidget);
    final homeGridOrigin = tester.getTopLeft(homeGridFinder);
    final homeGridSize = tester.getSize(homeGridFinder);

    final xPos = (0.5 + column) / homeGridColumns * homeGridSize.width;
    final yPos = (0.5 + row) / homeGridRows * homeGridSize.height;
    return homeGridOrigin + Offset(xPos, yPos);
  }

  Offset _getDockGridCellPosition(int column, int row) {
    final dockGridFinder = find.byType(Dock);
    expect(dockGridFinder, findsOneWidget);
    final dockGridOrigin = tester.getTopLeft(dockGridFinder);
    final dockGridSize = tester.getSize(dockGridFinder);

    final xPos = (0.5 + column) / dockColumns * dockGridSize.width;
    final yPos = (0.5 + row) / dockRows * dockGridSize.height;
    return dockGridOrigin + Offset(xPos, yPos);
  }
}
