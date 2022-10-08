import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/settings/app_info.dart';
import 'package:schildpad/settings/settings.dart';
import 'package:schildpad/theme/theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schildpadVersion = ref.watch(schildpadVersionProvider);
    final schildpadAppName = ref.watch(schildpadAppNameProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        systemOverlayStyle: schildpadSystemUiOverlayStyle,
      ),
      body: ListView(
        children: [
          const ResetListTile(),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(AppLocalizations.of(context)!.aboutListTile),
            onTap: () => showAboutDialog(
                context: context,
                applicationName: schildpadAppName,
                applicationIcon: SizedBox(
                    width: IconTheme.of(context).size,
                    height: IconTheme.of(context).size,
                    child: schildpadLogo),
                applicationVersion: schildpadVersion),
          ),
        ],
      ),
    );
  }
}
