import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/scenario.dart';

class ScenarioEventEditResult {
  final ScenarioEventDayRange dayRange;
  final ScenarioEvent event;

  const ScenarioEventEditResult({ required this.dayRange, required this.event });
}

class ScenarioEventEditDialog extends StatefulWidget {
  const ScenarioEventEditDialog({ super.key, this.dayRange, this.event });

  final ScenarioEventDayRange? dayRange;
  final ScenarioEvent? event;

  @override
  State<ScenarioEventEditDialog> createState() => _ScenarioEventEditDialogState();
}

class _ScenarioEventEditDialogState extends State<ScenarioEventEditDialog> {
  final TextEditingController dayStartController = TextEditingController();
  final TextEditingController dayEndController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    if(widget.dayRange != null && widget.event != null) {
      dayStartController.text = widget.dayRange!.start.toString();
      dayEndController.text = widget.dayRange!.end.toString();
      titleController.text = widget.event!.title;
      descriptionController.text = widget.event!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
        title: const Text('Éditer un événement'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Focus(
                      onFocusChange: (bool hasFocus) {
                        if(dayEndController.text.isEmpty) {
                          dayEndController.text = dayStartController.text;
                        }
                      },
                      child: TextFormField(
                        enabled: widget.dayRange == null,
                        controller: dayStartController,
                        autofocus: widget.event == null ? true : false,
                        decoration: const InputDecoration(
                          labelText: "Premier jour",
                          border: OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[-\d]+')),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if(value == null || value.isEmpty) {
                            return 'Valeur obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: widget.dayRange == null,
                      controller: dayEndController,
                      decoration: const InputDecoration(
                        labelText: "Dernier jour",
                        border: OutlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[-\d]+')),
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if(value == null || value.isEmpty) {
                          return 'Valeur obligatoire';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Titre de l'événement",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return 'Valeur obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: descriptionController,
                autofocus: widget.event != null ? true : false,
                minLines: 8,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return 'Valeur obligatoire';
                  }
                  return null;
                },
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
                        onPressed: () {
                          ScenarioEvent event;
                          if(widget.event != null) {
                            event = widget.event!;
                            event.title = titleController.text;
                            event.description = descriptionController.text;
                          }
                          else {
                            event = ScenarioEvent(
                                title: titleController.text,
                                description: descriptionController.text
                            );
                          }
                          Navigator.of(context).pop(ScenarioEventEditResult(
                            dayRange: ScenarioEventDayRange(
                              start: int.parse(dayStartController.text),
                              end: int.parse(dayEndController.text),
                            ),
                            event: event,
                          ));
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