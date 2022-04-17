import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/launcher/installed_apps_view.dart';

import 'launcher/home_view.dart';

void main() {
  runApp(SchildpadApp());
}

class SchildpadApp extends StatelessWidget {
  SchildpadApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeView(),
      ),
      GoRoute(
        path: '/apps',
        builder: (BuildContext context, GoRouterState state) =>
            const InstalledAppsView(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: 'Schildpad',
        theme: ThemeData(useMaterial3: true),
      );
}
