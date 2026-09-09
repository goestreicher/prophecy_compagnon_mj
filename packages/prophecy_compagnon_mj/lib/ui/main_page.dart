import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/armor.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/cloth.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/jewel.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/magic_gear.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/misc_gear.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/shield.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/faction.dart';
import 'package:prophecy_compagnon_shared/classes/magic_spell.dart';
import 'package:prophecy_compagnon_shared/classes/non_player_character.dart';
import 'package:prophecy_compagnon_shared/classes/npc_category.dart';
import 'package:prophecy_compagnon_shared/classes/place.dart';
import 'package:prophecy_compagnon_shared/classes/star.dart';
import 'package:prophecy_compagnon_shared/ui/full_page_loading.dart';

import 'app_routes.dart';

Future<void> _loadAssets() async {
  // TODO: some of those can throw storage exceptions, manage them
  await Place.init();
  await ArmorModel.init();
  await ShieldModel.init();
  await WeaponModel.init();
  await ClothModel.init();
  await MiscGearModel.init();
  await JewelModel.init();
  await MagicGearModel.init();
  await MagicSpell.loadDefaultAssets();
  await CreatureCategory.init();
  await Creature.init();
  await NPCCategory.init();
  await NPCSubCategory.init();
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
              var railExtended = constraints.maxWidth >= 800;

              return Row(
                children: [
                  SafeArea(
                    child: NavigationRail(
                      extended: railExtended,
                      selectedIndex: selectedIndex >= 0 ? selectedIndex : null,
                      onDestinationSelected: (value) {
                        context.go(navigationRailIndexToRoutePath(value));
                      },
                      destinations: buildNavigationRailDestinationList(),
                    )
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: theme.colorScheme.surface,
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