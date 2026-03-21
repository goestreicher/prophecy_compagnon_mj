import 'package:flutter/material.dart';

import '../../../classes/equipment/equipment.dart';
import '../widget_group_container.dart';

class EquipmentSpecialCapabilitiesEditWidget extends StatefulWidget {
  const EquipmentSpecialCapabilitiesEditWidget({
    super.key,
    this.special,
    required this.onChanged,
  });

  final List<EquipmentSpecialCapability>? special;
  final void Function(List<EquipmentSpecialCapability>) onChanged;

  @override
  State<EquipmentSpecialCapabilitiesEditWidget> createState() => _EquipmentSpecialCapabilitiesEditWidgetState();
}

class _EquipmentSpecialCapabilitiesEditWidgetState extends State<EquipmentSpecialCapabilitiesEditWidget> {
  late List<EquipmentSpecialCapability> special;

  @override
  void initState() {
    super.initState();

    if(widget.special != null) {
      special = List.from(widget.special!);
    }
    else {
      special = <EquipmentSpecialCapability>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var capabilities = <Widget>[];

    if(special.isEmpty) {
      capabilities.add(
        Row(
          children: [
            Expanded(child: Text('Aucun')),
          ],
        )
      );
    }
    else {
      for(var c in special) {
        capabilities.add(
          _SpecialCapabilityEditWidget(
            capability: c,
            onChanged: (EquipmentSpecialCapability c) {
              setState(() {
                widget.onChanged(special);
              });
            },
            onRemoved: (EquipmentSpecialCapability c) {
              setState(() {
                special.remove(c);
                widget.onChanged(special);
              });
            },
          )
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
          'Spécial',
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          ...capabilities,
          IconButton(
            onPressed: () async {
              EquipmentSpecialCapability? c = await showDialog(
                context: context,
                builder: (BuildContext context) => _SpecialCapabilityEditDialog(),
              );
              if(c == null) return;
              setState(() {
                special.add(c);
                widget.onChanged(special);
              });
            },
            icon: const Icon(Icons.add),
            iconSize: 24.0,
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(),
          ),
        ],
      )
    );
  }
}

class _SpecialCapabilityEditWidget extends StatelessWidget {
  const _SpecialCapabilityEditWidget({
    required this.capability,
    required this.onChanged,
    required this.onRemoved,
  });

  final EquipmentSpecialCapability capability;
  final void Function(EquipmentSpecialCapability) onChanged;
  final void Function(EquipmentSpecialCapability) onRemoved;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          spacing: 16.0,
          children: [
            Expanded(
              child: Column(
                spacing: 4.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(capability.title != null)
                    Text(
                      capability.title!,
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  Text(
                    capability.description,
                  ),
                ],
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                iconSize: 24.0,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(),
              onPressed: () async {
                EquipmentSpecialCapability? c = await showDialog(
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
              onPressed: () => onRemoved(capability),
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

  final EquipmentSpecialCapability? source;

  @override
  State<_SpecialCapabilityEditDialog> createState() => _SpecialCapabilityEditDialogState();
}

class _SpecialCapabilityEditDialogState extends State<_SpecialCapabilityEditDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.source != null) {
      titleController.text = widget.source!.title ?? '';
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
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  label: const Text('Titre'),
                  border: const OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: descriptionController,
                minLines: 3,
                maxLines: 3,
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
            EquipmentSpecialCapability capability;

            if(widget.source == null) {
              capability = EquipmentSpecialCapability(
                title: titleController.text.isEmpty
                  ? null
                  : titleController.text,
                description: descriptionController.text,
              );
            }
            else {
              capability = widget.source!;
              capability.title = titleController.text.isEmpty
                ? null
                : titleController.text;
              capability.description = descriptionController.text;
            }

            Navigator.of(context).pop(capability);
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}