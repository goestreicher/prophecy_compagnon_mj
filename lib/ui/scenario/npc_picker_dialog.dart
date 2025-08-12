import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../../classes/object_source.dart';

class NPCPickerDialog extends StatefulWidget {
  const NPCPickerDialog({ super.key });

  @override
  State<NPCPickerDialog> createState() => _NPCPickerDialogState();
}

class _NPCPickerDialogState extends State<NPCPickerDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController sourceTypeController = TextEditingController();
  ObjectSourceType? selectedSourceType;
  final TextEditingController sourceController = TextEditingController();
  ObjectSource? selectedSource;
  final TextEditingController categoryController = TextEditingController();
  NPCCategory? selectedCategory;
  final TextEditingController subCategoryController = TextEditingController();
  List<NPCSubCategory> subcategories = <NPCSubCategory>[];
  NPCSubCategory? selectedSubCategory;
  final TextEditingController npcController = TextEditingController();
  List<NonPlayerCharacterSummary> npcs = <NonPlayerCharacterSummary>[];
  String? selectedNpcId;

  void _applyCurrentFilter() {
    if(selectedSource != null) {
      npcs = NonPlayerCharacterSummary.forSource(selectedSource!, selectedCategory, selectedSubCategory);
    }
    else if(selectedSourceType != null) {
      npcs = NonPlayerCharacterSummary.forSourceType(selectedSourceType!, selectedCategory, selectedSubCategory);
    }
    else if(selectedCategory != null) {
      npcs = NonPlayerCharacterSummary.forCategory(selectedCategory!, selectedSubCategory);
    }
    else {
      npcs = <NonPlayerCharacterSummary>[];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var spacing = 12.0;

    return AlertDialog(
      title: const Text('Sélectionner le PNJ'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu(
              controller: sourceTypeController,
              requestFocusOnTap: true,
              label: const Text('Type de source'),
              expandedInsets: EdgeInsets.zero,
              initialSelection: selectedSourceType,
              onSelected: (ObjectSourceType? type) {
                setState(() {
                  selectedSourceType = type;
                  sourceController.clear();
                  selectedSource = null;
                  _applyCurrentFilter();
                  npcController.text = '';
                  selectedNpcId = null;
                });
              },
              dropdownMenuEntries: ObjectSourceType.values
                .map((ObjectSourceType type) => DropdownMenuEntry(value: type, label: type.title))
                .toList(),
            ),
            SizedBox(height: spacing),
            DropdownMenu(
              controller: sourceController,
              enabled: selectedSourceType != null,
              requestFocusOnTap: true,
              label: const Text('Source'),
              expandedInsets: EdgeInsets.zero,
              initialSelection: selectedSource,
              onSelected: (ObjectSource? source) {
                setState(() {
                  selectedSource = source;
                  _applyCurrentFilter();
                  npcController.text = '';
                  selectedNpcId = null;
                });
              },
              dropdownMenuEntries: selectedSourceType == null
                ? <DropdownMenuEntry<ObjectSource>>[]
                : ObjectSource.forType(selectedSourceType!)
                  .map((ObjectSource s) => DropdownMenuEntry(value: s, label: s.name))
                  .toList(),
            ),
            SizedBox(height: spacing),
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
                  subcategories = NPCSubCategory.subCategoriesForCategory(c);
                  subCategoryController.text = '';
                  selectedSubCategory = null;
                  _applyCurrentFilter();
                  npcController.text = '';
                  selectedNpcId = null;
                });
              },
            ),
            SizedBox(height: spacing),
            DropdownMenu(
              controller: subCategoryController,
              requestFocusOnTap: true,
              label: const Text('Sous-catégorie'),
              expandedInsets: EdgeInsets.zero,
              initialSelection: selectedSubCategory,
              dropdownMenuEntries: selectedCategory == null
                ? <DropdownMenuEntry<NPCSubCategory>>[]
                : subcategories.map(
                    (NPCSubCategory s) => DropdownMenuEntry<NPCSubCategory>(value: s, label: s.title)
                  ).toList(),
              onSelected: (NPCSubCategory? s) {
                if(s == null) return;
                setState(() {
                  selectedSubCategory = s;
                  _applyCurrentFilter();
                  npcController.text = '';
                  selectedNpcId = null;
                });
              },
            ),
            SizedBox(height: spacing),
            DropdownMenu(
              controller: npcController,
              requestFocusOnTap: true,
              label: const Text('Personnage'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: npcs
                .map((NonPlayerCharacterSummary npc) => DropdownMenuEntry(value: npc, label: npc.name))
                .toList(),
              onSelected: (NonPlayerCharacterSummary? npc) {
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