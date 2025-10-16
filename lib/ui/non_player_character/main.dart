import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../../classes/npc_category.dart';
import '../../classes/object_source.dart';
import '../utils/character/edit_widget.dart';
import '../utils/character/npc_create_dialog.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';
import '../utils/character/npc_list_widget.dart';

class NPCMainPage extends StatefulWidget {
  const NPCMainPage({ super.key });

  @override
  State<NPCMainPage> createState() => _NPCMainPageState();
}

class _NPCMainPageState extends State<NPCMainPage> {
  bool _isWorking = false;
  final TextEditingController sourceTypeController = TextEditingController();
  ObjectSourceType? npcSourceType;
  final TextEditingController sourceController = TextEditingController();
  ObjectSource? npcSource;
  final TextEditingController categoryController = TextEditingController();
  NPCCategory? npcCategory;
  final TextEditingController subCategoryController = TextEditingController();
  NPCSubCategory? npcSubCategory;
  final TextEditingController searchController = TextEditingController();
  String? search;
  final GlobalKey<FormState> newNPCFormKey = GlobalKey();
  bool editing = false;
  bool creatingNewNPC = false;
  String? selectedDisplay;
  NonPlayerCharacter? selectedEditNPC;

  Future<Iterable<NonPlayerCharacterSummary>> _updateNPCsList() async {
    if(npcSource != null) {
      return NonPlayerCharacterSummary.forSource(npcSource!, npcCategory, npcSubCategory, nameFilter: search);
    }
    else if(npcSourceType != null) {
      return NonPlayerCharacterSummary.forSourceType(npcSourceType!, npcCategory, npcSubCategory, nameFilter: search);
    }
    else if(npcCategory != null) {
      return NonPlayerCharacterSummary.forCategory(npcCategory!, npcSubCategory, nameFilter: search);
    }

    return NonPlayerCharacterSummary.getAll(nameFilter: search);
  }

