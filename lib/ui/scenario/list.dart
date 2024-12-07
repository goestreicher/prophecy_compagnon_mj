import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/scenario.dart';
import 'edit.dart';
import '../utils/full_page_error.dart';
import '../utils/full_page_loading.dart';
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
    _scenarioSummariesFuture = ScenarioSummaryStore().getAll();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder<List<ScenarioSummary>>(
        future: _scenarioSummariesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<ScenarioSummary>> snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            return FullPageLoadingWidget();
          }

          if(snapshot.hasError) {
            return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: false);
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
                      bool? changeConfirmed = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              ScenarioEditPage(
                                  uuid: scenarioSummaries[index].uuid
                              )
                          )
                      );
                      if (changeConfirmed != null && changeConfirmed) {
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
                              var scenario = await ScenarioStore().get(scenarioSummaries[index].uuid);
                              if(scenario != null) {
                                await ScenarioStore().delete(scenario);
                              }
                              else {
                                await ScenarioSummaryStore().delete(scenarioSummaries[index]);
                              }
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
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: MenuAnchor(
                    alignmentOffset: const Offset(0, 4),
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
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: MenuItemButton(
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
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: MenuItemButton(
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
                              await ScenarioStore().save(scenario);
                              setState(() {
                                loadScenarioSummaries();
                                _isWorking = false;
                              });
                            } catch (e) {
                              setState(() {
                                _isWorking = false;
                              });

                              if(!context.mounted) return;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: const Text("Échec de l'import"),
                                    content: Text(e.toString()),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('OK'),
                                      )
                                    ]
                                )
                              );
                            }
                          },
                        ),
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