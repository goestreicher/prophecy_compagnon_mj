import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_mj/classes/creature.dart';
import 'package:prophecy_compagnon_mj/classes/non_player_character.dart';

import '../../classes/faction.dart';
import '../../classes/place.dart';
import '../../classes/scenario.dart';
import '../../classes/scenario_map.dart';
import '../../classes/star.dart';
import 'edit_creatures_tab.dart';
import 'edit_encounters_tab.dart';
import 'edit_events_tab.dart';
import 'edit_factions_tab.dart';
import 'edit_general_tab.dart';
import 'edit_maps_tab.dart';
import 'edit_npcs_tab.dart';
import 'edit_places_tab.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';
import 'edit_stars_tab.dart';

enum ScenarioEditTab {
  general,
  events,
  npcs,
  creatures,
  places,
  factions,
  encounters,
  maps,
}

class ScenarioEditPage extends StatefulWidget {
  const ScenarioEditPage({
    super.key,
    required this.uuid,
    this.initialTab = ScenarioEditTab.general,
  })
    : scenario = null;

  ScenarioEditPage.immediate({
    super.key,
    required this.scenario,
    this.initialTab = ScenarioEditTab.general,
  })
    : uuid = scenario!.uuid;

  @override
  State<ScenarioEditPage> createState() => _ScenarioEditPageState();

  final String uuid;
  final Scenario? scenario;
  final ScenarioEditTab initialTab;
}

class _ScenarioEditPageState extends State<ScenarioEditPage> {
  bool mainButtonsLocked = false;
  bool _isWorking = false;
  late Future<Scenario?> _scenarioFuture;
  late Scenario _scenario;
  void Function()? tabGeneralPreSaveCallback;

  List<NonPlayerCharacter> uncommittedNPCsCreation = <NonPlayerCharacter>[];
  List<NonPlayerCharacter> uncommittedNPCsModification = <NonPlayerCharacter>[];
  List<NonPlayerCharacter> uncommittedNPCsDeletion = <NonPlayerCharacter>[];
  List<Creature> uncommittedCreaturesCreation = <Creature>[];
  List<Creature> uncommittedCreaturesModification = <Creature>[];
  List<Creature> uncommittedCreaturesDeletion = <Creature>[];
  List<Place> uncommittedPlacesCreation = <Place>[];
  List<Place> uncommittedPlacesModification = <Place>[];
  List<Place> uncommittedPlacesDeletion = <Place>[];
  List<Faction> uncommittedFactionsCreation = <Faction>[];
  List<Faction> uncommittedFactionsModification = <Faction>[];
  List<Faction> uncommittedFactionsDeletion = <Faction>[];
  List<ScenarioMap> uncommittedMapsCreation = <ScenarioMap>[];
  List<ScenarioMap> uncommittedMapsModification = <ScenarioMap>[];
  List<ScenarioMap> uncommittedMapsDeletion = <ScenarioMap>[];
  List<Star> uncommittedStarsCreation = <Star>[];
  List<Star> uncommittedStarsModification = <Star>[];
  List<Star> uncommittedStarsDeletion = <Star>[];
  
  Future<void> commitPendingChanges() async {
    /*
        NPCs
     */
    uncommittedNPCsCreation.clear();
    uncommittedPlacesModification.clear();
    for(var n in uncommittedNPCsDeletion) {
      await NonPlayerCharacter.deleteLocalModel(n.id);
    }
    uncommittedNPCsDeletion.clear();

    /*
        Creatures
     */
    uncommittedCreaturesCreation.clear();
    uncommittedCreaturesModification.clear();
    for(var c in uncommittedCreaturesDeletion) {
      await Creature.deleteLocalModel(c.id);
    }
    uncommittedCreaturesDeletion.clear();

    /*
        Places
     */
    uncommittedPlacesCreation.clear();
    uncommittedPlacesModification.clear();
    for(var p in uncommittedPlacesDeletion) {
      await Place.delete(p);
    }
    uncommittedPlacesDeletion.clear();

    /*
        Factions
     */
    uncommittedFactionsCreation.clear();
    uncommittedFactionsModification.clear();
    for(var f in uncommittedFactionsDeletion) {
      await Faction.delete(f);
    }
    uncommittedFactionsDeletion.clear();

    /*
        Maps
     */
    uncommittedMapsCreation.clear();
    uncommittedMapsModification.clear();
    for(var m in uncommittedMapsDeletion) {
      await m.willDelete();
    }
    uncommittedMapsDeletion.clear();

    /*
        Stars
     */
    uncommittedStarsCreation.clear();
    uncommittedStarsModification.clear();
    for(var s in uncommittedStarsDeletion) {
      await Star.deleteLocalModel(s.id);
    }
    uncommittedStarsDeletion.clear();
  }

