import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parchment/codecs.dart';

import '../../../classes/character_role.dart';
import '../../../classes/faction.dart';
import '../../../classes/object_source.dart';
import '../../../classes/resource_link/assets_resource_link_provider.dart';
import '../../../classes/resource_link/multi_resource_link_provider.dart';
import '../../../classes/resource_link/resource_link.dart';
import '../../../classes/resource_link/sourced_resource_link_provider.dart';
import '../character_role_edit_widget.dart';
import '../markdown_fleather_field.dart';
import '../markdown_fleather_toolbar.dart';

class FactionEditDialog extends StatefulWidget {
  const FactionEditDialog({
    super.key,
    this.faction,
    this.parentId,
    this.source,
    this.resourceLinkProvider,
  });

  final Faction? faction;
  final String? parentId;
  final ObjectSource? source;
  final ResourceLinkProvider? resourceLinkProvider;

  @override
  State<FactionEditDialog> createState() => _FactionEditDialogState();
}

class _FactionEditDialogState extends State<FactionEditDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  bool displayOnly = false;
  late final FleatherController descriptionController;
  late final FocusNode descriptionFocusNode;

  late List<CharacterRole> currentLeaders;
  late List<CharacterRole> currentMembers;

  @override
  void initState() {
    super.initState();

    if(kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }

    descriptionFocusNode = FocusNode();
    ParchmentDocument document;

    if(widget.faction != null) {
      nameController.text = widget.faction!.name;
      document = ParchmentMarkdownCodec().decode(widget.faction!.description);
      currentLeaders = widget.faction!.leaders;
      currentMembers = widget.faction!.members;
    }
    else {
      document = ParchmentDocument();
      currentLeaders = <CharacterRole>[];
      currentMembers = <CharacterRole>[];
    }

    descriptionController = FleatherController(document: document);
  }

  @override
  void dispose() {
    if(kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    ResourceLinkProvider? effectiveResourceLinkProvider = widget.resourceLinkProvider;
    effectiveResourceLinkProvider ??= MultiResourceLinkProvider(
        providers: [
          AssetsResourceLinkProvider(),
          SourcedResourceLinkProvider(source: ObjectSource.local),
        ]
      );

    return AlertDialog(
      title: Text('Éditer la faction'),
      content: SizedBox(
        width: 800,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Nom de la faction",
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if(value == null || value.isEmpty) {
                          return 'Valeur obligatoire';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Switch(
                    value: displayOnly,
                    onChanged: (bool value) {
                      setState(() {
                        displayOnly = value;
                      });
                    },
                  ),
                  const SizedBox(width: 12.0),
                  const Text("Niveau d'organisation")
                ],
              ),
              Divider(),
              CharacterRoleListEditWidget(
                title: 'Dirigeants',
                members: currentLeaders,
                resourceLinkProvider: effectiveResourceLinkProvider,
                onAdd: (CharacterRole m) {
                  setState(() {
                    currentLeaders.add(m);
                  });
                },
                onDelete: (CharacterRole m) {
                  setState(() {
                    currentLeaders.remove(m);
                  });
                }
              ),
              const SizedBox(height: 12.0),
              CharacterRoleListEditWidget(
                  title: 'Membres',
                  members: currentMembers,
                  resourceLinkProvider: effectiveResourceLinkProvider,
                  onAdd: (CharacterRole m) {
                    setState(() {
                      currentMembers.add(m);
                    });
                  },
                  onDelete: (CharacterRole m) {
                    setState(() {
                      currentMembers.remove(m);
                    });
                  }
              ),
              Divider(),
              Center(
                child: MarkdownFleatherToolbar(
                  controller: descriptionController,
                  showResourcePicker: true,
                  localResourceLinkProvider: SourcedResourceLinkProvider(source: ObjectSource.local),
                )
              ),
              Expanded(
                child: MarkdownFleatherField(
                  controller: descriptionController,
                  focusNode: descriptionFocusNode,
                  expands: true,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
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
                      onPressed: () async {
                        if(!formKey.currentState!.validate()) return;

                        Faction f;
                        if(widget.faction != null) {
                          f = widget.faction!;
                          f.name = nameController.text;
                        }
                        else {
                          f = Faction(
                            parentId: widget.parentId,
                            name: nameController.text,
                            source: widget.source ?? ObjectSource.local,
                            description: "",
                          );
                        }

                        f.displayOnly = displayOnly;
                        f.leaders = currentLeaders;
                        f.members = currentMembers;
                        f.description = ParchmentMarkdownCodec().encode(descriptionController.document);

                        Navigator.of(context).pop(f);
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
      )
    );
  }
}