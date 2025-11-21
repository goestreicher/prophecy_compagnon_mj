import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../classes/object_source.dart';
import '../../classes/resource_link/pcs_resource_link_provider.dart';
import '../../classes/star.dart';
import '../../classes/star_motivations.dart';
import '../../classes/table.dart' as pc;
import '../../classes/player_character.dart';
import '../player_character/new_character_dialog.dart';
import '../utils/character/edit_widget.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';
import '../utils/single_line_input_dialog.dart';
import '../utils/star/edit_widget.dart';
import 'characters_list_widget.dart';

class TableEditPage extends StatefulWidget {
  const TableEditPage({
    super.key,
    required this.uuid,
    this.selectedPcId,
  });

  @override
  State<TableEditPage> createState() => _TableEditPageState();

  final String uuid;
  final String? selectedPcId;
}

class _TableEditPageState extends State<TableEditPage> {
  bool isWorking = false;
  bool canCancel = true;

  late Future<pc.GameTable?> tableFuture;
  late pc.GameTable table;

  String? selectedId;
  PlayerCharacter? newPC;
  final GlobalKey<FormState> newPlayerCharacterForm = GlobalKey<FormState>();

  bool starSelected = false;
  final GlobalKey<FormState> newStarForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    tableFuture = pc.GameTableStore().get(widget.uuid)
        .then((pc.GameTable? t) async {
          await t?.loadPlayers();
          return t;
        });

