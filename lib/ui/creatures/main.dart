import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/object_source.dart';
import '../utils/creature_edit_widget.dart';
import '../utils/creature_list_widget.dart';
import '../utils/error_feedback.dart';
import '../utils/single_line_input_dialog.dart';
import '../../text_utils.dart';

class CreaturesMainPage extends StatefulWidget {
  const CreaturesMainPage({ super.key });

  @override
  State<CreaturesMainPage> createState() => _CreaturesMainPageState();
}

class _CreaturesMainPageState extends State<CreaturesMainPage> {
  final TextEditingController categoryController = TextEditingController();
  // final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> newCreatureFormKey = GlobalKey();
  CreatureCategory? creatureCategory;
  // String? _search;
  bool editing = false;
  String? selectedDisplay;
  String? selectedEdit;
  CreatureModel? selectedEditModel;
  String? newCreatureName;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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
      mainArea = Column(
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
                  controller: categoryController,
                  label: const Text('Catégorie'),
                  textStyle: theme.textTheme.bodySmall,
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
                // SizedBox(
                //   width: 350.0,
                //   child: TextFormField(
                //     controller: _searchController,
                //     style: theme.textTheme.bodySmall,
                //     decoration: const InputDecoration(
                //       labelText: 'Recherche',
                //       border: OutlineInputBorder(),
                //       suffixIcon: Icon(Icons.search),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 8.0),
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
                          var creature = CreatureModel.fromJson(json.decode(jsonStr));
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

                          creature.editable = true;
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
          if(creatureCategory != null)
            Expanded(
              child: CreaturesListWidget(
                category: creatureCategory!,
                initialSelection: selectedDisplay,
                onEditRequested: (CreatureModel model) {
                  setState(() {
                    newCreatureName = model.name;
                    selectedEdit = model.id;
                    selectedEditModel = model;
                    editing = true;
                  });
                },
                restrictModificationToSourceTypes: [
                  ObjectSourceType.original
                ],
              ),
            ),
        ],
      );
    }

    return mainArea;
  }
}