import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home.dart';

final showTrashProvider = StateProvider<bool>((ref) {
  return false;
});

class TrashArea extends ConsumerWidget {
  const TrashArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showTrash = ref.watch(showTrashProvider);
    return showTrash
        ? Expanded(
            child: DragTarget<HomeGridElementData>(
            onWillAccept: (_) => true,
            onAccept: (data) {
              final originPageIndex = data.originPageIndex;
              final originColumn = data.originColumn;
              final originRow = data.originRow;
              if (originPageIndex != null &&
                  originColumn != null &&
                  originRow != null) {
                ref
                    .read(homeGridStateProvider(originPageIndex).notifier)
                    .removeElement(originColumn, originRow);
              }
            },
            builder: (_, __, ___) => Material(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(width: 2)),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                  ),
                ),
              ),
            ),
          ))
        : const SizedBox.shrink();
  }
}
