import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'classes/storage/storage.dart';

import 'ui/app_routes.dart';
import 'ui/main_page.dart';

final _goRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return MainPage(pageWidget: child);
      },
      routes: buildRouteList(),
    )
  ]
);

void main() async {
  usePathUrlStrategy();
  await DataStorage.instance.init();
  runApp(const ProphecyCompanionApp());
}

class ProphecyCompanionApp extends StatelessWidget {
  const ProphecyCompanionApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Prophecy Compagnon',
      routerConfig: _goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        tooltipTheme: TooltipTheme.of(context).copyWith(
          waitDuration: Durations.medium1,
        ),
      ),
    );
  }
}