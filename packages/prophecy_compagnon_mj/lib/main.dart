import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_mj/ui/app_routes.dart';
import 'package:prophecy_compagnon_mj/ui/main_page.dart';
import 'package:prophecy_compagnon_shared/classes/storage/storage.dart';
import 'package:prophecy_compagnon_shared/register_store_adapters.dart';

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
  registerStoreAdapters();
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
        useMaterial3: true,
        tooltipTheme: TooltipTheme.of(context).copyWith(
          waitDuration: Durations.medium1,
        ),
      ),
    );
  }
}