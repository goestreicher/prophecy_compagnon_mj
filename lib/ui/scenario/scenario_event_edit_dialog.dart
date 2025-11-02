import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parchment/codecs.dart';

import '../../classes/calendar.dart';
import '../../classes/resource_link/scenario_resource_link_provider.dart';
import '../../classes/scenario.dart';
import '../../classes/scenario_event.dart';
import '../utils/markdown_fleather_toolbar.dart';

class ScenarioEventEditResult {
  final DayRange dayRange;
  final ScenarioEvent event;

  const ScenarioEventEditResult({ required this.dayRange, required this.event });
}

class ScenarioEventEditDialog extends StatefulWidget {
  const ScenarioEventEditDialog({
    super.key,
    required this.scenario,
    this.dayRange,
    this.event
  });

  final Scenario scenario;
  final DayRange? dayRange;
  final ScenarioEvent? event;

  @override
  State<ScenarioEventEditDialog> createState() => _ScenarioEventEditDialogState();
}

class _ScenarioEventEditDialogState extends State<ScenarioEventEditDialog> {
  late _EventTimeLocation timeLocation;
  late DayRange? currentDayRange;
  final TextEditingController titleController = TextEditingController();
  late final FleatherController descriptionController;
  late final FocusNode descriptionFocusNode;
  
