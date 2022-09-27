import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                applicationName: 'Schildpad Launcher',
                applicationIcon: SizedBox(
                    width: IconTheme.of(context).size,
                    height: IconTheme.of(context).size,
                    child: _schildpadLogo)),
          ),
        ],
      ),
    );
  }
}

final Widget _schildpadLogo = SvgPicture.asset('assets/schildpad_logo.svg',
    semanticsLabel: 'Schildpad Logo');

class ResetListTile extends ConsumerWidget {
  const ResetListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
        leading: const Icon(Icons.delete_forever_rounded),
        title: Text(AppLocalizations.of(context)!.resetListTile),
        onTap: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!
                        .resetConfirmationDialogTitle),
                    content: Text(AppLocalizations.of(context)!
                        .resetConfirmationDialogText),
                    actions: [
                      TextButton(
                          onPressed: Navigator.of(context).pop,
                          child: Text(AppLocalizations.of(context)!
                              .resetConfirmationDialogText)),
                      const ResetButton()
                    ],
                  ));
        });
  }
}

class ResetButton extends ConsumerWidget {
  const ResetButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: () {
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
          Navigator.of(context).pop();
        },
        child: Text(AppLocalizations.of(context)!
            .resetConfirmationDialogConfirmButton));
  }
}
