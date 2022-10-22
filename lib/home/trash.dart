import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/model/tile.dart';
import 'package:schildpad/installed_app_widgets/installed_application_widgets.dart';

final showTrashProvider = StateProvider<bool>((ref) {
  return false;
});

const double _trashIconSize = 40;

bool _isAppWidgetData(ElementData data) =>
    data.appData == null && data.appWidgetData != null;

class TrashArea extends ConsumerWidget {
  const TrashArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeTileManager = ref.watch(tileManagerProvider);
    return DragTarget<ElementData>(
      onWillAccept: (_) => true,
      onAccept: (data) async {
        await homeTileManager.removeElement(data.origin);

        if (_isAppWidgetData(data)) {
          final widgetId = data.appWidgetData?.appWidgetId;
          if (widgetId != null) {
            await deleteApplicationWidget(widgetId);
          }
        }

        ref.read(showTrashProvider.notifier).state = false;
      },
      builder: (_, acceptedDrags, ___) => SafeArea(
        child: Card(
          color: acceptedDrags.isEmpty ? Colors.transparent : Colors.red,
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
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: Colors.red),
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: _trashIconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
