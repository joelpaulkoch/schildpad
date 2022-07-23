import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/pages.dart';

void main() {
  group('PagesStateNotifier tests', () {
    setUpAll(() async {
      await Hive.initFlutter();
      await Hive.openBox<int>(pagesBoxName);
    });
    test('A new PagesStateNotifier should have 0 left and 0 right pages', () {
      final pagesStateNotifier = PagesStateNotifier();
      expect(pagesStateNotifier.debugState.leftPages, 0);
      expect(pagesStateNotifier.debugState.rightPages, 0);
    });
    test('Adding a left page should increase leftPages by 1', () {
      final pagesStateNotifier = PagesStateNotifier();
      final leftPagesBefore = pagesStateNotifier.debugState.leftPages;
      pagesStateNotifier.addLeftPage();
      expect(pagesStateNotifier.debugState.leftPages, leftPagesBefore + 1);
    });
    test('Adding a right page should increase rightPages by 1', () {
      final pagesStateNotifier = PagesStateNotifier();
      final rightPagesBefore = pagesStateNotifier.debugState.rightPages;
      pagesStateNotifier.addRightPage();
      expect(pagesStateNotifier.debugState.rightPages, rightPagesBefore + 1);
    });

    test('Removing a left page should decrease leftPages by 1', () {
      final pagesStateNotifier = PagesStateNotifier();
      pagesStateNotifier.addLeftPage();
      final leftPagesBefore = pagesStateNotifier.debugState.leftPages;
      pagesStateNotifier.removeLeftPage();
      expect(pagesStateNotifier.debugState.leftPages, leftPagesBefore - 1);
    });
    test('Removing a right page should decrease rightPages by 1', () {
      final pagesStateNotifier = PagesStateNotifier();
      pagesStateNotifier.addRightPage();
      final rightPagesBefore = pagesStateNotifier.debugState.rightPages;
      pagesStateNotifier.removeRightPage();
      expect(pagesStateNotifier.debugState.rightPages, rightPagesBefore - 1);
    });

    test('Removing a left page when leftPages is 0 should do nothing', () {
      final pagesStateNotifier = PagesStateNotifier();
      expect(pagesStateNotifier.debugState.leftPages, 0);
      pagesStateNotifier.removeLeftPage();
      expect(pagesStateNotifier.debugState.leftPages, 0);
    });
    test('Removing a right page when rightPages is 0 should do nothing', () {
      final pagesStateNotifier = PagesStateNotifier();
      expect(pagesStateNotifier.debugState.rightPages, 0);
      pagesStateNotifier.removeRightPage();
      expect(pagesStateNotifier.debugState.rightPages, 0);
    });
  });
}
