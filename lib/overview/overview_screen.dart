import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home_view.dart';
import 'package:schildpad/home/pages.dart';

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  static const routeName = '/overview';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: const [
                Expanded(
                  child: SettingsButton(),
                ),
              ],
            ),
          ),
          const Expanded(child: HomeView()),
          Expanded(
            child: Row(
              children: [
                Expanded(child: AddPageButton(onPressed: () {
                  ref.read(pagesProvider.notifier).addLeftPage();
                })),
                Expanded(child: AddPageButton(onPressed: () {
                  ref.read(pagesProvider.notifier).addRightPage();
                }))
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: DeletePageButton(onPressed: () {}),
                ),
                Expanded(
                  child: ShowAppWidgetsButton(
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ShowAppWidgetsButton extends StatelessWidget {
  const ShowAppWidgetsButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {}, icon: const Icon(Icons.now_widgets_outlined));
  }
}

class DeletePageButton extends StatelessWidget {
  const DeletePageButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {}, icon: const Icon(Icons.delete_outline_rounded));
  }
}

class AddPageButton extends StatelessWidget {
  const AddPageButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.add));
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.settings_outlined,
        color: Colors.white,
      ),
      onPressed: () {},
      splashRadius: 20,
    );
  }
}
