import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/non_player_character.dart';
import '../../classes/object_source.dart';
import '../utils/non_player_character/display_widget.dart';
import '../utils/non_player_character/list_filter.dart';
import '../utils/non_player_character/list_filter_widget.dart';
import '../utils/non_player_character/list_widget.dart';
import '../utils/error_feedback.dart';

class NPCsListPage extends StatefulWidget {
  const NPCsListPage({ super.key, this.selected });

  final String? selected;

  @override
  State<NPCsListPage> createState() => _NPCsListPageState();
}

class _NPCsListPageState extends State<NPCsListPage> {
  bool isWorking = false;
  NPCListFilter filter = NPCListFilter();
  Future<void>? npcsFuture;
  List<NonPlayerCharacterSummary> npcs = <NonPlayerCharacterSummary>[];
  String? selected;

  @override
  void initState() {
    super.initState();

    selected = widget.selected;
  }

  void resetNPCsList() {
    npcsFuture = null;
    npcs.clear();
  }

  Future<void> updateNPCsList() async {
    if(filter.source != null) {
      npcs = (await NonPlayerCharacterSummary.forSource(
                filter.source!,
                filter.category,
                filter.subCategory,
                nameFilter: filter.search,
              )).toList();
    }
    else if(filter.sourceType != null) {
      npcs = (await NonPlayerCharacterSummary.forSourceType(
                filter.sourceType!,
                filter.category,
                filter.subCategory,
                nameFilter: filter.search,
              )).toList();
    }
    else if(filter.category != null) {
      npcs = (await NonPlayerCharacterSummary.forCategory(
                filter.category!,
                filter.subCategory,
                nameFilter: filter.search,
              )).toList();
    }
    else {
      npcs = (await NonPlayerCharacterSummary.getAll(
                  nameFilter: filter.search
              )).toList();
    }

    npcs.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    if(npcs.isEmpty && npcsFuture == null) {
      npcsFuture = updateNPCsList();
    }

    var listWidget = FutureBuilder(
      future: npcsFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        return NPCListWidget(
          npcs: npcs,
          selected: selected,
          onSelected: (String? id) {
            if(id == null && GoRouter.of(context).state.fullPath!.endsWith('/:uuid')) {
              context.replace('/npcs');
            }

            setState(() {
              selected = id;
            });
          },
          onEditRequested: (String id) async {
            context.go('/npcs/$id/edit');
          },
          onCloneRequested: (String id) async {
            context.go('/npcs/clone/$id');
          },
          onDeleteRequested: (String id) async {
            try {
              await NonPlayerCharacter.deleteLocalModel(id);
              setState(() {
                selected = null;
                resetNPCsList();
              });
            }
            catch(e) {
              if(!context.mounted) return;
              displayErrorDialog(
                  context,
                  "Suppression impossible",
                  e.toString()
              );
            }
          },
          restrictModificationToSourceTypes: [
            ObjectSourceType.original
          ],
        );
      }
    );

    var mainArea = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0.0),
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16.0,
            runSpacing: 8.0,
            children: [
              NPCListFilterWidget(
                filter: filter,
                onFilterChanged: (NPCListFilter f) {
                  setState(() {
                    filter = f;
                    resetNPCsList();
                    selected = null;
                  });
                }
              ),
              MenuAnchor(
                alignmentOffset: const Offset(0, 4),
                builder: (BuildContext context, MenuController controller, Widget? child) {
                  return IconButton.filled(
                    icon: const Icon(Icons.add),
                    iconSize: 24.0,
                    padding: const EdgeInsets.all(4.0),
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
                        Text('Nouveau PNJ'),
                      ],
                    ),
                    onPressed: () {
                      context.go('/npcs/create');
                    },
                  ),
                  MenuItemButton(
                    child: const Row(
                      children: [
                        Icon(Icons.publish),
                        SizedBox(width: 4.0),
                        Text('Importer un PNJ'),
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
                          isWorking = true;
                        });

                        var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                        var j = json.decode(jsonStr);
                        var npc = await NonPlayerCharacter.import(j);

                        setState(() {
                          selected = npc.id;
                          filter.category = npc.category;
                          filter.subCategory = npc.subCategory;
                          isWorking = false;
                          resetNPCsList();
                        });
                      } catch (e) {
                        setState(() {
                          isWorking = false;
                        });

                        if(!context.mounted) return;

                        displayErrorDialog(
                            context,
                            "Échec de l'import",
                            e.toString()
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: listWidget,
              ),
              if(selected != null)
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
                      child: NPCDisplayWidget(
                        id: selected!,
                      ),
                    ),
                  ),
                ),
            ],
          )
        ),
      ],
    );

    return Stack(
      children: [
        mainArea,
        if(isWorking)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if(isWorking)
          const Center(
              child: CircularProgressIndicator()
          ),
      ],
    );
  }
}