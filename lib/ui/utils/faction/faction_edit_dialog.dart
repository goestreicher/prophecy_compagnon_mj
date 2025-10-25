import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parchment/codecs.dart';

import '../../../classes/faction.dart';
import '../../../classes/object_source.dart';
import '../markdown_fleather_toolbar.dart';

class FactionEditDialog extends StatefulWidget {
  const FactionEditDialog({
    super.key,
    this.faction,
    this.parentId,
    this.source,
  });

  final Faction? faction;
  final String? parentId;
  final ObjectSource? source;

  @override
  State<FactionEditDialog> createState() => _FactionEditDialogState();
}

class _FactionEditDialogState extends State<FactionEditDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  bool displayOnly = false;
  late final FleatherController descriptionController;
  late final FocusNode descriptionFocusNode;

  late List<FactionMember> currentLeaders;
  late List<FactionMember> currentMembers;

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
      currentLeaders = <FactionMember>[];
      currentMembers = <FactionMember>[];
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
              _FactionMemberListEditWidget(
                title: 'Dirigeants',
                members: currentLeaders,
                onAdd: (FactionMember m) {
                  setState(() {
                    currentLeaders.add(m);
                  });
                },
                onDelete: (FactionMember m) {
                  setState(() {
                    currentLeaders.remove(m);
                  });
                }
              ),
              const SizedBox(height: 12.0),
              _FactionMemberListEditWidget(
                  title: 'Membres',
                  members: currentMembers,
                  onAdd: (FactionMember m) {
                    setState(() {
                      currentMembers.add(m);
                    });
                  },
                  onDelete: (FactionMember m) {
                    setState(() {
                      currentMembers.remove(m);
                    });
                  }
              ),
              Divider(),
              Center(child: MarkdownFleatherToolbar(controller: descriptionController)),
              Expanded(
                child: FleatherField(
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

class _FactionMemberListEditWidget extends StatelessWidget {
  const _FactionMemberListEditWidget({
    required this.title,
    required this.members,
    required this.onAdd,
    required this.onDelete,
  });

  final String title;
  final List<FactionMember> members;
  final Function(FactionMember) onAdd;
  final Function(FactionMember) onDelete;

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
              child: _FactionMemberDisplayPill(
                member: member,
                onDelete: () => onDelete(member),
              ),
            ),
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
                var member = await showDialog<FactionMember>(
                  context: context,
                  builder: (BuildContext context) => _FactionMemberInputDialog(),
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

class _FactionMemberDisplayPill extends StatelessWidget {
  const _FactionMemberDisplayPill({
    required this.member,
    required this.onDelete,
  });

  final FactionMember member;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 2.0),
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${member.name}, ${member.title}',
            style: theme.textTheme.bodySmall,
          ),
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

class _FactionMemberInputDialog extends StatefulWidget {
  const _FactionMemberInputDialog();

  @override
  State<_FactionMemberInputDialog> createState() => _FactionMemberInputDialogState();
}

class _FactionMemberInputDialogState extends State<_FactionMemberInputDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  void onFormSubmitted(BuildContext context) {
    if(!formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
        FactionMember(
            name: nameController.text,
            title: titleController.text
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Nouveau membre"),
      content: SizedBox(
        width: 400,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                onFieldSubmitted: (String? v) => onFormSubmitted(context),
              ),
              const SizedBox(height: 16.0),
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
                onFieldSubmitted: (String? v) => onFormSubmitted(context),
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
                      onPressed: () => onFormSubmitted(context),
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
      ),
    );
  }
}