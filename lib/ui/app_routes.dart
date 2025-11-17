import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'creatures/clone.dart';
import 'creatures/create.dart';
import 'creatures/edit.dart';
import 'creatures/list.dart';
import 'factions/main.dart';
import 'non_player_character/clone.dart';
import 'non_player_character/create.dart';
import 'non_player_character/edit.dart';
import 'non_player_character/list.dart';
import 'places/main.dart';
import 'scenario/edit.dart';
import 'scenario/list.dart';
import 'session/list.dart';
import 'spells/main.dart';
import 'stars/clone.dart';
import 'stars/create.dart';
import 'stars/edit.dart';
import 'stars/list.dart';
import 'table/edit.dart';
import 'table/list.dart';
import 'utils/custom_icons.dart';
import 'welcome_page.dart';

class MainAppRoute {
  MainAppRoute({
    required this.path,
    required this.builder,
    this.routes = const <MainAppRoute>[],
    this.icon,
    this.label,
    this.isFullScreen = false,
  });

  final String path;
  final GoRouterWidgetBuilder builder;
  final List<MainAppRoute> routes;
  final Widget? icon;
  final Widget? label;
  bool isFullScreen;
}

final mainAppRoutes = [
  MainAppRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) =>
      const WelcomePage(),
  ),
  MainAppRoute(
    path: '/sessions',
    builder: (BuildContext context, GoRouterState state) =>
      const SessionsListPage(),
    icon: Icon(Symbols.tactic_rounded),
    label: Text('Sessions'),
  ),
  MainAppRoute(
    path: '/tables',
    builder: (BuildContext context, GoRouterState state) =>
      const TablesListPage(),
    icon: Icon(Symbols.groups),
    label: Text('Tables'),
    routes: [
      MainAppRoute(
        path: '/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          TableEditPage(
            uuid: state.pathParameters['uuid']!,
          ),
        isFullScreen: true,
        routes: [
          MainAppRoute(
            path: '/pc/:pcUuid',
            builder: (BuildContext context, GoRouterState state) =>
              TableEditPage(
                uuid: state.pathParameters['uuid']!,
                selectedPcId: state.pathParameters['pcUuid']!,
              ),
            isFullScreen: true,
          ),
        ]
      ),
    ]
  ),
  MainAppRoute(
    path: '/scenarios',
    builder: (BuildContext context, GoRouterState state) =>
      const ScenariosListPage(),
    icon: Icon(Symbols.book),
    label: Text('Scénarios'),
    routes: [
      MainAppRoute(
        path: '/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          ScenarioEditPage(uuid: state.pathParameters['uuid']!),
        isFullScreen: true,
        routes: [
          MainAppRoute(
            path: '/events',
            builder: (BuildContext context, GoRouterState state) =>
              ScenarioEditPage(
                uuid: state.pathParameters['uuid']!,
                initialTab: ScenarioEditTab.events
              ),
          ),
          MainAppRoute(
            path: '/npcs',
            builder: (BuildContext context, GoRouterState state) =>
              ScenarioEditPage(
                uuid: state.pathParameters['uuid']!,
                initialTab: ScenarioEditTab.npcs
              ),
          ),
          MainAppRoute(
            path: '/creatures',
            builder: (BuildContext context, GoRouterState state) =>
              ScenarioEditPage(
                uuid: state.pathParameters['uuid']!,
                initialTab: ScenarioEditTab.creatures
              ),
          ),
          MainAppRoute(
            path: '/places',
            builder: (BuildContext context, GoRouterState state) =>
              ScenarioEditPage(
                uuid: state.pathParameters['uuid']!,
                initialTab: ScenarioEditTab.places
              ),
          ),
          MainAppRoute(
            path: '/factions',
            builder: (BuildContext context, GoRouterState state) =>
              ScenarioEditPage(
                uuid: state.pathParameters['uuid']!,
                initialTab: ScenarioEditTab.factions
              ),
          ),
          MainAppRoute(
            path: '/encounters',
            builder: (BuildContext context, GoRouterState state) =>
              ScenarioEditPage(
                uuid: state.pathParameters['uuid']!,
                initialTab: ScenarioEditTab.encounters
              ),
          ),
          MainAppRoute(
            path: '/maps',
            builder: (BuildContext context, GoRouterState state) =>
              ScenarioEditPage(
                uuid: state.pathParameters['uuid']!,
                initialTab: ScenarioEditTab.maps
              ),
          ),
        ]
      ),
    ]
  ),
  MainAppRoute(
    path: '/npcs',
    builder: (BuildContext context, GoRouterState state) =>
      const NPCsListPage(),
    icon: Icon(Symbols.face),
    label: Text('PNJs'),
    routes: [
      MainAppRoute(
        path: '/create',
        builder: (BuildContext context, GoRouterState state) =>
          const NPCCreatePage(),
      ),
      MainAppRoute(
        path: '/clone/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          NPCClonePage(from: state.pathParameters['uuid']!),
      ),
      MainAppRoute(
        path: '/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          NPCsListPage(selected: state.pathParameters['uuid']!),
      ),
      MainAppRoute(
        path: '/:uuid/edit',
        builder: (BuildContext context, GoRouterState state) =>
          NPCEditPage(id: state.pathParameters['uuid']!),
      ),
    ]
  ),
  MainAppRoute(
    path: '/creatures',
    builder: (BuildContext context, GoRouterState state) =>
      const CreaturesListPage(),
    icon: Icon(CustomIcons.creature),
    label: Text('Créatures'),
    routes: [
      MainAppRoute(
        path: '/create',
        builder: (BuildContext context, GoRouterState state) =>
          const CreatureCreatePage(),
      ),
      MainAppRoute(
        path: '/clone/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          CreatureClonePage(from: state.pathParameters['uuid']!),
      ),
      MainAppRoute(
        path: '/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          CreaturesListPage(selected: state.pathParameters['uuid']!),
      ),
      MainAppRoute(
        path: '/:uuid/edit',
        builder: (BuildContext context, GoRouterState state) =>
          CreatureEditPage(id: state.pathParameters['uuid']!),
      ),
    ]
  ),
  MainAppRoute(
    path: '/places',
    builder: (BuildContext context, GoRouterState state) =>
      const PlacesMainPage(),
    icon: Icon(Icons.place_outlined),
    label: Text('Lieux'),
    routes: [
      MainAppRoute(
        path: '/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          PlacesMainPage(selected: state.pathParameters['uuid']!),
      ),
    ]
  ),
  MainAppRoute(
    path: '/factions',
    builder: (BuildContext context, GoRouterState state) =>
      const FactionsMainPage(),
    icon: Icon(Symbols.graph_2),
    label: Text('Factions'),
    routes: [
      MainAppRoute(
        path: '/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          FactionsMainPage(selected: state.pathParameters['uuid']!),
      ),
    ]
  ),
  MainAppRoute(
    path: '/spells',
    builder: (BuildContext context, GoRouterState state) =>
      const SpellsMainPage(),
    icon: Icon(Symbols.auto_fix_high),
    label: Text('Sorts'),
  ),
  MainAppRoute(
    path: '/stars',
    builder: (BuildContext context, GoRouterState state) =>
      const StarsListPage(),
    icon: Icon(Symbols.stars_2),
    label: Text('Étoiles'),
    routes: [
      MainAppRoute(
        path: '/create',
        builder: (BuildContext context, GoRouterState state) =>
        const StarCreatePage(),
      ),
      MainAppRoute(
        path: '/clone/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          StarClonePage(from: state.pathParameters['uuid']!),
      ),
      MainAppRoute(
        path: '/:uuid',
        builder: (BuildContext context, GoRouterState state) =>
          StarsListPage(selected: state.pathParameters['uuid']!),
      ),
      MainAppRoute(
        path: '/:uuid/edit',
        builder: (BuildContext context, GoRouterState state) =>
          StarEditPage(id: state.pathParameters['uuid']!),
      ),
    ]
  ),
];

