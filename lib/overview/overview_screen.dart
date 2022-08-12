import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/overview/overview.dart';
import 'package:schildpad/settings/settings.dart';

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  static const routeName = '/overview';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
        actions: const [SettingsIconButton()],
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      body: Column(
        children: [
          const Expanded(flex: 3, child: HomeView()),
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: AddPageButton(
                        onTap: ref.read(pagesProvider.notifier).addLeftPage)),
                Expanded(
                    child: AddPageButton(
                        onTap: ref.read(pagesProvider.notifier).addRightPage))
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: DeletePageButton(onTap: () {}),
                ),
                const Expanded(
                  child: ShowAppWidgetsButton(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
