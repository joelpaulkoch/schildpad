import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets.dart';
import 'package:schildpad/settings/settings.dart';
import 'package:schildpad/theme/theme.dart';

class AppWidgetsScreen extends StatelessWidget {
  const AppWidgetsScreen({Key? key}) : super(key: key);

  static const routeName = '/appwidgets';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: schildpadSystemUiOverlayStyle,
        title: Text(AppLocalizations.of(context)!.widgetsTitle),
        actions: const [SettingsIconButton()],
      ),
      body: const AppWidgetsList(),
    );
  }
}
