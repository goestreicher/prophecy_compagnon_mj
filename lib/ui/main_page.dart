import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_mj/ui/app_routes.dart';

import '../classes/armor.dart';
import '../classes/creature.dart';
import '../classes/faction.dart';
import '../classes/magic_spell.dart';
import '../classes/non_player_character.dart';
import '../classes/npc_category.dart';
import '../classes/place.dart';
import '../classes/shield.dart';
import '../classes/star.dart';
import '../classes/weapon.dart';
import 'utils/full_page_loading.dart';

Future<void> _loadAssets() async {
  // TODO: some of those can throw storage exceptions, manage them
  await Place.init();
  await ArmorModel.loadDefaultAssets();
  await ShieldModel.loadDefaultAssets();
  await WeaponModel.loadDefaultAssets();
  await MagicSpell.loadDefaultAssets();
  await CreatureCategory.loadDefaultAssets();
  await Creature.init();
  await NPCCategory.loadDefaultAssets();
  await NPCSubCategory.loadDefaultAssets();
  await NonPlayerCharacter.init();
  await Faction.init();
  await Star.init();
}

class MainPage extends StatefulWidget {
  const MainPage({ super.key, required this.pageWidget });

  final Widget pageWidget;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final Future<void> loadAssetsFuture;

  @override
  void initState() {
    super.initState();

    loadAssetsFuture = _loadAssets();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadAssetsFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return FullPageLoadingWidget();
        }

        var theme = Theme.of(context);
        var router = GoRouter.of(context);
        var selectedIndex = routePathToNavigationRailIndex(router.state.uri.toString());
        MainAppRoute? appRoute;
        if(router.state.fullPath != null) {
          appRoute = mainAppRouteForPath(path: router.state.fullPath!);
        }

        if(appRoute?.isFullScreen ?? false) {
          return widget.pageWidget;
        }

        return Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Row(
                children: [
                  SafeArea(
                    child: NavigationRail(
                      extended: constraints.maxWidth >= 800,
                      selectedIndex: selectedIndex >= 0 ? selectedIndex : null,
                      onDestinationSelected: (value) {
                        context.go(navigationRailIndexToRoutePath(value));
                      },
                      destinations: buildNavigationRailDestinationList(),
                    )
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: widget.pageWidget,
                      )
                    )
                  ),
                ],
              );
            }
          )
        );
      },
    );
  }
}