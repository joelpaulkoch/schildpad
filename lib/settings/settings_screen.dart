import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/home/dock.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/theme/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        systemOverlayStyle: schildpadSystemUiOverlayStyle,
      ),
      body: ListView(
        children: [
          ResetListTile(),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Schildpad',
            ),
          ),
        ],
      ),
    );
  }
}

class ResetListTile extends ConsumerWidget {
  const ResetListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
        leading: const Icon(Icons.delete_forever_rounded),
        title: const Text('Reset'),
        onTap: () {
          ref.read(dockGridStateProvider.notifier).removeAll();

          final leftPages = ref.read(leftPagesProvider);
          for (var i = -leftPages; i < 0; i++) {
            ref.read(homeGridStateProvider(i).notifier).removeAll();
            ref.read(pagesProvider.notifier).removeLeftPage();
          }
          final rightPages = ref.read(rightPagesProvider);
          for (var i = rightPages; i > 0; i--) {
            ref.read(homeGridStateProvider(i).notifier).removeAll();
            ref.read(pagesProvider.notifier).removeRightPage();
          }
          ref.read(homeGridStateProvider(0).notifier).removeAll();
        });
  }
}
