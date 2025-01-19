import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import '../../classes/scenario.dart';
import 'edit_creatures_tab.dart';
import 'edit_encounters_tab.dart';
import 'edit_events_tab.dart';
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
              length: 7,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Scénario: ${_scenario.name}'),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.download),
                      tooltip: 'Exporter le scénario',
                      onPressed: () async {
                        var jsonStr = json.encode(_scenario.toJson());
                        await FileSaver.instance.saveFile(
                          name: 'scenario_${_scenario.uuid}.json',
                          bytes: utf8.encode(jsonStr),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Annuler',
                      onPressed: !_canCancel
                          ? null
                          : () {
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
                        await ScenarioStore().save(_scenario);
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
                      Tab(text: 'Rencontres'),
                      Tab(text: 'Cartes'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    ScenarioEditGeneralPage(scenario: _scenario),
                    ScenarioEditEventsPage(scenario: _scenario),
                    ScenarioEditNPCsPage(
                      npcs: _scenario.npcs,
                      scenarioName: _scenario.name,
                      onNPCCommitted: () {
                        setState(() {
                          _canCancel = false;
                        });
                      },
                    ),
                    ScenarioEditCreaturesPage(
                      creatures: _scenario.creatures,
                      scenarioName: _scenario.name,
                      onCreatureCommitted: () {
                        setState(() {
                          _canCancel = false;
                        });
                      },
                    ),
                    ScenarioEditPlacesPage(
                      places: _scenario.places,
                      scenarioName: _scenario.name,
                      onPlaceCommitted: () {
                        setState(() {
                          _canCancel = false;
                        });
                      },
                    ),
                    ScenarioEditEncountersPage(
                      encounters: _scenario.encounters,
                      scenarioName: _scenario.name,
                    ),
                    ScenarioEditMapsPage(maps: _scenario.maps),
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