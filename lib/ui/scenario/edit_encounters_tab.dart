import 'package:flutter/material.dart';

import '../../classes/scenario_encounter.dart';
import 'encounter_edit.dart';
import '../utils/single_line_input_dialog.dart';

class ScenarioEditEncountersPage extends StatefulWidget {
  ScenarioEditEncountersPage({
    super.key,
    List<ScenarioEncounter>? encounters
  })
    : encounters = encounters ?? <ScenarioEncounter>[];

  final List<ScenarioEncounter> encounters;

  @override
  State<ScenarioEditEncountersPage> createState() => _ScenarioEditEncountersPageState();
}

class _ScenarioEditEncountersPageState extends State<ScenarioEditEncountersPage> {
  final GlobalKey<FormState> _newEncounterNameKey = GlobalKey();
  ScenarioEncounter? _selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget encounterEditWidget;
    if(_selected == null) {
      encounterEditWidget = const Center(child: Text('Selectionner une rencontre'));
    }
    else {
      encounterEditWidget = EncounterEditWidget(
        encounter: _selected!
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () async {
                  var newEncounterName = await showDialog(
                    context: context,
                    builder: (context) => SingleLineInputDialog(
                        title: 'Nouvelle rencontre',
                        formKey: _newEncounterNameKey
                    ),
                  );
                  // User canceled the pop-up dialog
                  if(newEncounterName == null) return;

                  if(!context.mounted) return;
                  var encounter = ScenarioEncounter(name: newEncounterName);
                  setState((){
                    _selected = encounter;
                    widget.encounters.add(encounter);
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Nouvelle rencontre'),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.encounters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      color: _selected == widget.encounters[index] ?
                          theme.colorScheme.surfaceVariant :
                          null,
                      child: InkWell(
                        splashColor: theme.colorScheme.surface,
                        onTap: () {
                          setState(() {
                            _selected = widget.encounters[index];
                          });
                        },
                        child: ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              // TODO: ask confirmation maybe?
                              setState(() {
                                if(_selected == widget.encounters[index]) {
                                  _selected = null;
                                }
                                widget.encounters.removeAt(index);
                              });
                            },
                          ),
                          title: Text(widget.encounters[index].name),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: theme.colorScheme.surfaceVariant,
            child: encounterEditWidget
          ),
        ),
      ],
    );
  }
}