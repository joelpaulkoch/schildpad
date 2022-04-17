import 'package:flutter/material.dart';

class InstalledAppsView extends StatelessWidget {
  const InstalledAppsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        pinned: false,
        snap: false,
        floating: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return SizedBox.expand();
        }),
      )
    ]));
  }
}
