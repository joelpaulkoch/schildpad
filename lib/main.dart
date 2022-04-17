import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';
import 'package:schildpad/theme/theme.dart';

import 'home/home_view.dart';

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
        themeMode: ThemeMode.system,
        theme: SchildpadTheme.lightTheme,
        darkTheme: SchildpadTheme.darkTheme,
      );
}
