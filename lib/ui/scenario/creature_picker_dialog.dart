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

  late Future<Iterable<CreatureSummary>> creaturesFuture;
  CreatureSummary? selectedCreatureSummary;

  @override
  void initState() {
    super.initState();
    updateCreaturesFuture();
  }

  void updateCreaturesFuture() {
    if(selectedSource != null) {
      creaturesFuture = CreatureSummary.forSource(selectedSource!, selectedCategory);
    }
    else if(selectedSourceType != null) {
      creaturesFuture = CreatureSummary.forSourceType(selectedSourceType!, selectedCategory);
    }
    else if(selectedCategory != null) {
      creaturesFuture = CreatureSummary.forCategory(selectedCategory!);
    }
    else {
      creaturesFuture = Future<Iterable<CreatureSummary>>.sync(
        () => <CreatureSummary>[]
      );
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
                  updateCreaturesFuture();
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
                  updateCreaturesFuture();
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
                    updateCreaturesFuture();
                    creatureController.text = '';
                    selectedCreatureSummary = null;
                  });
                }
            ),
            SizedBox(height: spacing),
            FutureBuilder(
              future: creaturesFuture,
              builder: (BuildContext context, AsyncSnapshot<Iterable<CreatureSummary>> snapshot) {
                Widget? trailing;

                if(snapshot.connectionState == ConnectionState.waiting) {
                  trailing = CircularProgressIndicator();
                }

                if(snapshot.hasError) {
                  trailing = Icon(Icons.warning);
                }

                var creatures = <CreatureSummary>[];
                if(snapshot.hasData && snapshot.data != null) {
                  creatures.addAll(snapshot.data!);
                }

                return DropdownMenu(
                  controller: creatureController,
                  requestFocusOnTap: true,
                  label: const Text('Créature'),
                  expandedInsets: EdgeInsets.zero,
                  trailingIcon: trailing,
                  dropdownMenuEntries:
                    creatures.map((CreatureSummary c) =>
                      DropdownMenuEntry<CreatureSummary>(value: c, label: c.name)
                    ).toList(),
                  onSelected: (CreatureSummary? c) {
                    selectedCreatureSummary = c;
                  },
                );
              }
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