List<RouteBase> buildRouteList({ MainAppRoute? parent, bool forceFullScreen = false }) {
  var ret = <RouteBase>[];
  for(var r in parent?.routes ?? mainAppRoutes) {
    r.isFullScreen = (forceFullScreen || r.isFullScreen || (parent?.isFullScreen ?? false));
    ret.add(
      GoRoute(
        path: r.path,
        builder: r.builder,
        routes: buildRouteList(
          parent: r,
          forceFullScreen: (forceFullScreen || r.isFullScreen || (parent?.isFullScreen ?? false))
        ),
      ),
    );
  }
  return ret;
}

MainAppRoute? mainAppRouteForPath({
  required String path,
  MainAppRoute? parent,
  String? prefix
}) {
  MainAppRoute? ret;

  for(var r in parent?.routes ?? mainAppRoutes) {
    var currentPath = '${prefix ?? ""}${r.path}';

    if(currentPath == path) {
      ret = r;
      break;
    }

    if(path.startsWith(currentPath)) {
      ret = mainAppRouteForPath(
        path: path,
        parent: r,
        prefix: '${prefix ?? ""}${r.path}'
      );

      if(ret != null) break;
    }
  }

  return ret;
}

List<NavigationRailDestination> buildNavigationRailDestinationList() {
  var ret = <NavigationRailDestination>[];
  for(var r in mainAppRoutes) {
    if(r.icon != null && r.label != null) {
      ret.add(
        NavigationRailDestination(
          icon: r.icon!,
          label: r.label!,
        )
      );
    }
  }
  return ret;
}

String navigationRailIndexToRoutePath(int railIndex) {
  var ret = '/';
  var current = 0;
  for(var r in mainAppRoutes) {
    if(r.icon == null && r.label == null) continue;
    if(railIndex == current) {
      ret = r.path;
      break;
    }
    ++current;
  }
  return ret;
}

int routePathToNavigationRailIndex(String path) {
  var ret = -1;
  var current = 0;
  for(var r in mainAppRoutes) {
    if(r.icon == null && r.label == null) continue;
    if(path.startsWith(r.path)) ret = current;
    ++current;
  }
  return ret;
}