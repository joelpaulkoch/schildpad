import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/home/home.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/settings/app_info.dart';
import 'package:schildpad/settings/settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.settings_outlined,
      ),
      onPressed: () => context.push(SettingsScreen.routeName),
      splashRadius: 20,
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
    final tileManager = ref.watch(tileManagerProvider);
    final pageCounterManager = ref.watch(pageCounterManagerProvider);

    return TextButton(
        onPressed: () {
          tileManager.removeAll();

          final leftPages = ref.read(leftPagesProvider);
          for (var i = -leftPages; i < 0; i++) {
            pageCounterManager.removeLeftPage();
          }
          final rightPages = ref.read(rightPagesProvider);
          for (var i = rightPages; i > 0; i--) {
            pageCounterManager.removeRightPage();
          }
          Navigator.of(context).pop();
        },
        child: Text(AppLocalizations.of(context)!
            .resetConfirmationDialogConfirmButton));
  }
}

class ContactListTile extends StatelessWidget {
  const ContactListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.contact_support_outlined),
      title: Text(
        AppLocalizations.of(context)!.contactListTile,
      ),
      onTap: _contactSchildpad,
    );
  }
}

final Uri _contactUrl = Uri.parse('mailto:contact@schildpad.app');

Future<void> _contactSchildpad() async {
  if (!await launchUrl(_contactUrl)) {
    throw 'Could not launch $_contactUrl';
  }
}

class SchildpadAboutListTile extends ConsumerWidget {
  const SchildpadAboutListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schildpadVersion = ref.watch(schildpadVersionProvider);
    final schildpadAppName = ref.watch(schildpadAppNameProvider);
    return AboutListTile(
        icon: const Icon(Icons.info_outline_rounded),
        applicationName: schildpadAppName,
        applicationIcon: SizedBox(
            width: IconTheme.of(context).size,
            height: IconTheme.of(context).size,
            child: schildpadLogo),
        applicationVersion: schildpadVersion);
  }
}
