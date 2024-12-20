import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../../classes/object_source.dart';
import '../utils/error_feedback.dart';
import '../utils/npc_edit_widget.dart';
import '../utils/npc_list_widget.dart';
import '../utils/single_line_input_dialog.dart';
import '../../text_utils.dart';

class NPCMainPage extends StatefulWidget {
  const NPCMainPage({ super.key });

  @override
  State<NPCMainPage> createState() => _NPCMainPageState();
}

class _NPCMainPageState extends State<NPCMainPage> {
  bool _isWorking = false;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final GlobalKey<FormState> newNPCFormKey = GlobalKey();
  NPCCategory? npcCategory;
  NPCSubCategory? npcSubCategory;
  bool editing = false;
  String? selectedDisplay;
  String? selectedEdit;
  NonPlayerCharacter? selectedEditNPC;
  String? newNPCName;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;

    if(editing && newNPCName != null) {
      mainArea = NPCEditWidget(
        name: newNPCName!,
        npc: selectedEditNPC,
        npcId: selectedEdit,
        onEditDone: (NonPlayerCharacter? npc) {
          if(newNPCName != null) {
            newNPCName = null;
          }

          setState(() {
            if(npc != null) {
              selectedDisplay = npc.id;
              npcCategory = npc.category;
              npcSubCategory = npc.subCategory;
            }
            selectedEdit = null;
            selectedEditNPC = null;
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
                    label: const Text('Sous-catégorie'),
                    requestFocusOnTap: true,
                    textStyle: theme.textTheme.bodySmall,
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
                          Text('Nouveau PNJ'),
                        ],
                      ),
                      onPressed: () async {
                        var name = await showDialog(
                          context: context,
                          builder: (BuildContext context) => SingleLineInputDialog(
                            title: 'Nom du PNJ',
                            formKey: newNPCFormKey,
                            hintText: 'Nom',
                          ),
                        );
                        if(!context.mounted) return;
                        if(name == null) return;

                        var id = sentenceToCamelCase(transliterateFrenchToAscii(name));
                        var model = await NonPlayerCharacter.get(id);
                        if(!context.mounted) return;
                        if(model != null) {
                          displayErrorDialog(
                            context,
                            'PNJ existant',
                            'Un PNJ avec ce nom (ou un nom similaire) existe déjà'
                          );
                          return;
                        }

                        setState(() {
                          selectedEdit = null;
                          selectedEditNPC = null;
                          newNPCName = name;
                          editing = true;
                        });
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
                        );
                        if(!context.mounted) return;
                        if(result == null) return;

                        try {
                          setState(() {
                            _isWorking = true;
                          });

                          var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                          var npc = NonPlayerCharacter.fromJson(json.decode(jsonStr));
                          var model = await NonPlayerCharacter.get(npc.id);
                          if(!context.mounted) return;
                          if(model != null) {
                            setState(() {
                              _isWorking = false;
                            });

                            displayErrorDialog(
                              context,
                              'PNJ existant',
                              'Un PNJ avec ce nom (ou un nom similaire) existe déjà'
                            );
                            return;
                          }

                          npc.editable = true;
                          await NonPlayerCharacter.saveLocalModel(npc);
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
          if(npcCategory != null)
            Expanded(
              child: NPCListWidget(
                category: npcCategory!,
                subCategory: npcSubCategory,
                initialSelection: selectedDisplay,
                onEditRequested: (NonPlayerCharacter npc) {
                  setState(() {
                    newNPCName = npc.name;
                    selectedEdit = npc.id;
                    selectedEditNPC = npc;
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