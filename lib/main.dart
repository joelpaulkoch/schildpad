import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:schildpad/app_widgets/app_widgets_screen.dart';
import 'package:schildpad/home/home_screen.dart';
import 'package:schildpad/home/model/layout_settings.dart';
import 'package:schildpad/home/model/page_counter.dart';
import 'package:schildpad/home/model/tile.dart';
import 'package:schildpad/overview/overview_screen.dart';
import 'package:schildpad/settings/layout_settings_screen.dart';
import 'package:schildpad/settings/settings_screen.dart';
import 'package:schildpad/theme/theme.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  return await Isar.open([TileSchema, PageCounterSchema, LayoutSettingsSchema]);
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(schildpadSystemUiOverlayStyle);
  runApp(ProviderScope(child: SchildpadApp()));
  await Isar.getInstance()?.close();
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
      GoRoute(
        path: LayoutSettingsScreen.routeName,
        builder: (BuildContext context, GoRouterState state) =>
            const LayoutSettingsScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: 'Schildpad Launcher',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        themeMode: ThemeMode.system,
        theme: SchildpadTheme.lightTheme,
        darkTheme: SchildpadTheme.darkTheme,
      );
}
