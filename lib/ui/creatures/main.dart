import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../utils/creature_display_widget.dart';
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
  final TextEditingController _categoryController = TextEditingController();
  // final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _newCreatureFormKey = GlobalKey();
  CreatureCategory? _category;
  // String? _search;
  bool editing = false;
  String? _selectedDisplay;
  String? _selectedEdit;
  CreatureModel? _selectedEditModel;
  String? _newCreatureName;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;

    if(editing && _newCreatureName != null) {
      mainArea = CreatureEditWidget(
        name: _newCreatureName!,
        creatureId: _selectedEdit,
        creature: _selectedEditModel,
        onEditDone: (CreatureModel? creature) {
          setState(() {
            if(creature != null) {
              _selectedDisplay = creature.id;
              _category = creature.category;
            }
            _newCreatureName = null;
            _selectedEdit = null;
            _selectedEditModel = null;
            editing = false;
          });
        },
      );
    }
    else {
      mainArea = Column(
        children: [
          Row(
            children: [
              DropdownMenu(
                controller: _categoryController,
                label: const Text('Catégorie'),
                textStyle: theme.textTheme.bodySmall,
                onSelected: (CreatureCategory? category) {
                  setState(() {
                    _category = category;
                    _selectedDisplay = null;
                  });
                },
                dropdownMenuEntries: CreatureCategory.values
                    .map((CreatureCategory c) => DropdownMenuEntry(value: c, label: c.title))
                    .toList(),
              ),
              const SizedBox(width: 8.0),
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
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Nouvelle créature'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                onPressed: () async {
                  var name = await showDialog(
                    context: context,
                    builder: (BuildContext context) => SingleLineInputDialog(
                      title: 'Nom de la créature',
                      formKey: _newCreatureFormKey,
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
                    _selectedEdit = null;
                    _newCreatureName = name;
                    editing = true;
                  });
                },
              ),
              const SizedBox(width: 8.0),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text('Importer une créature'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
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
                      _category = creature.category;
                      _selectedDisplay = creature.id;
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
          const SizedBox(height: 12.0),
          if(_category != null)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 350,
                    child: CreaturesListWidget(
                      category: _category!,
                      selected: _selectedDisplay,
                      onSelected: (String creatureId) {
                        setState(() {
                          _selectedDisplay = creatureId;
                        });
                      },
                    )
                  ),
                  const SizedBox(width: 12.0),
                  if(_selectedDisplay != null)
                    Expanded(
                      child: CreatureDisplayWidget(
                        creature: _selectedDisplay!,
                        onEditRequested: (CreatureModel model) {
                          setState(() {
                            _newCreatureName = model.name;
                            _selectedEdit = model.id;
                            _selectedEditModel = model;
                            editing = true;
                          });
                        },
                        onDelete: () async {
                          try {
                            await CreatureModel.deleteLocalModel(_selectedDisplay!);
                          }
                          catch(e) {
                            if(!context.mounted) return;
                            displayErrorDialog(
                              context,
                              "Suppression impossible",
                              e.toString()
                            );
                          }
                          setState(() {
                            _selectedDisplay = null;
                          });
                        }
                      )
                    ),
                ],
              ),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: mainArea,
    );
  }
}