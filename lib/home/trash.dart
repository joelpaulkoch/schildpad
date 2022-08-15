import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/dock.dart';
import 'package:schildpad/home/home.dart';

final showTrashProvider = StateProvider<bool>((ref) {
  return false;
});

const double _trashIconSize = 40;

class TrashArea extends ConsumerWidget {
  const TrashArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showTrash = ref.watch(showTrashProvider);
    return showTrash
        ? DragTarget<ElementData>(
            onWillAccept: (_) => true,
            onAccept: (data) {
              final elementOrigin = data.origin;
              final originPageIndex = elementOrigin.pageIndex;
              final originColumn = elementOrigin.column;
              final originRow = elementOrigin.row;

              if (elementOrigin.isOnDock &&
                  originColumn != null &&
                  originRow != null) {
                dev.log(
                    'Trash: removing element from dock ($originColumn, $originRow)');
                ref
                    .read(dockGridStateProvider.notifier)
                    .removeElement(originColumn, originRow);
              } else if (elementOrigin.isOnHome &&
                  originPageIndex != null &&
                  originColumn != null &&
                  originRow != null) {
                dev.log(
                    'Trash: removing element from page $originPageIndex ($originColumn, $originRow)');
                ref
                    .read(homeGridStateProvider(originPageIndex).notifier)
                    .removeElement(originColumn, originRow);
              }
              ref.read(showTrashProvider.notifier).state = false;
            },
            builder: (_, __, ___) => SafeArea(
              child: Card(
                color: Colors.transparent,
                shape: const StadiumBorder(
                  side: BorderSide(
                    color: Colors.red,
                    width: 3,
                  ),
                ),
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 80),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(width: 2)),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: _trashIconSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
