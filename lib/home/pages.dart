import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/home/model/page_counter.dart';
import 'package:schildpad/main.dart';

final leftPagesProvider = Provider<int>((ref) {
  return ref.watch(pagesProvider).leftPages;
});

final rightPagesProvider = Provider<int>((ref) {
  return ref.watch(pagesProvider).rightPages;
});

final initialPageProvider = Provider<int>((ref) {
  return ref.watch(leftPagesProvider);
});

final pageCountProvider = Provider<int>((ref) {
  final left = ref.watch(leftPagesProvider);
  final right = ref.watch(rightPagesProvider);
  return left + 1 + right;
});

final pagesProvider = Provider<PageCounter>((ref) {
  ref.watch(isarPagesUpdateProvider);
  final pages = ref
      .watch(pagesIsarProvider)
      .whenOrNull(data: (pageCounter) => pageCounter);
  return pages?.getSync(0) ?? PageCounter(leftPages: 0, rightPages: 0);
});

final pagesIsarProvider =
    FutureProvider<IsarCollection<PageCounter>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return isar.pageCounters;
});

final isarPagesUpdateProvider = StreamProvider<void>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield* isar.pageCounters.watchLazy();
});

final pageCounterManagerProvider = Provider<PageCounterManager>((ref) {
  final isarCollection =
      ref.watch(pagesIsarProvider).whenOrNull(data: (collection) => collection);
  return PageCounterManager(isarCollection);
});

class PageCounterManager {
  PageCounterManager(this.isarCollection);

  final IsarCollection<PageCounter>? isarCollection;

  Future<void> addLeftPage() async {
    final pagesCollection = isarCollection;

    await pagesCollection?.isar.writeTxn(() async {
      final pageCounter = await pagesCollection.get(0);
      final leftPages = pageCounter?.leftPages ?? 0;
      final rightPages = pageCounter?.rightPages ?? 0;
      await pagesCollection
          .put(PageCounter(leftPages: leftPages + 1, rightPages: rightPages));
    });
  }

  Future<void> addRightPage() async {
    final pagesCollection = isarCollection;

    await pagesCollection?.isar.writeTxn(() async {
      final pageCounter = await pagesCollection.get(0);
      final leftPages = pageCounter?.leftPages ?? 0;
      final rightPages = pageCounter?.rightPages ?? 0;
      await pagesCollection
          .put(PageCounter(leftPages: leftPages, rightPages: rightPages + 1));
    });
  }

  Future<void> removeLeftPage() async {
    final pagesCollection = isarCollection;

    await pagesCollection?.isar.writeTxn(() async {
      final pageCounter = await pagesCollection.get(0);
      final leftPages = pageCounter?.leftPages ?? 0;
      final rightPages = pageCounter?.rightPages ?? 0;
      if (leftPages > 0) {
        await pagesCollection
            .put(PageCounter(leftPages: leftPages - 1, rightPages: rightPages));
      }
    });
  }

  Future<void> removeRightPage() async {
    final pagesCollection = isarCollection;

    await pagesCollection?.isar.writeTxn(() async {
      final pageCounter = await pagesCollection.get(0);
      final leftPages = pageCounter?.leftPages ?? 0;
      final rightPages = pageCounter?.rightPages ?? 0;
      if (rightPages > 0) {
        await pagesCollection
            .put(PageCounter(leftPages: leftPages, rightPages: rightPages - 1));
      }
    });
  }
}
