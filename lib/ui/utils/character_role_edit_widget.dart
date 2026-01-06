import 'package:flutter/material.dart';

import '../../classes/character_role.dart';
import '../../classes/resource_link/resource_link.dart';
import 'character_role_display_widget.dart';
import 'resource_link_edit_widget.dart';

class CharacterRoleEditWidget extends StatefulWidget {
  const CharacterRoleEditWidget({
    super.key,
    required this.onChanged,
    this.resourceLinkProvider,
  });

  final void Function(CharacterRole?) onChanged;
  final ResourceLinkProvider? resourceLinkProvider;

  @override
  State<CharacterRoleEditWidget> createState() => _CharacterRoleEditWidgetState();
}

class _CharacterRoleEditWidgetState extends State<CharacterRoleEditWidget> {
  bool useResourceLink = false;
  final TextEditingController nameController = TextEditingController();
  ResourceLink? link;
  final TextEditingController titleController = TextEditingController();
  CharacterRole? currentRole;

  void updateCharacterRole() {
    bool notify = false;

    if(nameController.text.isEmpty && link == null) {
      notify = currentRole != null;
      currentRole = null;
    }
    else if(titleController.text.isEmpty) {
      notify = currentRole != null;
      currentRole = null;
    }
    else {
      notify = true;
      currentRole = CharacterRole(
        name: nameController.text.isNotEmpty ? nameController.text : null,
        link: link,
        title: titleController.text,
      );
    }

    if(notify) widget.onChanged(currentRole);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16.0,
      children: [
        Row(
          spacing: 12.0,
          children: [
            Switch(
              value: useResourceLink,
              onChanged: (bool value) {
                setState(() {
                  link = null;
                  nameController.clear();
                  useResourceLink = value;
                });
                updateCharacterRole();
              },
            ),
            Text('Utiliser un personnage existant'),
          ],
        ),
        if(!useResourceLink)
          TextFormField(
            autofocus: true,
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nom",
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return 'Valeur obligatoire';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (String? v) => updateCharacterRole(),
            onFieldSubmitted: (String? v) => updateCharacterRole(),
          ),
        if(useResourceLink)
          ResourceLinkEditWidget(
            restrictToTypes: (widget.resourceLinkProvider?.availableTypes() ?? [ResourceLinkType.npc, ResourceLinkType.pc])
              .where((ResourceLinkType t) => [ResourceLinkType.npc, ResourceLinkType.pc].contains(t))
              .toList(),
            provider: widget.resourceLinkProvider,
            onChanged: (ResourceLink? l) {
              link = l;
              updateCharacterRole();
            },
          ),
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: "Titre",
            border: OutlineInputBorder(),
          ),
          validator: (String? value) {
            if(value == null || value.isEmpty) {
              return 'Valeur obligatoire';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (String? v) => updateCharacterRole(),
          onFieldSubmitted: (String? v) => updateCharacterRole(),
        ),
      ],
    );
  }
}

class CharacterRoleListEditWidget extends StatelessWidget {
  const CharacterRoleListEditWidget({
    super.key,
    required this.title,
    required this.members,
    required this.onAdd,
    required this.onDelete,
    this.resourceLinkProvider,
    this.maxCount = 0,
  });

  final String title;
  final List<CharacterRole> members;
  final Function(CharacterRole) onAdd;
  final Function(CharacterRole) onDelete;
  final ResourceLinkProvider? resourceLinkProvider;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Text.rich(
      TextSpan(
        style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        text: '$title : ',
        children: [
          for(var member in members)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _CharacterRoleDisplayPill(
                member: member,
                onDelete: () => onDelete(member),
              ),
            ),
          if(maxCount == 0 || members.length <= maxCount)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: IconButton(
                icon: const Icon(Icons.add),
                iconSize: 20,
                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                constraints: const BoxConstraints(),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                ),
                onPressed: () async {
                  var member = await showDialog<CharacterRole>(
                    context: context,
                    builder: (BuildContext context) => _CharacterRoleInputDialog(
                      resourceLinkProvider: resourceLinkProvider,
                    ),
                  );
                  if(member == null) return;
                  onAdd(member);
                },
              )
            )
        ]
      )
    );
  }
}

class _CharacterRoleDisplayPill extends StatelessWidget {
  const _CharacterRoleDisplayPill({
    required this.member,
    required this.onDelete,
  });

  final CharacterRole member;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 2.0),
      margin: const EdgeInsets.fromLTRB(0.0, 4.0, 12.0, 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CharacterRoleDisplayWidget(member: member),
          IconButton(
            icon: const Icon(Icons.cancel_outlined),
            iconSize: 20,
            padding: const EdgeInsets.all(2.0),
            constraints: const BoxConstraints(),
            onPressed: () => onDelete(),
          )
        ],
      )
    );
  }
}

class _CharacterRoleInputDialog extends StatefulWidget {
  const _CharacterRoleInputDialog({ this.resourceLinkProvider });

  final ResourceLinkProvider? resourceLinkProvider;

  @override
  State<_CharacterRoleInputDialog> createState() => _CharacterRoleInputDialogState();
}

class _CharacterRoleInputDialogState extends State<_CharacterRoleInputDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CharacterRole? role;

  void onFormSubmitted(BuildContext context) {
    if(!formKey.currentState!.validate()) return;

    Navigator.of(context).pop(role);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Ajouter un personnage"),
      content: SizedBox(
        width: 400,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,
            children: [
              CharacterRoleEditWidget(
                resourceLinkProvider: widget.resourceLinkProvider,
                onChanged: (CharacterRole? r) {
                  role = r;
                },
              ),
              Row(
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
                    onPressed: () => onFormSubmitted(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  )
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}