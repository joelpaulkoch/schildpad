import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:schildpad/settings/layout_settings.dart';
import 'package:schildpad/theme/theme.dart';

class LayoutSettingsScreen extends StatelessWidget {
  const LayoutSettingsScreen({Key? key}) : super(key: key);

  static const routeName = '/settings/layout';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.layoutSettingsTitle),
        systemOverlayStyle: schildpadSystemUiOverlayStyle,
      ),
      body: ListView(
        children: const [
          AppGridHeadingListTile(),
          AppGridColumnsListTile(),
          AppGridRowsListTile(),
          Divider(),
          AppDrawerHeadingListTile(),
          AppDrawerRowsListTile(),
          Divider(),
          DockHeadingListTile(),
          DockRowsListTile(),
          DockAdditionalRowListTile(),
          DockTopListTile(),
        ],
      ),
    );
  }
}
