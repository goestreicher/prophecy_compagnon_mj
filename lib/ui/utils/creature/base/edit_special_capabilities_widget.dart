import 'package:flutter/material.dart';

import '../../../../classes/creature.dart';
import '../../widget_group_container.dart';
import 'display_special_capability_widget.dart';

class CreatureEditSpecialCapabilitiesWidget extends StatefulWidget {
  const CreatureEditSpecialCapabilitiesWidget({ super.key, required this.creature });

  final Creature creature;

  @override
  State<CreatureEditSpecialCapabilitiesWidget> createState() => _CreatureEditSpecialCapabilitiesWidgetState();
}

class _CreatureEditSpecialCapabilitiesWidgetState extends State<CreatureEditSpecialCapabilitiesWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var (index, c) in widget.creature.specialCapabilities.indexed) {
      widgets.add(
        _SpecialCapabilityEditWidget(
          capability: c,
          onChanged: (CreatureSpecialCapability c) => setState(() {
            widget.creature.specialCapabilities[index] = c;
          }),
          onDelete: () => setState(() {
            widget.creature.specialCapabilities.removeAt(index);
          }),
        )
      );
    }

    return WidgetGroupContainer(
      title: Text(
        'Capacités spéciales',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: Center(
        child:
          Column(
            spacing: 8.0,
            children: [
              ...widgets,
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                  size: 16.0,
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: theme.textTheme.bodySmall,
                ),
                label: const Text('Nouvelle capacité spéciale'),
                onPressed: () async {
                  CreatureSpecialCapability? c = await showDialog(
                    context: context,
                    builder: (BuildContext context) => _SpecialCapabilityEditDialog(),
                  );
                  if(c == null) return;
                  setState(() {
                    widget.creature.specialCapabilities.add(c);
                  });
                },
              ),
            ],
          )
      ),
    );
  }
}

class _SpecialCapabilityEditWidget extends StatelessWidget {
  const _SpecialCapabilityEditWidget({
    required this.capability,
    required this.onChanged,
    required this.onDelete
  });

  final CreatureSpecialCapability capability;
  final void Function(CreatureSpecialCapability) onChanged;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          spacing: 16.0,
          children: [
            Expanded(
              child: CreatureDisplaySpecialCapability(
                capability: capability,
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                iconSize: 24.0,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(),
              onPressed: () async {
                CreatureSpecialCapability? c = await showDialog(
                  context: context,
                  builder: (BuildContext context) => _SpecialCapabilityEditDialog(
                    source: capability,
                  ),
                );
                if(c == null) return;
                onChanged(c);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              style: IconButton.styleFrom(
                iconSize: 24.0,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(),
              onPressed: () => onDelete(),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecialCapabilityEditDialog extends StatefulWidget {
  const _SpecialCapabilityEditDialog({ this.source });

  final CreatureSpecialCapability? source;

  @override
  State<_SpecialCapabilityEditDialog> createState() => _SpecialCapabilityEditDialogState();
}

class _SpecialCapabilityEditDialogState extends State<_SpecialCapabilityEditDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.source != null) {
      nameController.text = widget.source!.name;
      descriptionController.text = widget.source!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Éditer la capacité spéciale'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  label: const Text('Nom'),
                  border: const OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return 'Valeur manquante';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  label: const Text('Description'),
                  border: const OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return 'Valeur manquante';
                  }
                  return null;
                },
              ),
            ],
          )
        )
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            if(!formKey.currentState!.validate()) return;
            var capability = CreatureSpecialCapability(
              name: nameController.text,
              description: descriptionController.text,
            );
            Navigator.of(context).pop(capability);
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}