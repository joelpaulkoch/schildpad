import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showTrashProvider = StateProvider<bool>((ref) {
  return false;
});

class TrashArea extends ConsumerWidget {
  const TrashArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        flex: 1,
        child: DragTarget(
          onWillAccept: (_) => true,
          onAccept: (_) {
            ref.read(showTrashProvider.notifier).state = false;
          },
          builder: (_, __, ___) => Material(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2)),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ));
  }
}
