import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

import 'classes/armor.dart';
import 'classes/creature.dart';
import 'classes/magic.dart';
import 'classes/non_player_character.dart';
import 'classes/place.dart';
import 'classes/shield.dart';
import 'classes/weapon.dart';
import 'classes/storage/storage.dart';

import 'ui/utils/custom_icons.dart';

import 'ui/creatures/main.dart';
import 'ui/non_player_character/main.dart';
import 'ui/places/main.dart';
import 'ui/scenario/list.dart';
import 'ui/session/list.dart';
import 'ui/spells/main.dart';
import 'ui/table/list.dart';

void main() async {
  await DataStorage.instance.init();
  runApp(const ProphecyCompanionApp());
}

class AppState extends ChangeNotifier {
}

class ProphecyCompanionApp extends StatelessWidget {
  const ProphecyCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Prophecy Compagnon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
          tooltipTheme: TooltipTheme.of(context).copyWith(
            waitDuration: Durations.medium1,
          ),
        ),
        home: const MainAppPage(),
      )
    );
  }
}

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    /*
      Load the default assets
     */
    // TODO: some of those can throw storage exceptions, manage them
    // TODO: all of those are async, use a FutureBuilder to build the UI
    Place.loadDefaultAssets();
    Place.loadStoreAssets();
    ArmorModel.loadDefaultAssets();
    CreatureModel.loadDefaultAssets();
    CreatureModel.loadStoreAssets();
    MagicSpell.loadDefaultAssets();
    NonPlayerCharacter.loadDefaultAssets();
    NonPlayerCharacter.loadStoreAssets();
    ShieldModel.loadDefaultAssets();
    WeaponModel.loadDefaultAssets();

    var theme = Theme.of(context);
    Widget activePage;

    switch(_selectedPageIndex) {
      case 0:
        activePage = const SessionsListPage();
        break;
      case 1:
        activePage = const TablesListPage();
        break;
      case 2:
        activePage = const ScenariosListPage();
        break;
      case 3:
        activePage = const SpellsMainPage();
        break;
      case 4:
        activePage = const NPCMainPage();
        break;
      case 5:
        activePage = const CreaturesMainPage();
        break;
      case 6:
        activePage = const PlacesMainPage();
        break;
      default:
        throw UnimplementedError('Page not implemented for $_selectedPageIndex');
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 800,
                  selectedIndex: _selectedPageIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      _selectedPageIndex = value;
                    });
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Symbols.tactic_rounded),
                      label: Text('Sessions'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Symbols.groups),
                      label: Text('Tables'),
                    ),
                    NavigationRailDestination(
                        icon: Icon(Symbols.book),
                        label: Text('Scénarios'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Symbols.auto_fix_high),
                      label: Text('Sorts'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Symbols.face),
                      label: Text('PNJs'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(CustomIcons.creature),
                      label: Text('Créatures'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.place_outlined),
                      label: Text('Lieux'),
                    ),
                  ],
                )
              ),
              Expanded(
                child: ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: activePage,
                  )
                )
              ),
            ],
          );
        }
      )
    );
  }
}
