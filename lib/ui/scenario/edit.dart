import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../classes/scenario.dart';
import '../../classes/scenario_encounter.dart';
import 'edit_creatures_tab.dart';
import 'edit_encounters_tab.dart';
import 'edit_events_tab.dart';
import 'edit_general_tab.dart';
import 'edit_maps_tab.dart';
import 'edit_npcs_tab.dart';

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
  late Future<Scenario> _scenarioFuture;
  late Scenario _scenario;

  @override
  void initState() {
    super.initState();
    if(widget.scenario != null) {
      _scenarioFuture = Future<Scenario>.sync(() => widget.scenario!);
    }
    else {
      _scenarioFuture = getScenario(widget.uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder(
      future: _scenarioFuture,
      builder: (BuildContext context, AsyncSnapshot<Scenario> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Chargement...'));
        }

        if(!snapshot.hasData || snapshot.data == null) {
          // TODO: find a better way to notify the user
          return const Center(child: Text('Quelque chose a foiré grave'));
        }
        else {
          _scenario = snapshot.data!;
        }

        Widget mainArea;
        if(_scenario.encounters.isEmpty) {
          mainArea = const Center(
            child: Text('Va falloir des rencontres.'),
          );
        }
        else {
          mainArea = StickyGroupedListView<ScenarioEncounter, int>(
              elements: _scenario.encounters,
              groupBy: (ScenarioEncounter element) => element.day,
              groupSeparatorBuilder: (ScenarioEncounter element) {
                return Row(
                  children: [
                    const Spacer(),
                    Card(
                      color: theme.colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          'Jour ${element.day}',
                          style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              },
              itemComparator: (ScenarioEncounter e1, ScenarioEncounter e2) => e1.day - e2.day,
              order: StickyGroupedListOrder.ASC,
              itemBuilder: (BuildContext context, ScenarioEncounter element) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: theme.colorScheme.surface,
                        onTap: () async {
                        },
                        child: ListTile(
                            title: Text(element.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                // TODO: ask confirmation maybe?
                                setState(() {
                                  _scenario.encounters.remove(element);
                                });
                              },
                            )
                        ),
                      )
                  ),
                );
              }
          );
        }

        return Stack(
          children: [
            DefaultTabController(
              length: 6,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Scénario: ${_scenario.name}'),
                  leading: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      var jsonStr = json.encode(_scenario.toJson());
                      await FileSaver.instance.saveFile(
                        name: 'scenario_${_scenario.uuid}.json',
                        bytes: utf8.encode(jsonStr),
                      );
                    },
                  ),
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
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
                        await saveScenario(_scenario);
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
                      Tab(text: 'Rencontres'),
                      Tab(text: 'Cartes'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    ScenarioEditGeneralPage(scenario: _scenario),
                    const ScenarioEditEventsPage(),
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
                    ScenarioEditEncountersPage(encounters: _scenario.encounters),
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