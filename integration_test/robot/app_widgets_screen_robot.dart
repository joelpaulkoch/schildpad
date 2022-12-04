import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/model/tile.dart';

class AppWidgetsScreenRobot {
  const AppWidgetsScreenRobot(this.tester,
      {required this.homeGridColumns, required this.homeGridRows});

  final WidgetTester tester;
  final int homeGridColumns;
  final int homeGridRows;

  Future<void> addAppWidget(int column, int row) async {
    // use clock widget for testing because there is no configuration
    final appWidgetGroupFinder = find.text('Clock widgets');
    expect(appWidgetGroupFinder, findsOneWidget);
    await tester.tap(appWidgetGroupFinder);
    await tester.pumpAndSettle();
    final appWidgetFinder =
        find.byType(LongPressDraggable<ElementData>).hitTestable().first;
    expect(appWidgetFinder, findsOneWidget);

    const smallOffset = Offset(100, 100);

    final longPressDragGesture =
        await tester.startGesture(tester.getCenter(appWidgetFinder));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await longPressDragGesture.moveBy(smallOffset);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final dropOffset = getGridCellPosition(column, row);
    await longPressDragGesture.moveTo(dropOffset);
    await longPressDragGesture.up();
    await tester.pumpAndSettle();
  }

  Offset getGridCellPosition(int column, int row) {
    final homeGridFinder = find.byType(HomePage);
    expect(homeGridFinder, findsOneWidget);
    final homeGridOrigin = tester.getTopLeft(homeGridFinder);
    final homeGridSize = tester.getSize(homeGridFinder);

    final xPos = column / homeGridColumns * homeGridSize.width;
    final yPos = row / homeGridRows * homeGridSize.height;
    return homeGridOrigin + Offset(xPos, yPos);
  }
}