    selectedId = widget.selectedPcId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tableFuture,
      builder: (BuildContext context, AsyncSnapshot<pc.GameTable?> snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: true);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(message: 'Aucune donnée retournée', canPop: true);
        }

        var theme = Theme.of(context);
        table = snapshot.data!;

        var listWidget = Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            MenuAnchor(
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
                MenuItemButton(
                  child: const Row(
                    children: [
                      Icon(Icons.create),
                      SizedBox(width: 4.0),
                      Text('Nouveau PJ'),
                    ],
                  ),
                  onPressed: () async {
                    PlayerCharacter? character = await showDialog(
                      context: context,
                      builder: (context) => NewPlayerCharacterDialog(
                        formKey: newPlayerCharacterForm,
                      ),
                    );
                    // User canceled the pop-up dialog
                    if(character == null) return;
                    if(!context.mounted) return;

                    setState(() {
                      selectedId = character.id;
                      newPC = character;
                    });
                  },
                ),
                MenuItemButton(
                  child: const Row(
                    children: [
                      Icon(Icons.publish),
                      SizedBox(width: 4.0),
                      Text('Importer un PJ'),
                    ],
                  ),
                  onPressed: () async {
                    var result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['json'],
                      withData: true,
                    );
                    if(result == null) return;

                    try {
                      setState(() {
                        isWorking = true;
                      });

                      var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                      var character = PlayerCharacter.import(json.decode(jsonStr));
                      await PlayerCharacterStore().save(character);

                      setState(() {
                        table.playerSummaries.add(character.summary);
                      });

                      await pc.GameTableStore().save(table);

                      setState(() {
                        isWorking = false;
                        canCancel = false;
                      });
                    } catch (e) {
                      setState(() {
                        isWorking = false;
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
              ],
            ),
            Flexible(
              child: TableCharactersListWidget(
                summaries: table.playerSummaries,
                selected: selectedId,
                onCharacterSelected: (String? id) async {
                  setState(() {
                    starSelected = false;
                    selectedId = id;
                  });
                },
                onCharacterEdited: (String id) async {
                  setState(() {
                    isWorking = true;
                  });
                  await pc.GameTableStore().save(table);
                  setState(() {
                    isWorking = false;
                  });
                },
                onCharacterDeleted: (String id) async {
                  setState(() {
                    canCancel = false;
                    isWorking = true;
                  });
                  var character = await PlayerCharacterStore().get(id);
                  if(character != null) {
                    await PlayerCharacterStore().delete(character);
                  }
                  await pc.GameTableStore().save(table);
                  setState(() {
                    isWorking = false;
                  });
                },
              ),
            ),
            if(table.star == null)
              ElevatedButton.icon(
                onPressed: () async {
                  var name = await showDialog<String>(
                    context: context,
                    builder: (context) => SingleLineInputDialog(
                      title: "Nom de l'étoile",
                      formKey: newStarForm
                    ),
                  );
                  if(name == null || name.isEmpty) return;
                  if(!context.mounted) return;

                  table.star = PlayersStar(
                    source: ObjectSource.local,
                    name: name,
                    envergure: StarReach.level0,
                    motivations: StarMotivations.empty(),
                    circles: <MotivationType, int>{},
                  );

                  setState(() {
                    starSelected = true;
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("Créer l'étoile des joueurs"),
              ),
            if(table.star != null)
              Card(
                color: starSelected
                    ? theme.colorScheme.surfaceContainerHighest
                    : null,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: theme.colorScheme.surface,
                  onTap: () async {
                    setState(() {
                      selectedId = null;
                      starSelected = !starSelected;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 12.0,
                      children: [
                        Icon(
                          Symbols.stars_2,
                          size: 48.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                table.star!.name,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Éclat ${table.star!.eclat} / Envergure ${table.star!.envergure.index + 1}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            table.star = null;
                            setState(() {
                              starSelected = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )
              )
          ],
        );

        Widget mainArea = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(selectedId == null && !starSelected)
              Expanded(child: listWidget),
            if(selectedId != null || starSelected)
              SizedBox(
                width: 300,
                child: listWidget,
              ),
            if(starSelected && table.star != null)
              Expanded(
                child: StarEditWidget(
                  star: table.star!,
                  resourceLinkProvider: PlayerCharactersResourceLinkProvider(
                    tableUuid: table.uuid,
                    tableName: table.name,
                  ),
                  onEditDone: (bool result) async {
                    if(result) {
                      await PlayersStarStore().save(table.star!);
                      if(!context.mounted) return;
                      setState(() {
                        canCancel = false;
                      });
                    }
                    else {
                      table.star = await PlayersStarStore().get(table.star!.id);
                      setState(() {
                        starSelected = false;
                      });
                    }
                  }
                ),
              ),
            if(selectedId != null)
              Expanded(
                child: CharacterEditWidget(
                  character: newPC ?? table.players.firstWhere((PlayerCharacter p) => p.id == selectedId!),
                  onEditDone: (bool result) async {
                    if(result) {
                      setState(() {
                        canCancel = false;
                      });

                      if(newPC != null) {
                        await PlayerCharacterStore().save(newPC!);

                        table.playerSummaries.add(newPC!.summary);
                        table.players.add(newPC!);
                      }
                      else {
                        var summaryIndex = table.playerSummaries
                          .indexWhere((PlayerCharacterSummary s) => s.id == selectedId);
                        var pcIndex = table.players
                          .indexWhere((PlayerCharacter p) => p.id == selectedId);

                        if(summaryIndex != -1 && pcIndex != -1) {
                          await PlayerCharacterStore().save(table.players[pcIndex]);
                          table.playerSummaries[summaryIndex] = table.players[pcIndex].summary;
                        }
                      }
                    }
                    setState(() {
                      selectedId = null;
                      newPC = null;
                    });
                  }
                ),
              )
          ],
        );

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Table: ${table.name}'),
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.download),
                    tooltip: 'Exporter la table',
                    onPressed: (selectedId != null || starSelected) ? null : () async {
                      setState(() {
                        isWorking = true;
                      });
                      var jsonFull = await table.toJsonFull();
                      var jsonStr = json.encode(jsonFull);
                      setState(() {
                        isWorking = false;
                      });
                      await FilePicker.platform.saveFile(
                        fileName: 'table_${table.uuid}.json',
                        bytes: utf8.encode(jsonStr),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Annuler',
                    onPressed: (selectedId != null || starSelected || !canCancel) ? null : () async {
                      context.go('/tables');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    tooltip: 'Valider',
                    onPressed: (selectedId != null || starSelected) ? null : () async {
                      setState(() {
                        isWorking = true;
                      });
                      await pc.GameTableStore().save(table);
                      setState(() {
                        isWorking = false;
                      });

                      if(!context.mounted) return;
                      context.go('/tables');
                    },
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: mainArea,
              ),
            ),
            if(isWorking)
              const Opacity(
                  opacity: 0.6,
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.black,
                  )
              ),
            if(isWorking)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}