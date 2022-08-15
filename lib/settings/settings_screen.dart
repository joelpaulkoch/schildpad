import 'package:flutter/material.dart';
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
