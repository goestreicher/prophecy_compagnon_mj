import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/non_player_character.dart';
import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../../classes/place.dart';
import '../../classes/resource_link.dart';
import '../../classes/scenario.dart';

class ScenarioFleatherToolbar extends StatelessWidget {
  const ScenarioFleatherToolbar({
    super.key,
    required this.controller,
    required this.scenario,
  });

  final FleatherController controller;
  final Scenario scenario;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: FleatherToolbar.basic(
        controller: controller,
        hideUnderLineButton: true, // Not supported by markdown
        hideForegroundColor: true, // Not supported by markdown
        hideBackgroundColor: true, // Not supported by markdown
        hideDirection: true,
        hideAlignment: true, // Not supported by markdown
        hideIndentation: true, // No-op for markdown
        hideHorizontalRule: true, // No-op for markdown
        trailing: [
          VerticalDivider(
            indent: 16,
            endIndent: 16,
          ),
          FLIconButton(
            onPressed: () async {
              var result = await showDialog<ResourceLink>(
                context: context,
                builder: (BuildContext context) => ScenarioResourceLinkDialog(
                  scenario: scenario,
                ),
              );
              if(result == null) return;

              controller.replaceText(
                  controller.selection.baseOffset,
                  0,
                  result.name
              );
              controller.updateSelection(
                  TextSelection(
                    baseOffset: controller.selection.baseOffset,
                    extentOffset: controller.selection.baseOffset + result.name.length,
                  )
              );
              controller.formatSelection(
                ParchmentAttribute.link.fromString(result.link),
              );
              controller.updateSelection(
                  TextSelection(
                    baseOffset: controller.selection.baseOffset + result.name.length,
                    extentOffset: controller.selection.baseOffset + result.name.length,
                  )
              );
            },
            size: 32,
            icon: Icon(
              Icons.book_outlined,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ScenarioResourceLinkDialog extends StatefulWidget {
  const ScenarioResourceLinkDialog({
    super.key,
    required this.scenario,
  });

  final Scenario scenario;

  @override
  State<ScenarioResourceLinkDialog> createState() => _ScenarioResourceLinkDialogState();
}

class _ScenarioResourceLinkDialogState extends State<ScenarioResourceLinkDialog> {
  TextEditingController selectionController = TextEditingController();

  late ObjectSource scenarioSource;
  ResourceLinkType? type;
  bool useScenarioResources = true;
  bool nonScenarioResourcesSelectable = true;
  List<ResourceLink> links = <ResourceLink>[];
  ResourceLink? selected;

  void refreshLinks() {
    links.clear();
    if(type != null) {
      switch(type!) {
        case ResourceLinkType.npc:
          var npcs = useScenarioResources
              ? NonPlayerCharacterSummary.forSource(scenarioSource, null, null)
              : NonPlayerCharacterSummary.forLocationType(ObjectLocationType.assets, null, null);
          for(var npc in npcs) {
            links.add(ResourceLink.createLinkForResource(type!, useScenarioResources, npc.name, npc.id));
          }
        case ResourceLinkType.creature:
          var creatures = useScenarioResources
              ? CreatureModelSummary.forSource(scenarioSource, null)
              : CreatureModelSummary.forLocationType(ObjectLocationType.assets, null);
          for(var creature in creatures) {
            links.add(ResourceLink.createLinkForResource(type!, useScenarioResources, creature.name, creature.id));
          }
        case ResourceLinkType.place:
          var places = useScenarioResources
              ? Place.forSource(scenarioSource)
              : Place.forLocationType(ObjectLocationType.assets);
          for(var place in places) {
            links.add(ResourceLink.createLinkForResource(type!, useScenarioResources, place.name, place.id));
          }
        case ResourceLinkType.encounter:
          for(var encounter in widget.scenario.encounters) {
            links.add(ResourceLink.createLinkForResource(type!, useScenarioResources, encounter.name, encounter.name));
          }
        case ResourceLinkType.map:
          for(var map in widget.scenario.maps) {
            links.add(ResourceLink.createLinkForResource(type!, useScenarioResources, map.name, map.uuid));
          }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    scenarioSource = ObjectSource(type: ObjectSourceType.scenario, name: widget.scenario.name);
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
                    dropdownMenuEntries: ResourceLinkType.values
                        .map((ResourceLinkType t) => DropdownMenuEntry(value: t, label: t.title))
                        .toList(),
                    onSelected: (ResourceLinkType? t) {
                      if(t == null) return;
                      setState(() {
                        if(t == ResourceLinkType.encounter || t == ResourceLinkType.map) {
                          useScenarioResources = true;
                          nonScenarioResourcesSelectable = false;
                        }
                        else {
                          nonScenarioResourcesSelectable = true;
                        }
                        type = t;
                        selectionController.clear();
                        selected = null;
                        refreshLinks();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Text(
                    useScenarioResources
                        ? 'de ce scénario'
                        : 'des ressources de base'
                ),
                const SizedBox(width: 12.0),
                Switch(
                  value: useScenarioResources,
                  onChanged: !nonScenarioResourcesSelectable ? null : (bool value) {
                    setState(() {
                      useScenarioResources = value;
                      selectionController.clear();
                      selected = null;
                      refreshLinks();
                    });
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
                  refreshLinks();
                });
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