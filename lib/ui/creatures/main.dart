import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../utils/creature_display_widget.dart';
import '../utils/creature_edit_widget.dart';
import '../utils/creature_list_widget.dart';
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
  CreatureModel? _selected;
  String? _newCreatureName;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;

    if(editing) {
      mainArea = CreatureEditWidget(
        creature: _selected,
        name: _newCreatureName,
        onEditDone: (CreatureModel? creature) {
          if(_newCreatureName != null) {
            _newCreatureName = null;
          }

          setState(() {
            if(creature != null) {
              _selected = creature;
              _category = creature.category;
            }
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
                requestFocusOnTap: true,
                textStyle: theme.textTheme.bodySmall,
                onSelected: (CreatureCategory? category) {
                  setState(() {
                    _category = category;
                    _selected = null;
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
                  var model = CreatureModel.get(id);
                  if(model != null) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Créature existante'),
                        content: const Text('Une créature avec ce nom (ou un nom similaire) existe déjà'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _selected = null;
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
                    var model = CreatureModel.get(creature.id);
                    if(model != null) {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Créature existante'),
                          content: const Text('Une créature avec ce nom (ou un nom similaire) existe déjà'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    CreatureModel.saveLocalModel(creature);
                    setState(() {
                      _category = creature.category;
                      _selected = creature;
                    });
                  } catch (e) {
                    // TODO: notify the user that things went south
                    // TODO: catch FormatException from the UTF-8 conversion?
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
                        selected: _selected,
                        onSelected: (CreatureModel model) {
                          setState(() {
                            _selected = model;
                          });
                        },
                      )
                  ),
                  const SizedBox(width: 12.0),
                  if(_selected != null)
                    Expanded(
                      child: CreatureDisplayWidget(
                        creature: _selected!,
                        onEditRequested: () {
                          setState(() {
                            editing = true;
                          });
                        },
                        onCloneEditRequested: (CreatureModel clone) {
                          setState(() {
                            _selected = clone;
                            editing = true;
                          });
                        },
                        onDelete: () {
                          setState(() {
                            CreatureModel.deleteLocalModel(_selected!.id);
                            _selected = null;
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