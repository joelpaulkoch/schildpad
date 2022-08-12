import 'package:flutter/material.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets_view.dart';

class AppWidgetsScreen extends StatelessWidget {
  const AppWidgetsScreen({Key? key}) : super(key: key);

  static const routeName = '/appwidgets';

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        body: AppWidgetsList(),
      ),
    );
  }
}
