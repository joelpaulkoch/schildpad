import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/settings/settings_screen.dart';

class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.settings_outlined,
        color: Colors.white,
      ),
      onPressed: () => context.push(SettingsScreen.routeName),
      splashRadius: 20,
    );
  }
}