  Future<void> cancelPendingChanges() async {
    /*
        Creatures
     */
    for(var c in uncommittedCreaturesCreation) {
      Creature.removeFromCache(c.id);
    }
    uncommittedCreaturesCreation.clear();
    for(var c in uncommittedCreaturesModification) {
      Creature.reloadFromStore(c.id);
    }
    uncommittedCreaturesModification.clear();
    uncommittedCreaturesDeletion.clear();

    /*
        NPCs
     */
    for(var n in uncommittedNPCsCreation) {
      NonPlayerCharacter.removeFromCache(n.id);
    }
    uncommittedNPCsCreation.clear();
    for(var n in uncommittedNPCsModification) {
      await NonPlayerCharacter.reloadFromStore(n.id);
    }
    uncommittedNPCsModification.clear();
    uncommittedNPCsDeletion.clear();

    /*
        Places
     */
    for(var p in uncommittedPlacesCreation) {
      Place.removeFromCache(p);
    }
    uncommittedPlacesCreation.clear();
    for(var p in uncommittedPlacesModification) {
      await Place.reloadFromStore(p);
    }
    uncommittedPlacesModification.clear();
    uncommittedPlacesDeletion.clear();

    /*
        Factions
     */
    for(var f in uncommittedFactionsCreation) {
      Faction.removeFromCache(f);
    }
    uncommittedFactionsCreation.clear();
    for(var f in uncommittedFactionsModification) {
      await Faction.reloadFromStore(f);
    }
    uncommittedFactionsModification.clear();
    uncommittedFactionsDeletion.clear();

    /*
        Maps
     */
    uncommittedMapsCreation.clear();
    uncommittedMapsModification.clear();
    uncommittedMapsDeletion.clear();

    /*
        Stars
     */
    for(var s in uncommittedStarsCreation) {
      Star.removeFromCache(s.id);
    }
    uncommittedStarsCreation.clear();
    for(var s in uncommittedStarsModification) {
      Star.reloadFromStore(s.id);
    }
    uncommittedStarsModification.clear();
    uncommittedStarsDeletion.clear();
  }

