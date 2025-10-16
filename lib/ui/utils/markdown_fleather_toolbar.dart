import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:parchment/codecs.dart';

import '../../classes/creature.dart';
import '../../classes/non_player_character.dart';
import '../../classes/object_location.dart';
import '../../classes/place.dart';
import '../../classes/resource_link.dart';

class MarkdownFleatherToolbarFormField extends FormField<bool> {
  MarkdownFleatherToolbarFormField({
    super.key,
    required this.controller,
    bool showResourcePicker = false,
    Widget Function() openResourceLinkPickerDialog = openBaseResourceLinkPickerDialog,
    void Function(String)? onSaved,
  })
    : super(
        initialValue: false,
        onSaved: (bool? hasChanges) {
          onSaved?.call(
            ParchmentMarkdownCodec().encode(controller.document)
          );
        },
        builder: (FormFieldState<bool> s) {
          return MarkdownFleatherToolbar(
            controller: controller,
            showResourcePicker: showResourcePicker,
            openResourceLinkPickerDialog: openResourceLinkPickerDialog,
          );
        }
    );

  final FleatherController controller;
}

class MarkdownFleatherToolbar extends StatefulWidget {
  const MarkdownFleatherToolbar({
    super.key,
    required this.controller,
    this.showResourcePicker = false,
    this.openResourceLinkPickerDialog = openBaseResourceLinkPickerDialog,
    this.onSaved,
  });

  final FleatherController controller;
  final bool showResourcePicker;
  final Widget Function() openResourceLinkPickerDialog;
  final void Function(String)? onSaved;

  @override
  State<MarkdownFleatherToolbar> createState() => _MarkdownFleatherToolbarState();
}

class _MarkdownFleatherToolbarState extends State<MarkdownFleatherToolbar> {
  bool hasPendingChanges = false;

