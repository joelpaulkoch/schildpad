import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/overview/overview.dart';
import 'package:schildpad/settings/settings.dart';

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  static const routeName = '/overview';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeColumns = ref.watch(homeColumnCountProvider);
    final homeRows = ref.watch(homeRowCountProvider);
    return Scaffold(
      appBar: AppBar(
        actions: const [SettingsIconButton()],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: Align(
                child: AspectRatio(
                    aspectRatio: homeColumns / homeRows,
                    child: const Card(child: HomeView())),
              )),
          Expanded(
            child: Row(
              children: const [
                Expanded(child: AddLeftPageButton()),
                Expanded(child: AddRightPageButton())
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