  @override
  void initState() {
    super.initState();

    if(kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }

    descriptionFocusNode = FocusNode();
    ParchmentDocument document;

    currentDayRange = widget.dayRange;
    
    if(widget.dayRange != null && widget.event != null) {
      timeLocation = widget.dayRange!.start < 0
        ? _EventTimeLocation.beforeStart
        : _EventTimeLocation.afterStart;
      titleController.text = widget.event!.title;
      document = ParchmentMarkdownCodec().decode(widget.event!.description);
    }
    else {
      timeLocation = _EventTimeLocation.afterStart;
      document = ParchmentDocument();
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
        title: const Text('Éditer un événement'),
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        content: SizedBox(
          width: 800,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Divider(),
              const SizedBox(height: 8.0),
              _DayRangeSelectionWidget(
                dayRange: widget.dayRange,
                onChanged: (DayRange? range) {
                  setState(() {
                    currentDayRange = range;
                  });
                }
              ),
              Divider(),
              MarkdownFleatherToolbar(
                controller: descriptionController,
                showResourcePicker: true,
                localResourceLinkProvider: ScenarioResourceLinkProvider(
                  source: widget.scenario.source,
                ),
              ),
              Expanded(
                child: FleatherField(
                  controller: descriptionController,
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
                        onPressed: currentDayRange == null
                          ? null
                          : () {
                            if(currentDayRange == null) return;

                            ScenarioEvent event;
                            if(widget.event != null) {
                              event = widget.event!;
                              event.title = titleController.text;
                              event.description = ParchmentMarkdownCodec().encode(descriptionController.document);
                              event.refreshResourceLinks();
                            }
                            else {
                              event = ScenarioEvent(
                                  title: titleController.text,
                                  description: ParchmentMarkdownCodec().encode(descriptionController.document)
                              );
                            }
                            Navigator.of(context).pop(ScenarioEventEditResult(
                              dayRange: currentDayRange!,
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

enum _EventTimeLocation {
  beforeStart,
  afterStart
}

class _DayRangeSelectionWidget extends StatefulWidget {
  const _DayRangeSelectionWidget({
    this.dayRange,
    required this.onChanged,
  });

  final DayRange? dayRange;
  final ValueChanged<DayRange?> onChanged;

  @override
  State<_DayRangeSelectionWidget> createState() => _DayRangeSelectionWidgetState();
}

class _DayRangeSelectionWidgetState extends State<_DayRangeSelectionWidget> {
  KorDuration duration = KorDuration.day;
  int? currentStartCount;
  int? currentEndCount;
  bool endSet = false;

  void dayRangeChanged() {
    if(currentStartCount == null) {
      widget.onChanged(null);
    }
    else {
      if(!endSet) {
        currentEndCount = currentStartCount;
      }
      else {
        currentEndCount ??= currentStartCount!;

        if(currentStartCount! > currentEndCount!) {
          currentEndCount = currentStartCount! + 1;
        }
      }

      var start = currentStartCount! * duration.daysLength;
      var end = currentEndCount! * duration.daysLength;

      if(duration != KorDuration.day && start != end) {
        end -= 1;
      }

      widget.onChanged(DayRange(start: start, end: end));
    }
  }

  @override
  void initState() {
    super.initState();

    if(widget.dayRange != null) {
      duration = KorDuration.bestFitForRange(widget.dayRange!);
      currentStartCount = widget.dayRange!.start ~/ duration.daysLength;
      currentEndCount = widget.dayRange!.end ~/ duration.daysLength;
      endSet = currentStartCount != currentEndCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 96.0,
              child: Text("Début : ")
            ),
            const SizedBox(width: 12.0),
            _DayRangeLimitInputWidget(
              count: currentStartCount,
              duration: duration,
              onCountChanged: (int? newStart) {
                setState(() {
                  currentStartCount = newStart;
                  dayRangeChanged();
                });
              },
              onDurationChanged: (KorDuration d) => setState(() {
                duration = d;
                dayRangeChanged();
              }),
            ),
            const SizedBox(width: 16.0),
            Switch(
              value: endSet,
              onChanged: (bool value) => setState(() {
                endSet = value;
                if(currentStartCount != null) {
                  currentEndCount = currentStartCount! + 1;
                }
                dayRangeChanged();
              }),
            ),
            const SizedBox(width: 12.0),
            Text("Dure plusieurs ${duration.title.toLowerCase()}s")
          ],
        ),
        if(endSet)
          const SizedBox(height: 12.0),
        if(endSet)
          Row(
            children: [
              const SizedBox(
                  width: 96.0,
                  child: Text("Fin : ")
              ),
              const SizedBox(width: 12.0),
              _DayRangeLimitInputWidget(
                count: currentEndCount,
                duration: duration,
                onCountChanged: (int? newEnd) {
                  setState(() {
                    currentEndCount = newEnd;
                    dayRangeChanged();
                  });
                },
                onDurationChanged: (KorDuration d) => setState(() {
                  duration = d;
                  dayRangeChanged();
                }),
              ),
            ],
          ),
      ],
    );
  }
}

class _DayRangeLimitInputWidget extends StatefulWidget {
  const _DayRangeLimitInputWidget({
    this.count,
    this.duration = KorDuration.day,
    required this.onCountChanged,
    required this.onDurationChanged,
  });
  
  final int? count;
  final KorDuration duration;
  final ValueChanged<int?> onCountChanged;
  final ValueChanged<KorDuration> onDurationChanged;

  @override
  State<_DayRangeLimitInputWidget> createState() => _DayRangeLimitInputWidgetState();
}

class _DayRangeLimitInputWidgetState extends State<_DayRangeLimitInputWidget> {
  final TextEditingController countController = TextEditingController();
  _EventTimeLocation location = _EventTimeLocation.afterStart;

  void countChanged() {
    if(countController.text.isEmpty) {
      widget.onCountChanged(null);
    }
    else {
      var count = int.parse(countController.text);
      if(location == _EventTimeLocation.beforeStart) {
        count *= -1;
      }
      widget.onCountChanged(count);
    }
  }

  void refreshWidgetData() {
    if(widget.count == null) {
      countController.clear();
    }
    else {
      countController.text = widget.count!.abs().toString();
      location = widget.count! < 0
        ? _EventTimeLocation.beforeStart
        : _EventTimeLocation.afterStart;
    }
  }

  @override
  void initState() {
    super.initState();
    refreshWidgetData();
  }
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return Row(
      children: [
        SizedBox(
          width: 96.0,
          child: Focus(
            onFocusChange: (bool hasFocus) {
              if(!hasFocus) {
                countChanged();
              }
            },
            child: TextFormField(
              controller: countController,
              decoration: InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12.0),
                isCollapsed: true,
              ),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
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
        const SizedBox(width: 12.0),
        DropdownMenu(
          initialSelection: widget.duration,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            isCollapsed: true,
            constraints: BoxConstraints(maxHeight: 36.0),
            contentPadding: EdgeInsets.all(12.0),
          ),
          textStyle: theme.textTheme.bodyMedium,
          onSelected: (KorDuration? d) {
            if(d == null) return;
            setState(() {
              widget.onDurationChanged(d);
            });
          },
          dropdownMenuEntries: KorDuration.values
            .map((KorDuration d) => DropdownMenuEntry(value: d, label: d.title))
            .toList(),
        ),
        const SizedBox(width: 12.0),
        DropdownMenu(
          initialSelection: location,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            isCollapsed: true,
            constraints: BoxConstraints(maxHeight: 36.0),
            contentPadding: EdgeInsets.all(12.0),
          ),
          textStyle: theme.textTheme.bodyMedium,
          onSelected: (_EventTimeLocation? l) {
            if(l == null) return;
            setState(() {
              location = l;
              countChanged();
            });
          },
          dropdownMenuEntries: <DropdownMenuEntry<_EventTimeLocation>>[
              DropdownMenuEntry(value: _EventTimeLocation.beforeStart, label: "avant le début"),
              DropdownMenuEntry(value: _EventTimeLocation.afterStart, label: "après le début"),
            ],
        ),
      ],
    );
  }
}