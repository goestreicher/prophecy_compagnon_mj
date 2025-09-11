import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/object_source.dart';
import '../utils/creature/create_dialog.dart';
import '../utils/creature/edit_widget.dart';
import '../utils/creature/list_widget.dart';

class ScenarioEditCreaturesPage extends StatefulWidget {
  const ScenarioEditCreaturesPage({
    super.key,
    required this.creatures,
    required this.scenarioSource,
    required this.onCreatureCreated,
    required this.onCreatureModified,
    required this.onCreatureDeleted,
    this.onEditStarted,
    this.onEditFinished,
  });

  final List<CreatureModel> creatures;
  final ObjectSource scenarioSource;
  final void Function(CreatureModel) onCreatureCreated;
  final void Function(CreatureModel) onCreatureModified;
  final void Function(CreatureModel) onCreatureDeleted;
  final void Function()? onEditStarted;
  final void Function()? onEditFinished;

  @override
  State<ScenarioEditCreaturesPage> createState() => _ScenarioEditCreaturesPageState();
}

class _ScenarioEditCreaturesPageState extends State<ScenarioEditCreaturesPage> {
  late List<CreatureModelSummary> creatureSummaries;
  CreatureModel? selectedModel;
  bool editing = false;
  bool creatingNewCreature = false;

  void _startEditing(CreatureModel model) {
    widget.onEditStarted?.call();

    setState(() {
      selectedModel = model;
      editing = true;
    });
  }

  @override
  void initState() {
    super.initState();
    creatureSummaries = [for(var c in widget.creatures) c.summary]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;
    if(editing == true && selectedModel != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: CreatureEditWidget(
          creature: selectedModel!,
          onEditDone: (bool result) async {
            if(result) {
              var summaryIndex = creatureSummaries.indexWhere((CreatureModelSummary s) => s.id == selectedModel!.id);
              if(summaryIndex == -1) {
                creatureSummaries.add(selectedModel!.summary);
                widget.creatures.add(selectedModel!);
              }
              else {
                creatureSummaries[summaryIndex] = selectedModel!.summary;
              }

              if(creatingNewCreature) {
                widget.onCreatureCreated(selectedModel!);
              }
              else {
                widget.onCreatureModified(selectedModel!);
              }
            }
            else {
              if(creatingNewCreature) {
                CreatureModel.removeFromCache(selectedModel!.id);
              }
              else {
                await CreatureModel.reloadFromStore(selectedModel!.id);
              }
            }

            widget.onEditFinished?.call();
            setState(() {
              creatingNewCreature = false;
              editing = false;
            });
          },
        ),
      );
    }
    else {
      mainArea = Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                var creature = await showDialog<CreatureModel>(
                  context: context,
                  builder: (BuildContext context) => CreatureCreateDialog(
                    source: ObjectSource.local,
                  ),
                );
                if(!context.mounted) return;
                if(creature == null) return;

                creatingNewCreature = true;
                _startEditing(creature);
              },
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle créature'),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: CreaturesListWidget(
                creatures: creatureSummaries,
                initialSelection: selectedModel?.id,
                onEditRequested: (String id) async {
                  var model = widget.creatures.firstWhere(
                      (CreatureModel c) => c.id == id
                  );

                  creatingNewCreature = false;
                  _startEditing(model);
                },
                onCloneRequested: (String id) async {
                  var model = widget.creatures.firstWhere(
                      (CreatureModel c) => c.id == id
                  );

                  var clone = await showDialog<CreatureModel>(
                    context: context,
                    builder: (BuildContext context) => CreatureCreateDialog(
                      source: widget.scenarioSource,
                      cloneFrom: model,
                    ),
                  );
                  if(!context.mounted) return;
                  if(clone == null) return;

                  creatingNewCreature = true;
                  _startEditing(clone);
                },
                onDeleteRequested: (String id) async {
                  var index = widget.creatures.indexWhere(
                      (CreatureModel c) => c.id == id
                  );
                  var summaryIndex = creatureSummaries.indexWhere(
                      (CreatureModelSummary c) => c.id == id
                  );

                  setState(() {
                    creatureSummaries.removeAt(summaryIndex);
                    if(selectedModel?.id == id) selectedModel = null;
                    widget.onCreatureDeleted(widget.creatures[index]);
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    return mainArea;
  }
}