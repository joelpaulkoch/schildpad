import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AppGridHeadingListTile extends StatelessWidget {
  const AppGridHeadingListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.appGridListTile,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class AppGridColumnsListTile extends StatelessWidget {
  const AppGridColumnsListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(AppLocalizations.of(context)!.columns),
        trailing: ToggleSwitch(
          initialLabelIndex: 0,
          totalSwitches: 3,
          labels: const ['3', '4', '5'],
          onToggle: (index) {},
        ));
  }
}

class AppGridRowsListTile extends StatelessWidget {
  const AppGridRowsListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(AppLocalizations.of(context)!.rows),
        trailing: ToggleSwitch(
          initialLabelIndex: 0,
          totalSwitches: 3,
          labels: const ['3', '4', '5'],
          onToggle: (index) {},
        ));
  }
}

class AppDrawerHeadingListTile extends StatelessWidget {
  const AppDrawerHeadingListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.appDrawer,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class AppDrawerRowsListTile extends StatelessWidget {
  const AppDrawerRowsListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(AppLocalizations.of(context)!.rows),
        trailing: ToggleSwitch(
          initialLabelIndex: 0,
          totalSwitches: 3,
          labels: const ['3', '4', '5'],
          onToggle: (index) {},
        ));
  }
}

class DockHeadingListTile extends StatelessWidget {
  const DockHeadingListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.dock,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class DockRowsListTile extends StatelessWidget {
  const DockRowsListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(AppLocalizations.of(context)!.rows),
        trailing: ToggleSwitch(
          initialLabelIndex: 0,
          totalSwitches: 3,
          labels: const ['3', '4', '5'],
          onToggle: (index) {},
        ));
  }
}

class DockAdditionalRowListTile extends StatelessWidget {
  const DockAdditionalRowListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(AppLocalizations.of(context)!.additionalRow),
        value: false,
        onChanged: (_) {});
  }
}

class DockTopListTile extends StatelessWidget {
  const DockTopListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(AppLocalizations.of(context)!.topDock),
        value: false,
        onChanged: (_) {});
  }
}
