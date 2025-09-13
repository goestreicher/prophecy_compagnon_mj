import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/object_source.dart';

class CreaturePickerDialog extends StatefulWidget {
  const CreaturePickerDialog({ super.key });

  @override
  State<CreaturePickerDialog> createState() => CreaturePickerDialogState();
}

class CreaturePickerDialogState extends State<CreaturePickerDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController sourceTypeController = TextEditingController();
  ObjectSourceType? selectedSourceType;
  final TextEditingController sourceController = TextEditingController();
  ObjectSource? selectedSource;
  final TextEditingController categoryController = TextEditingController();
  CreatureCategory? selectedCategory;
  final TextEditingController creatureController = TextEditingController();
  List<CreatureSummary> creatures = <CreatureSummary>[];
  CreatureSummary? selectedCreatureSummary;

  void _applyCurrentFilter() {
    if(selectedSource != null) {
      creatures = CreatureSummary.forSource(selectedSource!, selectedCategory);
    }
    else if(selectedSourceType != null) {
      creatures = CreatureSummary.forSourceType(selectedSourceType!, selectedCategory);
    }
    else if(selectedCategory != null) {
      creatures = CreatureSummary.forCategory(selectedCategory!);
    }
    else {
      creatures = <CreatureSummary>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    var spacing = 12.0;
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélectionner la créature'),
      content: Form(
        key: _formKey,
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
                  selectedSource = null;
                  sourceController.clear();
                  _applyCurrentFilter();
                  creatureController.text = '';
                  selectedCreatureSummary = null;
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
                  creatureController.text = '';
                  selectedCreatureSummary = null;
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
                CreatureCategory.values.map((CreatureCategory c) =>
                  DropdownMenuEntry<CreatureCategory>(value: c, label: c.title)
                ).toList(),
              onSelected: (CreatureCategory? c) {
                  if(c == null) return;
                  setState(() {
                    selectedCategory = c;
                    _applyCurrentFilter();
                    creatureController.text = '';
                    selectedCreatureSummary = null;
                  });
                }
            ),
            SizedBox(height: spacing),
            DropdownMenu(
              controller: creatureController,
              requestFocusOnTap: true,
              label: const Text('Créature'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries:
                creatures.map((CreatureSummary c) =>
                  DropdownMenuEntry<CreatureSummary>(value: c, label: c.name)
                ).toList(),
              onSelected: (CreatureSummary? c) {
                selectedCreatureSummary = c;
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        if(categoryController.text.isEmpty) return;
                        if(creatureController.text.isEmpty) return;
                        Navigator.of(context).pop(selectedCreatureSummary);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: const Text('OK'),
                    )
                  ],
                )
            ),
          ],
        ),
      )
    );
  }
}