  void _startEditing(NonPlayerCharacter npc) {
    setState(() {
      selectedEditNPC = npc;
      editing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainArea;

    if(editing && selectedEditNPC != null) {
      mainArea = CharacterEditWidget(
        character: selectedEditNPC!,
        onEditDone: (bool result) async {
          if(result) {
            await NonPlayerCharacter.saveLocalModel(selectedEditNPC!);
            selectedDisplay = selectedEditNPC!.id;
            npcSourceType = selectedEditNPC!.source.type;
            npcCategory = selectedEditNPC!.category;
            npcSubCategory = selectedEditNPC!.subCategory;
          }
          else {
            if(creatingNewNPC) {
              NonPlayerCharacter.removeFromCache(selectedEditNPC!.id);
            }
            else {
              await NonPlayerCharacter.reloadFromStore(selectedEditNPC!.id);
            }
          }

          setState(() {
            selectedEditNPC = null;
            editing = false;
            creatingNewNPC = false;
          });
        }
      );
    }
    else {
      mainArea = FutureBuilder(
        future: _updateNPCsList(),
        builder: (BuildContext context, AsyncSnapshot<Iterable<NonPlayerCharacterSummary>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return FullPageLoadingWidget();
          }

          if(snapshot.hasError) {
            return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: true);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return FullPageErrorWidget(message: 'Aucune donnée retournée', canPop: true);
          }

          var npcs = snapshot.data!.toList();
          npcs.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          var theme = Theme.of(context);

          return Column(
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
                    DropdownMenu(
                      controller: sourceTypeController,
                      label: Text(
                        'Type de source',
                        style: theme.textTheme.bodySmall,
                      ),
                      textStyle: theme.textTheme.bodySmall,
                      initialSelection: npcSourceType,
                      leadingIcon: npcSourceType == null
                          ? null
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  sourceTypeController.clear();
                                  npcSourceType = null;
                                });
                              },
                              child: Icon(Icons.cancel, size: 16.0,)
                            ),
                      onSelected: (ObjectSourceType? sourceType) {
                        setState(() {
                          npcSourceType = sourceType;
                          npcSource = null;
                          sourceController.clear();
                        });
                      },
                      dropdownMenuEntries: ObjectSourceType.values
                        .map((ObjectSourceType s) => DropdownMenuEntry(value: s, label: s.title))
                        .toList(),
                    ),
                    DropdownMenu(
                      controller: sourceController,
                      enabled: npcSourceType != null,
                      label: Text(
                        'Source',
                        style: theme.textTheme.bodySmall,
                      ),
                      textStyle: theme.textTheme.bodySmall,
                      initialSelection: npcSource,
                      leadingIcon: npcSource == null
                          ? null
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  sourceController.clear();
                                  npcSource = null;
                                });
                              },
                              child: Icon(Icons.cancel, size: 16.0,)
                            ),
                      onSelected: (ObjectSource? source) {
                        setState(() {
                          npcSource = source;
                        });
                      },
                      dropdownMenuEntries: npcSourceType == null
                        ? <DropdownMenuEntry<ObjectSource>>[]
                        : ObjectSource.forType(npcSourceType!)
                          .map((ObjectSource s) => DropdownMenuEntry(value: s, label: s.name))
                          .toList(),
                    ),
                    DropdownMenu(
                      controller: categoryController,
                      label: Text(
                        'Catégorie',
                        style: theme.textTheme.bodySmall,
                      ),
                      textStyle: theme.textTheme.bodySmall,
                      initialSelection: npcCategory,
                      leadingIcon: npcCategory == null
                          ? null
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  categoryController.clear();
                                  npcCategory = null;
                                });
                              },
                              child: Icon(Icons.cancel, size: 16.0,)
                            ),
                      onSelected: (NPCCategory? category) {
                        setState(() {
                          npcCategory = category;
                          npcSubCategory = null;
                          subCategoryController.clear();
                          selectedDisplay = null;
                        });
                      },
                      dropdownMenuEntries: NPCCategory.values
                        .map((NPCCategory c) => DropdownMenuEntry(value: c, label: c.title))
                        .toList(),
                    ),
                    if(npcCategory != null)
                      DropdownMenu(
                        controller: subCategoryController,
                        label: Text(
                          'Sous-catégorie',
                          style: theme.textTheme.bodySmall,
                        ),
                        requestFocusOnTap: true,
                        textStyle: theme.textTheme.bodySmall,
                        initialSelection: npcSubCategory,
                        leadingIcon: npcSubCategory == null
                            ? null
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    subCategoryController.clear();
                                    npcSubCategory = null;
                                  });
                                },
                                child: Icon(Icons.cancel, size: 16.0,)
                              ),
                        onSelected: (NPCSubCategory? subCategory) {
                          setState(() {
                            npcSubCategory = subCategory;
                            selectedDisplay = null;
                          });
                        },
                        dropdownMenuEntries: npcCategory == null
                          ? <DropdownMenuEntry<NPCSubCategory>>[]
                          : NPCSubCategory.subCategoriesForCategory(npcCategory!)
                            .map((NPCSubCategory s) => DropdownMenuEntry(value: s, label: s.title))
                            .toList(),
                      ),
                    SizedBox(
                      width: 200.0,
                      child: TextField(
                        controller: searchController,
                        style: theme.textTheme.bodySmall,
                        decoration: InputDecoration(
                          labelText: 'Recherche',
                          labelStyle: theme.textTheme.bodySmall,
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                          prefixIcon: search == null
                            ? null
                            : GestureDetector(
                            onTap: () {
                              setState(() {
                                searchController.clear();
                                search = null;
                              });
                              FocusScope.of(context).unfocus();
                            },
                            child: Icon(Icons.cancel, size: 16.0,)
                          ),
                        ),
                        onSubmitted: (String? value) {
                          if(value == null || value.length >= 3) {
                            setState(() {
                              search = value;
                            });
                          }
                        },
                      ),
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
                          onPressed: () async {
                            var npc = await showDialog(
                              context: context,
                              builder: (BuildContext context) => NPCCreateDialog(
                                source: ObjectSource.local,
                              ),
                            );
                            if(!context.mounted) return;
                            if(npc == null) return;

                            creatingNewNPC = true;
                            _startEditing(npc);
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
                                _isWorking = true;
                              });

                              var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                              var j = json.decode(jsonStr);
                              var npc = await NonPlayerCharacter.import(j);

                              setState(() {
                                selectedDisplay = npc.id;
                                npcCategory = npc.category;
                                categoryController.text = npc.category.title;
                                npcSubCategory = npc.subCategory;
                                subCategoryController.text = npc.subCategory.title;
                                _isWorking = false;
                              });
                            } catch (e) {
                              setState(() {
                                _isWorking = false;
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
              if(npcs.isNotEmpty)
                Expanded(
                  child: NPCListWidget(
                    npcs: npcs,
                    initialSelection: selectedDisplay,
                    onEditRequested: (String id) async {
                      var npc = await NonPlayerCharacter.get(id);
                      if(npc == null) return;
                      _startEditing(npc);
                    },
                    onCloneRequested: (String id) async {
                      var npc = await NonPlayerCharacter.get(id);
                      if(!context.mounted) return;
                      if(npc == null) return;

                      var clone = await showDialog<NonPlayerCharacter>(
                        context: context,
                        builder: (BuildContext context) => NPCCreateDialog(
                          source: ObjectSource.local,
                          cloneFrom: npc,
                        ),
                      );
                      if(!context.mounted) return;
                      if(clone == null) return;

                      creatingNewNPC = false;
                      _startEditing(clone);
                    },
                    onDeleteRequested: (String id) async {
                      try {
                        await NonPlayerCharacter.deleteLocalModel(id);
                        setState(() {
                          selectedDisplay = null;
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
                  ),
                ),
            ],
          );
        }
      );
    }

    return Stack(
      children: [
        mainArea,
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
}