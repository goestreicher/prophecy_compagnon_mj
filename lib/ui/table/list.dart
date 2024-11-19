import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/table.dart';
import 'edit.dart';
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
  List<GameTableSummary> tableSummaries = <GameTableSummary>[];

  @override
  void initState() {
    super.initState();
    loadTableSummaries();
  }

  void loadTableSummaries() {
    _tableSummariesFuture = getGameTableSummaries();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder<List<GameTableSummary>>(
      future: _tableSummariesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<GameTableSummary>> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Chargement...')); // TODO: something more fancy
        }

        tableSummaries = snapshot.hasData
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
                  onTap: () async {
                    bool? changeConfirmed = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TableEditPage(uuid: tableSummaries[index].uuid))
                    );
                    if(changeConfirmed != null && changeConfirmed) {
                      setState((){ loadTableSummaries(); });
                    }
                  },
                  child: ListTile(
                    title: Text(tableSummaries[index].name),
                    subtitle: Text('Joueurs: ${tableSummaries[index].playersUuids.length}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // TODO: ask confirmation maybe?
                        setState(() {
                          _isWorking = true;
                        });
                        await deleteGameTable(tableSummaries[index].uuid);
                        setState(() {
                          _isWorking = false;
                          loadTableSummaries();
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
                            var table = GameTable.create(name: newTableName);
                            bool changeConfirmed = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => TableEditPage.immediate(table: table)),
                            );
                            if(changeConfirmed) {
                              setState((){ loadTableSummaries(); });
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
                              Text('Importer une table'),
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
                              await importGameTable(json.decode(jsonStr));
                              setState(() {
                                loadTableSummaries();
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