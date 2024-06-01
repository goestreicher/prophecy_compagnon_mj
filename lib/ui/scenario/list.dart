import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/scenario.dart';
import 'edit.dart';
import '../utils/single_line_input_dialog.dart';

class ScenariosListPage extends StatefulWidget {
  const ScenariosListPage({super.key});

  @override
  State<ScenariosListPage> createState() => _ScenariosListPageState();
}

class _ScenariosListPageState extends State<ScenariosListPage> {
  bool _isWorking = false;
  final GlobalKey<FormState> _newScenarioNameForm = GlobalKey<FormState>();
  late Future<List<ScenarioSummary>> _scenarioSummariesFuture;
  List<ScenarioSummary> scenarioSummaries = <ScenarioSummary>[];

  @override
  void initState() {
    super.initState();
    loadScenarioSummaries();
  }

  void loadScenarioSummaries() {
    _scenarioSummariesFuture = getScenarioSummaries();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder<List<ScenarioSummary>>(
        future: _scenarioSummariesFuture,
        builder: (BuildContext context,
            AsyncSnapshot<List<ScenarioSummary>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              // TODO: something more fancy
              child: Text('Chargement...'));
          }

          scenarioSummaries = snapshot.hasData
              ? snapshot.data!
              : <ScenarioSummary>[];

          Widget mainArea;
          if (scenarioSummaries.isEmpty) {
            mainArea = const Center(
              child: Text('Pas de scénarios.'),
            );
          }
          else {
            mainArea = ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: scenarioSummaries.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: theme.colorScheme.surface,
                    onTap: () async {
                      bool changeConfirmed = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              ScenarioEditPage(
                                  uuid: scenarioSummaries[index].uuid
                              )
                          )
                      );
                      if (changeConfirmed) {
                        setState(() {
                          loadScenarioSummaries();
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          title: Text(
                            scenarioSummaries[index].name,
                            style: theme.textTheme.headlineSmall,
                          ),
                          subtitle: scenarioSummaries[index].subtitle.isEmpty ?
                              null :
                              Text(
                                scenarioSummaries[index].subtitle,
                                maxLines: 3,
                                overflow: TextOverflow.fade,
                              ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              // TODO: ask confirmation maybe?
                              setState(() {
                                _isWorking = true;
                              });
                              await deleteScenario(scenarioSummaries[index].uuid);
                              setState(() {
                                _isWorking = false;
                                loadScenarioSummaries();
                              });
                            },
                          )
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Stack(
            children: [
              mainArea,
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: MenuAnchor(
                  style: const MenuStyle(
                    alignment: Alignment.topLeft,
                  ),
                  alignmentOffset: const Offset(-130, 10),
                  builder: (BuildContext context, MenuController controller, Widget? child) {
                      return IconButton.filled(
                        icon: const Icon(Icons.add),
                        padding: const EdgeInsets.all(12.0),
                        tooltip: 'Créer / Importer',
                        onPressed: () {
                            if(controller.isOpen) {
                              controller.close();
                            }
                            else {
                              controller.open();
                            }
                          },
                      );
                    },
                  menuChildren: [
                    MenuItemButton(
                      child: const Row(
                        children: [
                          Icon(Icons.create),
                          SizedBox(width: 4.0),
                          Text('Nouveau scénario'),
                        ],
                      ),
                      onPressed: () async {
                        var newScenarioName = await showDialog(
                          context: context,
                          builder: (context) =>
                              SingleLineInputDialog(
                                  title: 'Création de scénario',
                                  formKey: _newScenarioNameForm
                              ),
                        );
                        // User canceled the pop-up dialog
                        if (newScenarioName == null) return;

                        if (!context.mounted) return;
                        var scenario = Scenario(name: newScenarioName);
                        bool changeConfirmed = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              ScenarioEditPage.immediate(scenario: scenario)),
                        );
                        if (changeConfirmed) {
                          setState(() {
                            loadScenarioSummaries();
                          });
                        }
                      },
                    ),
                    MenuItemButton(
                      child: const Row(
                        children: [
                          Icon(Icons.publish),
                          SizedBox(width: 4.0),
                          Text('Importer un scénario'),
                        ],
                      ),
                      onPressed: () async {
                        var result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['json'],
                        );
                        if(result == null) return;
                        try {
                          setState(() {
                            _isWorking = true;
                          });
                          var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                          var scenario = Scenario.import(json.decode(jsonStr));
                          await saveScenario(scenario);
                          setState(() {
                            loadScenarioSummaries();
                            _isWorking = false;
                          });
                        } catch (e) {
                          setState(() {
                            _isWorking = false;
                          });
                          // TODO: notify the user that things went south
                          // TODO: catch FormatException from the UTF-8 conversion?
                        }
                      },
                    ),
                  ],
                ),
              ),
              if(_isWorking)
                const Opacity(
                  opacity: 0.6,
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.black,
                  ),
                ),
              if(_isWorking)
                const Center(
                    child: CircularProgressIndicator()
                ),
            ],
          );
        }
    );
  }
}