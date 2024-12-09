import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';

class NPCPickerDialog extends StatefulWidget {
  const NPCPickerDialog({ super.key });

  @override
  State<NPCPickerDialog> createState() => _NPCPickerDialogState();
}

class _NPCPickerDialogState extends State<NPCPickerDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController categoryController = TextEditingController();
  NPCCategory? selectedCategory = NPCCategory.scenario;
  final TextEditingController subCategoryController = TextEditingController();
  List<NPCSubCategory> subcategories = <NPCSubCategory>[];
  NPCSubCategory? selectedSubCategory;
  final TextEditingController npcController = TextEditingController();
  List<NonPlayerCharacter> npcs = <NonPlayerCharacter>[];
  String? selectedNpcId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sélectionner le PNJ'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu(
              controller: categoryController,
              requestFocusOnTap: true,
              label: const Text('Catégorie'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries:
                NPCCategory.values.map(
                  (NPCCategory c) => DropdownMenuEntry<NPCCategory>(value: c, label: c.title),
                ).toList(),
              initialSelection: selectedCategory,
              onSelected: (NPCCategory? c) {
                if(c == null) return;
                setState(() {
                  selectedCategory = c;
                  // TODO: if the current scenario doesn't exist in the sub-categories, create it here
                  subCategoryController.text = '';
                  subcategories = NPCSubCategory.subCategoriesForCategory(c);
                  selectedSubCategory = null;
                  npcController.text = '';
                  npcs.clear();
                  selectedNpcId = null;
                });
              },
            ),
            const SizedBox(height: 8.0),
            DropdownMenu(
              controller: subCategoryController,
              requestFocusOnTap: true,
              label: const Text('Sous-catégorie'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: selectedCategory == null
                ? <DropdownMenuEntry<NPCSubCategory>>[]
                : NPCSubCategory.subCategoriesForCategory(selectedCategory!).map(
                    (NPCSubCategory s) => DropdownMenuEntry<NPCSubCategory>(value: s, label: s.title)
                  ).toList(),
              onSelected: (NPCSubCategory? s) {
                if(s == null) return;
                setState(() {
                  selectedSubCategory = s;
                  npcController.text = '';
                  npcs.clear();
                  selectedNpcId = null;
                });
              },
            ),
            const SizedBox(height: 8.0),
            DropdownMenu(
              controller: npcController,
              requestFocusOnTap: true,
              label: const Text('Personnage'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: selectedCategory == null || selectedSubCategory == null
                ? <DropdownMenuEntry<NonPlayerCharacter>>[]
                : NonPlayerCharacter.forCategory(selectedCategory!, selectedSubCategory).map(
                    (NonPlayerCharacter npc) => DropdownMenuEntry(value: npc, label: npc.name)
                  ).toList(),
              onSelected: (NonPlayerCharacter? npc) {
                if(npc == null) return;
                setState(() {
                  selectedNpcId = npc.id;
                });
              },
            ),
          ],
        )
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler')
        ),
        TextButton(
          onPressed: selectedNpcId == null
            ? null
            : () => Navigator.of(context).pop(selectedNpcId),
          child: const Text('OK'),
        )
      ],
    );
  }
}