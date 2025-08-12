import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/object_source.dart';
import '../utils/creature_edit_widget.dart';
import '../utils/creature_list_widget.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';
import '../utils/single_line_input_dialog.dart';
import '../../text_utils.dart';

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
  final GlobalKey<FormState> newCreatureFormKey = GlobalKey();
  bool editing = false;
  String? selectedDisplay;
  String? selectedEdit;
  CreatureModel? selectedEditModel;
  String? newCreatureName;

  void _startEditing(CreatureModel model) {
    setState(() {
      newCreatureName = model.name;
      selectedEdit = model.id;
      selectedEditModel = model;
      editing = true;
    });
  }

  Future<List<CreatureModelSummary>> _updateCreaturesList() async {
    if(creatureSource != null) {
      return CreatureModelSummary.forSource(creatureSource!, creatureCategory, nameFilter: search);
    }
    else if(creatureSourceType != null) {
      return CreatureModelSummary.forSourceType(creatureSourceType!, creatureCategory, nameFilter: search);
    }
    else if(creatureCategory != null) {
      return CreatureModelSummary.forCategory(creatureCategory!);
    }

    return <CreatureModelSummary>[];
  }

  @override
  Widget build(BuildContext context) {
    Widget mainArea;

    if(editing && newCreatureName != null) {
      mainArea = CreatureEditWidget(
        name: newCreatureName!,
        creatureId: selectedEdit,
        creature: selectedEditModel,
        onEditDone: (CreatureModel? creature) {
          setState(() {
            if(creature != null) {
              selectedDisplay = creature.id;
              creatureCategory = creature.category;
              creatureSourceType = creature.source.type;
            }
            newCreatureName = null;
            selectedEdit = null;
            selectedEditModel = null;
            editing = false;
          });
        },
      );
    }
    else {
      mainArea = FutureBuilder(
        future: _updateCreaturesList(),
        builder: (BuildContext context, AsyncSnapshot<List<CreatureModelSummary>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return FullPageLoadingWidget();
          }

          if(snapshot.hasError) {
            return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: true);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return FullPageErrorWidget(message: 'Aucune donnée retournée', canPop: true);
          }

          var creatures = snapshot.data!;
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
                      label: const Text('Type de source'),
                      textStyle: theme.textTheme.bodySmall,
                      initialSelection: creatureSourceType,
                      leadingIcon: creatureSourceType == null
                          ? null
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  sourceTypeController.clear();
                                  creatureSourceType = null;
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
                      label: const Text('Source'),
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
                      label: const Text('Catégorie'),
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
                              Text('Nouvelle créature'),
                            ],
                          ),
                          onPressed: () async {
                            var name = await showDialog(
                              context: context,
                              builder: (BuildContext context) => SingleLineInputDialog(
                                title: 'Nom de la créature',
                                formKey: newCreatureFormKey,
                                hintText: 'Nom',
                              ),
                            );
                            if(!context.mounted) return;
                            if(name == null) return;

                            var id = sentenceToCamelCase(transliterateFrenchToAscii(name));
                            var model = await CreatureModel.get(id);
                            if(!context.mounted) return;
                            if(model != null) {
                              displayErrorDialog(
                                context,
                                'Créature existante',
                                'Une créature avec ce nom (ou un nom similaire) existe déjà'
                              );
                              return;
                            }

                            setState(() {
                              selectedEdit = null;
                              newCreatureName = name;
                              editing = true;
                            });
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
                            );
                            if(!context.mounted) return;
                            if(result == null) return;

                            try {
                              var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                              var j = json.decode(jsonStr);
                              var creature = CreatureModel.fromJson(j);
                              var model = await CreatureModel.get(creature.id);
                              if(!context.mounted) return;
                              if(model != null) {
                                displayErrorDialog(
                                  context,
                                  'Créature existante',
                                  'Une créature avec ce nom (ou un nom similaire) existe déjà'
                                );
                                return;
                              }

                              await CreatureModel.saveLocalModel(creature);
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
                    onEditRequested: (int index) async {
                      var model = await CreatureModel.get(creatures[index].id);
                      if(model == null) return;
                      _startEditing(model);
                    },
                    onCloneRequested: (int index, String newName) async {
                      var model = await CreatureModel.get(creatures[index].id);
                      if(model == null) return;

                      CreatureModel clone = model.clone(newName);
                      clone.source = ObjectSource.local;

                      _startEditing(clone);
                    },
                    onDeleteRequested: (int index) async {
                      try {
                        await CreatureModel.deleteLocalModel(creatures[index].id);
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