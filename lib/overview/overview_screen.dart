import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/overview/overview.dart';
import 'package:schildpad/settings/settings.dart';
import 'package:schildpad/theme/theme.dart';

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  static const routeName = '/overview';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: schildpadSystemUiOverlayStyle,
        actions: const [SettingsIconButton()],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: GestureDetector(
                  onTap: () => context.go(HomeScreen.routeName),
                  child:
                      const Card(child: Hero(tag: 'home', child: HomeView())))),
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
