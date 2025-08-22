import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/faction.dart';
import '../../classes/place.dart';
import '../../classes/scenario.dart';
import '../../classes/scenario_map.dart';
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

class ScenarioEditPage extends StatefulWidget {
  const ScenarioEditPage({super.key, required this.uuid}) : scenario = null;
  ScenarioEditPage.immediate({super.key, required this.scenario}) : uuid = scenario!.uuid;

  @override
  State<ScenarioEditPage> createState() => _ScenarioEditPageState();

  final String uuid;
  final Scenario? scenario;
}

class _ScenarioEditPageState extends State<ScenarioEditPage> {
  bool _isWorking = false;
  bool _canCancel = true;
  late Future<Scenario?> _scenarioFuture;
  late Scenario _scenario;
  void Function()? tabGeneralPreSaveCallback;

  List<Place> uncommittedPlacesCreation = <Place>[];
  List<Place> uncommittedPlacesModification = <Place>[];
  List<Place> uncommittedPlacesDeletion = <Place>[];
  List<Faction> uncommittedFactionsCreation = <Faction>[];
  List<Faction> uncommittedFactionsModification = <Faction>[];
  List<Faction> uncommittedFactionsDeletion = <Faction>[];
  List<ScenarioMap> uncommittedMapsCreation = <ScenarioMap>[];
  List<ScenarioMap> uncommittedMapsModification = <ScenarioMap>[];
  List<ScenarioMap> uncommittedMapsDeletion = <ScenarioMap>[];
  
  Future<void> commitPendingChanges() async {
    /*
        Places
     */
    uncommittedPlacesCreation.clear();
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
      await FactionStore().delete(f);
    }
    uncommittedFactionsDeletion.clear();

    /*
        Maps
     */
    uncommittedMapsCreation.clear();
    uncommittedMapsModification.clear();
    for(var m in uncommittedMapsDeletion) {
      await ScenarioMapStore().delete(m);
    }
    uncommittedMapsDeletion.clear();
  }

  Future<void> cancelPendingChanges() async {
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
              length: 8,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Scénario: ${_scenario.name}'),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.download),
                      tooltip: 'Exporter le scénario',
                      onPressed: () async {
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
                      onPressed: !_canCancel ? null : () async {
                        await cancelPendingChanges();
                        if(!context.mounted) return;
                        Navigator.of(context).pop(false);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      tooltip: 'Valider',
                      onPressed: () async {
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
                        Navigator.of(context).pop(true);
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
                      onNPCCommitted: () {
                        setState(() {
                          _canCancel = false;
                        });
                      },
                    ),
                    ScenarioEditCreaturesPage(
                      creatures: _scenario.creatures,
                      scenarioSource: _scenario.source,
                      onCreatureCommitted: () {
                        setState(() {
                          _canCancel = false;
                        });
                      },
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