import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/pages.dart';
import 'package:schildpad/installed_app_widgets/installed_app_widgets_view.dart';
import 'package:schildpad/installed_apps/installed_apps_view.dart';
import 'package:schildpad/overview/overview_screen.dart';
import 'package:schildpad/settings/settings.dart';
import 'package:schildpad/theme/theme.dart';

Future setUpHive() async {
  await Hive.initFlutter();
  await Hive.openBox<int>(pagesBoxName);
}

Future<void> main() async {
  await setUpHive();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemStatusBarContrastEnforced: true,
    systemNavigationBarContrastEnforced: true,
    // systemNavigationBarColor: Colors.transparent, TODO extend views below system navigation bar
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  runApp(ProviderScope(child: SchildpadApp()));
}

class SchildpadApp extends StatelessWidget {
  SchildpadApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: HomeScreen.routeName,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/apps',
        builder: (BuildContext context, GoRouterState state) =>
            const InstalledAppsView(),
      ),
      GoRoute(
        path: AppWidgetsScreen.routeName,
        builder: (BuildContext context, GoRouterState state) =>
            const AppWidgetsScreen(),
      ),
      GoRoute(
        path: OverviewScreen.routeName,
        builder: (BuildContext context, GoRouterState state) =>
            const OverviewScreen(),
      ),
      GoRoute(
        path: SettingsScreen.routeName,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
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