  @override
  void initState() {
    super.initState();

    widget.controller.document.changes.listen((ParchmentChange c) {
      setState(() {
        hasPendingChanges = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var trailing = <Widget>[];

    if(widget.showResourcePicker) {
      trailing.addAll([
        VerticalDivider(
          indent: 16,
          endIndent: 16,
        ),
        FLIconButton(
          onPressed: () async {
            var result = await showDialog<ResourceLink>(
              context: context,
              builder: (BuildContext context) => widget.openResourceLinkPickerDialog(),
            );
            if(result == null) return;

            widget.controller.replaceText(
              widget.controller.selection.baseOffset,
              0,
              result.name
            );
            widget.controller.updateSelection(
              TextSelection(
                baseOffset: widget.controller.selection.baseOffset,
                extentOffset: widget.controller.selection.baseOffset + result.name.length,
              )
            );
            widget.controller.formatSelection(
              ParchmentAttribute.link.fromString(result.link),
            );
            widget.controller.updateSelection(
              TextSelection(
                baseOffset: widget.controller.selection.baseOffset + result.name.length,
                extentOffset: widget.controller.selection.baseOffset + result.name.length,
              )
            );
          },
          size: 32,
          icon: Icon(
            Icons.book_outlined,
            size: 20,
          ),
        ),
      ]);
    }

    trailing.addAll([
      VerticalDivider(
        indent: 16,
        endIndent: 16,
      ),
      FLIconButton(
        onPressed: !hasPendingChanges ? null : () {
          widget.onSaved?.call(
            ParchmentMarkdownCodec().encode(widget.controller.document)
          );
          setState(() {
            hasPendingChanges = false;
          });
        },
        size: 32,
        icon: Icon(
          Icons.check_circle_rounded,
          size: 20,
          color: hasPendingChanges ? theme.iconTheme.color : theme.disabledColor,
        ),
      ),
    ]);

    return Container(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: FleatherToolbar.basic(
        controller: widget.controller,
        hideUnderLineButton: true, // Not supported by markdown
        hideForegroundColor: true, // Not supported by markdown
        hideBackgroundColor: true, // Not supported by markdown
        hideDirection: true,
        hideAlignment: true, // Not supported by markdown
        hideIndentation: true, // No-op for markdown
        hideHorizontalRule: true,
        trailing: trailing,
      ),
    );
  }
}

Widget openBaseResourceLinkPickerDialog() {
  return ResourceLinkPickerDialog();
}

class ResourceLinkPickerDialog extends StatefulWidget {
  const ResourceLinkPickerDialog({
    super.key,
    this.localResourcesLinkGenerator,
  });

  final Future<List<ResourceLink>> Function(ResourceLinkType)? localResourcesLinkGenerator;

  @override
  State<ResourceLinkPickerDialog> createState() => _ResourceLinkPickerDialogState();
}

class _ResourceLinkPickerDialogState extends State<ResourceLinkPickerDialog> {
  TextEditingController selectionController = TextEditingController();

  List<DropdownMenuEntry<ResourceLinkType>> availableResourceLinkTypes = <DropdownMenuEntry<ResourceLinkType>>[];
  ResourceLinkType? type;
  late bool useLocalResources;
  bool nonLocalResourcesSelectable = true;
  List<ResourceLink> links = <ResourceLink>[];
  ResourceLink? selected;

  @override
  void initState() {
    super.initState();

    for(var t in ResourceLinkType.values) {
      if(widget.localResourcesLinkGenerator == null && (t == ResourceLinkType.encounter || t == ResourceLinkType.map)) {
        continue;
      }
      availableResourceLinkTypes.add(
        DropdownMenuEntry(value: t, label: t.title)
      );
    }

    if(widget.localResourcesLinkGenerator == null) {
      useLocalResources = false;
    }
    else {
      useLocalResources = true;
    }
  }

  Future<void> refreshLinks() async {
    links.clear();
    if(type == null) return;

    if(widget.localResourcesLinkGenerator != null && useLocalResources) {
      links.addAll(await widget.localResourcesLinkGenerator!(type!));
    }
    else {
      switch(type!) {
        case ResourceLinkType.npc:
          for(var npc in await NonPlayerCharacterSummary.forLocationType(ObjectLocationType.assets, null, null)) {
            links.add(ResourceLink.createLinkForResource(type!, useLocalResources, npc.name, npc.id));
          }
        case ResourceLinkType.creature:
          for(var creature in await CreatureSummary.forLocationType(ObjectLocationType.assets, null)) {
            links.add(ResourceLink.createLinkForResource(type!, useLocalResources, creature.name, creature.id));
          }
        case ResourceLinkType.place:
          for(var place in await PlaceSummary.forLocationType(ObjectLocationType.assets)) {
            links.add(ResourceLink.createLinkForResource(type!, useLocalResources, place.name, place.id));
          }
        case ResourceLinkType.encounter:
        case ResourceLinkType.map:
          break;
      }
    }

    setState(() {
      // no-op
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélection de la ressource'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownMenu(
                    initialSelection: type,
                    label: const Text('Type'),
                    expandedInsets: EdgeInsets.zero,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      constraints: BoxConstraints(maxHeight: 36.0),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    textStyle: theme.textTheme.bodyMedium,
                    dropdownMenuEntries: availableResourceLinkTypes,
                    onSelected: (ResourceLinkType? t) {
                      if(t == null) return;
                      setState(() {
                        if(t == ResourceLinkType.encounter || t == ResourceLinkType.map) {
                          useLocalResources = true;
                          nonLocalResourcesSelectable = false;
                        }
                        else {
                          nonLocalResourcesSelectable = true;
                        }
                        type = t;
                        selectionController.clear();
                        selected = null;
                      });
                      refreshLinks();
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Text(
                    useLocalResources
                        ? 'des ressources locales'
                        : 'des ressources de base'
                ),
                const SizedBox(width: 12.0),
                Switch(
                  value: useLocalResources,
                  onChanged: (widget.localResourcesLinkGenerator != null && !nonLocalResourcesSelectable)
                    ? null
                    : (bool value) {
                      setState(() {
                        useLocalResources = value;
                        selectionController.clear();
                        selected = null;
                      });
                      refreshLinks();
                    },
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            DropdownMenu(
              enabled: type != null,
              controller: selectionController,
              label: Text(type == null ? 'Ressource' : type!.title),
              expandedInsets: EdgeInsets.zero,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isCollapsed: true,
                constraints: BoxConstraints(maxHeight: 36.0),
                contentPadding: EdgeInsets.all(12.0),
              ),
              textStyle: theme.textTheme.bodyMedium,
              dropdownMenuEntries: links
                  .map((ResourceLink l) => DropdownMenuEntry(value: l, label: l.name))
                  .toList(),
              onSelected: (ResourceLink? l) {
                if(l == null) return;
                setState(() {
                  selected = l;
                });
                refreshLinks();
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: selected == null ? null : () {
                      Navigator.of(context).pop(selected);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}