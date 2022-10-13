import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:schildpad/settings/settings.dart';
import 'package:schildpad/theme/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        systemOverlayStyle: schildpadSystemUiOverlayStyle,
      ),
      body: ListView(
        children: const [
          ResetListTile(),
          ContactListTile(),
          SchildpadAboutListTile()
        ],
      ),
    );
  }
}
