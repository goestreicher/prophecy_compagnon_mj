import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/object_source.dart';
import '../utils/creature/create_dialog.dart';
import '../utils/creature/edit_widget.dart';
import '../utils/creature/list_widget.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';

class CreaturesMainPage extends StatefulWidget {
  const CreaturesMainPage({ super.key });

  @override
  State<CreaturesMainPage> createState() => _CreaturesMainPageState();
}

class _CreaturesMainPageState extends State<CreaturesMainPage> {
  final TextEditingController sourceTypeController = TextEditingController();
  ObjectSourceType? creatureSourceType;
  final TextEditingController sourceController = TextEditingController();
  ObjectSource? creatureSource;
  final TextEditingController categoryController = TextEditingController();
  CreatureCategory? creatureCategory;
  final TextEditingController searchController = TextEditingController();
  String? search;

  bool editing = false;
  bool creatingNewModel = false;
  String? selectedDisplay;
  Creature? selectedEditModel;

  void _startEditing(Creature model) {
    setState(() {
      selectedEditModel = model;
      editing = true;
    });
  }

  Future<Iterable<CreatureSummary>> _updateCreaturesList() async {
    if(creatureSource != null) {
      return CreatureSummary.forSource(creatureSource!, creatureCategory, nameFilter: search);
    }
    else if(creatureSourceType != null) {
      return CreatureSummary.forSourceType(creatureSourceType!, creatureCategory, nameFilter: search);
    }
    else if(creatureCategory != null) {
      return CreatureSummary.forCategory(creatureCategory!, nameFilter: search);
    }

    return CreatureSummary.getAll(nameFilter: search);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainArea;

    if(editing && selectedEditModel != null) {
      mainArea = CreatureEditWidget(
        creature: selectedEditModel!,
        onEditDone: (bool result) async {
          if(result) {
            await Creature.saveLocalModel(selectedEditModel!);
            selectedDisplay = selectedEditModel!.id;
            creatureCategory = selectedEditModel!.category;
            creatureSourceType = selectedEditModel!.source.type;
          }
          else {
            if(creatingNewModel) {
              Creature.removeFromCache(selectedEditModel!.id);
            }
            else {
              await Creature.reloadFromStore(selectedEditModel!.id);
            }
          }

          setState(() {
            selectedEditModel = null;
            editing = false;
            creatingNewModel = false;
          });
        },
      );
    }
    else {
      mainArea = FutureBuilder(
        future: _updateCreaturesList(),
        builder: (BuildContext context, AsyncSnapshot<Iterable<CreatureSummary>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return FullPageLoadingWidget();
          }

          if(snapshot.hasError) {
            return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: true);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return FullPageErrorWidget(message: 'Aucune donnée retournée', canPop: true);
          }

          var creatures = snapshot.data!.toList();
          creatures.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
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
                      initialSelection: creatureSourceType,
                      leadingIcon: creatureSourceType == null
                          ? null
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  sourceTypeController.clear();
                                  creatureSourceType = null;
                                  sourceController.clear();
                                  creatureSource = null;
                                });
                              },
                              child: Icon(Icons.cancel, size: 16.0,)
                            ),
                      onSelected: (ObjectSourceType? sourceType) {
                        setState(() {
                          creatureSourceType = sourceType;
                          sourceController.clear();
                          creatureSource = null;
                        });
                      },
                      dropdownMenuEntries: ObjectSourceType.values
                        .map((ObjectSourceType s) => DropdownMenuEntry(value: s, label: s.title))
                        .toList(),
                    ),
                    DropdownMenu(
                      controller: sourceController,
                      enabled: creatureSourceType != null,
                      label: Text(
                        'Source',
                        style: theme.textTheme.bodySmall,
                      ),
                      textStyle: theme.textTheme.bodySmall,
                      initialSelection: creatureSource,
                      leadingIcon: creatureSource == null
                          ? null
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  sourceController.clear();
                                  creatureSource = null;
                                });
                              },
                              child: Icon(Icons.cancel, size: 16.0,)
                            ),
                      onSelected: (ObjectSource? source) {
                        setState(() {
                          creatureSource = source;
                        });
                      },
                      dropdownMenuEntries: creatureSourceType == null
                        ? <DropdownMenuEntry<ObjectSource>>[]
                        : ObjectSource.forType(creatureSourceType!)
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
                      initialSelection: creatureCategory,
                      leadingIcon: creatureCategory == null
                          ? null
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  categoryController.clear();
                                  creatureCategory = null;
                                });
                              },
                              child: Icon(Icons.cancel, size: 16.0,)
                            ),
                      onSelected: (CreatureCategory? category) {
                        setState(() {
                          creatureCategory = category;
                          selectedDisplay = null;
                        });
                      },
                      dropdownMenuEntries: CreatureCategory.values
                        .map((CreatureCategory c) => DropdownMenuEntry(value: c, label: c.title))
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
                              Text('Nouvelle créature'),
                            ],
                          ),
                          onPressed: () async {
                            var creature = await showDialog<Creature>(
                              context: context,
                              builder: (BuildContext context) => CreatureCreateDialog(
                                source: ObjectSource.local,
                              ),
                            );
                            if(!context.mounted) return;
                            if(creature == null) return;

                            creatingNewModel = true;
                            _startEditing(creature);
                          },
                        ),
                        MenuItemButton(
                          child: const Row(
                            children: [
                              Icon(Icons.publish),
                              SizedBox(width: 4.0),
                              Text('Importer une créature'),
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
                              var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                              var j = json.decode(jsonStr);
                              var creature = await Creature.import(j);

                              setState(() {
                                creatureCategory = creature.category;
                                selectedDisplay = creature.id;
                              });
                            } catch (e) {
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
              if(creatures.isNotEmpty)
                Expanded(
                  child: CreaturesListWidget(
                    creatures: creatures,
                    initialSelection: selectedDisplay,
                    onEditRequested: (String id) async {
                      var model = await Creature.get(id);
                      if(model == null) return;
                      _startEditing(model);
                    },
                    onCloneRequested: (String id) async {
                      var model = await Creature.get(id);
                      if(!context.mounted) return;
                      if(model == null) return;

                      var clone = await showDialog<Creature>(
                        context: context,
                        builder: (BuildContext context) => CreatureCreateDialog(
                          source: ObjectSource.local,
                          cloneFrom: model,
                        ),
                      );
                      if(!context.mounted) return;
                      if(clone == null) return;

                      creatingNewModel = true;
                      _startEditing(clone);
                    },
                    onDeleteRequested: (String id) async {
                      try {
                        await Creature.deleteLocalModel(id);
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

    return mainArea;
  }
}