  @override
  void initState() {
    super.initState();
    if(widget.scenario != null) {
      _scenarioFuture = Future<Scenario>.sync(() => widget.scenario!);
    }
    else {
      _scenarioFuture = ScenarioStore().get(widget.uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _scenarioFuture,
      builder: (BuildContext context, AsyncSnapshot<Scenario?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: true);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(message: 'Aucune donnée retournée', canPop: true);
        }

        _scenario = snapshot.data!;

        return Stack(
          children: [
            DefaultTabController(
              initialIndex: widget.initialTab.index,
              length: 9,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Scénario: ${_scenario.name}'),
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.download),
                      tooltip: 'Exporter le scénario',
                      onPressed: mainButtonsLocked ? null : () async {
                        tabGeneralPreSaveCallback?.call();
                        var jsonStr = json.encode(_scenario.toJson());
                        await FilePicker.platform.saveFile(
                          fileName: 'scenario_${_scenario.uuid}.json',
                          bytes: utf8.encode(jsonStr),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Annuler',
                      onPressed: mainButtonsLocked ? null : () async {
                        await cancelPendingChanges();
                        if(!context.mounted) return;
                        context.go('/scenarios');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      tooltip: 'Valider',
                      onPressed: mainButtonsLocked ? null : () async {
                        setState(() {
                          _isWorking = true;
                        });
                        tabGeneralPreSaveCallback?.call();
                        await ScenarioStore().save(_scenario);
                        await commitPendingChanges();
                        setState(() {
                          _isWorking = false;
                        });

                        if(!context.mounted) return;
                        context.go('/scenarios');
                      },
                    )
                  ],
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Général'),
                      Tab(text: 'Événements'),
                      Tab(text: 'PNJs'),
                      Tab(text: 'Créatures'),
                      Tab(text: 'Lieux'),
                      Tab(text: 'Factions'),
                      Tab(text: 'Rencontres'),
                      Tab(text: 'Cartes'),
                      Tab(text: 'Étoiles'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    ScenarioEditGeneralPage(
                      scenario: _scenario,
                      registerPreSaveCallback: (void Function() cb) => tabGeneralPreSaveCallback = cb,
                    ),
                    ScenarioEditEventsPage(scenario: _scenario),
                    ScenarioEditNPCsPage(
                      npcs: _scenario.npcs,
                      scenarioSource: _scenario.source,
                      onNPCCreated: (NonPlayerCharacter n) {
                        uncommittedNPCsCreation.add(n);
                        setState(() {
                          _scenario.npcs.add(n);
                        });
                      },
                      onNPCModified: (NonPlayerCharacter n) {
                        uncommittedNPCsModification.add(n);
                      },
                      onNPCDeleted: (NonPlayerCharacter n) {
                        uncommittedNPCsDeletion.add(n);
                        setState(() {
                          _scenario.npcs.remove(n);
                        });
                      },
                      onEditStarted: () => setState(() {
                        mainButtonsLocked = true;
                      }),
                      onEditFinished: () => setState(() {
                        mainButtonsLocked = false;
                      }),
                    ),
                    ScenarioEditCreaturesPage(
                      creatures: _scenario.creatures,
                      scenarioSource: _scenario.source,
                      onCreatureCreated: (Creature c) {
                        uncommittedCreaturesCreation.add(c);
                        setState(() {
                          _scenario.creatures.add(c);
                        });
                      },
                      onCreatureModified: (Creature c) {
                        uncommittedCreaturesModification.add(c);
                      },
                      onCreatureDeleted: (Creature c) {
                        uncommittedCreaturesDeletion.add(c);
                        setState(() {
                          _scenario.creatures.remove(c);
                        });
                      },
                      onEditStarted: () => setState(() {
                        mainButtonsLocked = true;
                      }),
                      onEditFinished: () => setState(() {
                        mainButtonsLocked = false;
                      }),
                    ),
                    ScenarioEditPlacesPage(
                      scenarioSource: _scenario.source,
                      onPlaceCreated: (Place p) {
                        uncommittedPlacesCreation.add(p);
                        setState(() {
                          _scenario.places.add(p);
                        });
                      },
                      onPlaceModified: (Place p) {
                        uncommittedPlacesModification.add(p);
                      },
                      onPlaceDeleted: (Place p) {
                        uncommittedPlacesDeletion.add(p);
                        setState(() {
                          _scenario.places.remove(p);
                        });
                      }
                    ),
                    ScenarioEditFactionsPage(
                      scenarioSource: _scenario.source,
                      onFactionCreated: (Faction f) {
                        uncommittedFactionsCreation.add(f);
                        setState(() {
                          _scenario.factions.add(f);
                        });
                      },
                      onFactionModified: (Faction f) {
                        uncommittedFactionsModification.add(f);
                      },
                      onFactionDeleted: (Faction f) {
                        uncommittedFactionsDeletion.add(f);
                        setState(() {
                          _scenario.factions.remove(f);
                        });
                      },
                    ),
                    ScenarioEditEncountersPage(
                      encounters: _scenario.encounters,
                      scenarioName: _scenario.name,
                    ),
                    ScenarioEditMapsPage(
                      maps: _scenario.maps,
                      onMapCreated: (ScenarioMap m) {
                        uncommittedMapsCreation.add(m);
                        setState(() {
                          _scenario.maps.add(m);
                        });
                      },
                      onMapModified: (ScenarioMap m) {
                        uncommittedMapsModification.add(m);
                      },
                      onMapDeleted: (ScenarioMap m) {
                        uncommittedMapsDeletion.add(m);
                        setState(() {
                          _scenario.maps.remove(m);
                        });
                      },
                    ),
                    ScenarioEditStarsPage(
                      stars: _scenario.stars,
                      scenarioSource: _scenario.source,
                      onStarCreated: (Star s) {
                        uncommittedStarsCreation.add(s);
                        setState(() {
                          _scenario.stars.add(s);
                        });
                      },
                      onStarModified: (Star s) {
                        uncommittedStarsModification.add(s);
                      },
                      onStarDeleted: (Star s) {
                        uncommittedStarsDeletion.add(s);
                        setState(() {
                          _scenario.stars.remove(s);
                        });
                      },
                      onEditStarted: () => setState(() {
                        mainButtonsLocked = true;
                      }),
                      onEditFinished: () => setState(() {
                        mainButtonsLocked = false;
                      }),
                    ),
                  ],
                ),
              ),
            ),
            if(_isWorking)
              const Opacity(
                  opacity: 0.6,
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.black,
                  )
              ),
            if(_isWorking)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}