import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/game_session.dart';
import '../../classes/table.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';
import '../utils/single_line_input_dialog.dart';

class TablesListPage extends StatefulWidget {
  const TablesListPage({super.key});

  @override
  State<TablesListPage> createState() => _TablesListPageState();
}

class _TablesListPageState extends State<TablesListPage> {
  bool _isWorking = false;
  final GlobalKey<FormState> _newTableNameForm = GlobalKey<FormState>();
  late Future<List<GameTableSummary>> _tableSummariesFuture;

  @override
  void initState() {
    super.initState();
    loadTableSummaries();
  }

  void loadTableSummaries() {
    _tableSummariesFuture = GameTableSummaryStore().getAll();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder<List<GameTableSummary>>(
      future: GameTableSummaryStore().getAll(),
      builder: (BuildContext context, AsyncSnapshot<List<GameTableSummary>> snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: false);
        }

        var tableSummaries = snapshot.hasData
            ? snapshot.data!
            : <GameTableSummary>[];

        Widget mainArea;
        if(tableSummaries.isEmpty) {
          mainArea = const Center(
            child: Text('Pas de tables. Sad.'),
          );
        }
        else {
          mainArea = ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tableSummaries.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: theme.colorScheme.surface,
                  onTap: () {
                    context.go('/tables/${tableSummaries[index].uuid}');
                  },
                  child: ListTile(
                    title: Text(tableSummaries[index].name),
                    subtitle: Text('Joueurs: ${tableSummaries[index].playersUuids.length}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        var confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Confirmer la suppression'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Supprimer cette table et tous les PJs ?'),
                                const SizedBox(height: 8.0),
                                const Text('Cela supprimera aussi les sessions qui utilisent cette table.'),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Supprimer'),
                              ),
                            ]
                          )
                        );
                        if(confirm == null || !confirm) return;

                        setState(() {
                          _isWorking = true;
                        });

                        for(var session in await GameSessionStore().getAll()) {
                          if(session.table.uuid == tableSummaries[index].uuid) {
                            await GameSessionStore().delete(session);
                          }
                        }

                        var table = await GameTableStore().get(tableSummaries[index].uuid);
                        if(table != null) {
                          await GameTableStore().delete(table);
                        }
                        else {
                          await GameTableSummaryStore().delete(tableSummaries[index]);
                        }
                        setState(() {
                          _isWorking = false;
                        });
                      },
                    )
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
                              Text('Nouvelle table'),
                            ],
                          ),
                          onPressed: () async {
                            var newTableName = await showDialog(
                              context: context,
                              builder: (context) => SingleLineInputDialog(
                                  title: 'Création de table',
                                  formKey: _newTableNameForm
                              ),
                            );
                            // User canceled the pop-up dialog
                            if(newTableName == null) return;

                            if(!context.mounted) return;
                            setState(() { _isWorking = true; });
                            var table = GameTable.create(name: newTableName);
                            await GameTableStore().save(table);
                            setState(() { _isWorking = true; });

                            if(!context.mounted) return;
                            context.go('/tables/${table.uuid}');
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
                              Text('Importer une table'),
                            ],
                          ),
                          onPressed: () async {
                            var result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['json'],
                              withData: true,
                            );
                            if(!context.mounted) return;
                            if(result == null) return;

                            try {
                              setState(() {
                                _isWorking = true;
                              });

                              var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                              await importGameTable(json.decode(jsonStr));
                              setState(() {
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