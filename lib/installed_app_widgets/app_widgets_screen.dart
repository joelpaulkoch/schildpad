import 'package:flutter/material.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets_view.dart';
import 'package:schildpad/settings/settings.dart';

class AppWidgetsScreen extends StatelessWidget {
  const AppWidgetsScreen({Key? key}) : super(key: key);

  static const routeName = '/appwidgets';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widgets'),
        actions: const [SettingsIconButton()],
      ),
      body: const AppWidgetsList(),
    );
  }
}
