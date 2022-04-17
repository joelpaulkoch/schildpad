import 'package:flutter/material.dart';

class InstalledAppsView extends StatelessWidget {
  const InstalledAppsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Installed Apps'),
      ),
      body: Center(
        child: Text('Installed Apps'),
      ),
    );
  }
}
