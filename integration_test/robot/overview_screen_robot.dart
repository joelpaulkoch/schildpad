import 'package:flutter_test/flutter_test.dart';
import 'package:schildpad/overview/overview.dart';

class OverviewScreenRobot {
  const OverviewScreenRobot(this.tester);

  final WidgetTester tester;

  Future<void> openAppWidgetsScreen() async {
    final appWidgetsButtonFinder = find.byType(ShowAppWidgetsButton);
    expect(appWidgetsButtonFinder, findsOneWidget);
    await tester.tap(appWidgetsButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> addPageOnRightSide() async {
    final addRightPageButtonFinder = find.byType(AddRightPageButton);
    expect(addRightPageButtonFinder, findsOneWidget);
    await tester.tap(addRightPageButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> moveToRightPage() async {
    final moveToRightPageButtonFinder = find.byType(MoveToRightButton);
    expect(moveToRightPageButtonFinder, findsOneWidget);
    await tester.tap(moveToRightPageButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> deletePage() async {
    final deletePageButtonFinder = find.byType(DeletePageButton);
    expect(deletePageButtonFinder, findsOneWidget);
    await tester.tap(deletePageButtonFinder);
    await tester.pumpAndSettle();
  }
}
