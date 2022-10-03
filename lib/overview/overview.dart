import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/installed_app_widgets/app_widgets_screen.dart';

class ShowAppWidgetsButton extends StatelessWidget {
  const ShowAppWidgetsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => context.push(AppWidgetsScreen.routeName),
        icon: const Icon(
          Icons.now_widgets_outlined,
        ));
  }
}

class DeletePageButton extends StatelessWidget {
  const DeletePageButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onTap, icon: const Icon(Icons.delete_outline_rounded));
  }
}

class AddLeftPageButton extends ConsumerWidget {
  const AddLeftPageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: ref.read(pagesProvider.notifier).addLeftPage,
        icon: const Icon(Icons.add));
  }
}

class AddRightPageButton extends ConsumerWidget {
  const AddRightPageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: ref.read(pagesProvider.notifier).addRightPage,
        icon: const Icon(Icons.add));
  }
}

class MoveToLeftButton extends ConsumerWidget {
  const MoveToLeftButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left));
  }
}

class MoveToRightButton extends ConsumerWidget {
  const MoveToRightButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right));
  }
}
