import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_mj/ui/session/encounter/start_encounter_manager.dart';
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario_encounter.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario_event.dart';
import 'package:prophecy_compagnon_shared/classes/session/event.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/ui/markdown_display_widget.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/link_handler.dart';
import 'package:prophecy_compagnon_shared/ui/single_line_input_dialog.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SessionDayWidget extends StatelessWidget {
  const SessionDayWidget({
    super.key,
    required this.day,
  });

  final int day;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var session = context.watch<GameSession>();

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListenableBuilder(
                  listenable: session.sessionDays,
                  builder: (BuildContext context, Widget? child) =>
                    _EventCategoryWidget(
                      ranges: session.sessionDays.rangesForDay(day).toList(),
                      category: ScenarioEventCategory.world,
                      createEventDay: day,
                      backgroundColor: theme.colorScheme.tertiaryFixed.withAlpha(50),
                      eventBackgroundColor: theme.colorScheme.tertiaryFixed,
                    ),
                ),
              ),
              Expanded(
                child: ListenableBuilder(
                  listenable: session.sessionDays,
                  builder: (BuildContext context, Widget? child) =>
                    _EventCategoryWidget(
                      ranges: session.sessionDays.rangesForDay(day).toList(),
                      category: ScenarioEventCategory.pc,
                      createEventDay: day,
                      backgroundColor: theme.colorScheme.secondaryFixed.withAlpha(50),
                      eventBackgroundColor: theme.colorScheme.secondaryFixed,
                    ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventCategoryWidget extends StatelessWidget {
  const _EventCategoryWidget({
    required this.ranges,
    required this.category,
    required this.createEventDay,
    required this.backgroundColor,
    required this.eventBackgroundColor,
  });

  final List<DayRange> ranges;
  final ScenarioEventCategory category;
  final int createEventDay;
  final Color backgroundColor;
  final Color eventBackgroundColor;

  @override
  Widget build(BuildContext context) {
    var session = context.watch<GameSession>();

    var widgets = <Widget>[];
    for(var range in ranges) {
      var events = session.sessionDays[range]?[category] ?? <SessionEvent>[];

      if(events.isNotEmpty) {
        var dayDescriptionSpans = <InlineSpan>[
          TextSpan(text: session.relativeSessionDate(range.start).toString()),
          TextSpan(text: ' / (${session.relativeSessionDateDescription(range.start - session.day)})'),
        ];
        if (range.length > 1) {
          dayDescriptionSpans.insert(
              0,
              TextSpan(
                text: 'Début : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
          );
          dayDescriptionSpans.addAll([
            TextSpan(
              text: '\nFin : ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: session.relativeSessionDate(range.end).toString()),
            TextSpan(text: ' / (${session.relativeSessionDateDescription(range.end - session.day)})'),
          ]);
        }

        widgets.add(
            Card(
              color: eventBackgroundColor,
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(
                      children: dayDescriptionSpans
                  ),
                ),
              ),
            )
        );
      }

      for(var event in events) {
        widgets.add(
          _EventWidget(
            key: ValueKey(event.uuid),
            range: range,
            event: event,
            backgroundColor: eventBackgroundColor,
          )
        );
      }

      if(ranges.length > 1 && events.isNotEmpty) {
        widgets.add(
          SizedBox(height: 16.0)
        );
      }
    }

    if(widgets.isEmpty) {
      widgets.add(
        Text(
          "Pas d'événements pour cette catégorie",
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        )
      );
    }

    return ColoredBox(
      color: backgroundColor,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 12.0,
              children: [
                ...widgets,
                TextButton.icon(
                  onPressed: () async {
                    var title = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SingleLineInputDialog(
                          title: "Titre de l'événement",
                          formKey: GlobalKey<FormState>(),
                          hintText: 'Titre',
                        );
                      }
                    );
                    if(title == null) return;
                    if(!context.mounted) return;

                    var event = SessionEvent(
                      me: ScenarioEvent(
                        uuid: Uuid().v4().toString(),
                        title: title,
                        description: "",
                        isRealizedInASingleDay: true,
                      )
                    );

                    var range = DayRange(
                      start: createEventDay,
                      end: createEventDay,
                    );

                    session.sessionDays.add(
                      range,
                      category,
                      event,
                    );
                  },
                  label: Text('Nouvel événement (jour ${createEventDay+1})'),
                  icon: Icon(Icons.add),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

class _EventWidget extends StatelessWidget {
  const _EventWidget({
    super.key,
    required this.range,
    required this.event,
    required this.backgroundColor,
  });

  final DayRange range;
  final SessionEvent event;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    var session = context.read<GameSession>();
    var extraActionButtons = <ResourceLinkType, List<ExtraActionButtonBuilder>>{};

    if(
        event.realized == null
        && session.encounter.value == null
        && session.day >= range.start
        && session.day <= range.end
    ) {
      extraActionButtons[ResourceLinkType.encounter] = <ExtraActionButtonBuilder>[
        (BuildContext context, ResourceLink link) {
          var idx = session.scenario.encounters.indexWhere(
              (ScenarioEncounter e) => e.uuid == link.id
          );
          if(idx == -1) {
            return SizedBox.shrink();
          }

          return TextButton(
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();

              var started = await StartEncounterManager(
                session: session,
                scenarioEncounter: session.scenario.encounters[idx],
                context: context,
              ).start();
              if(!context.mounted) return;

              if(started) {
                var tabController = DefaultTabController.maybeOf(context);
                if (tabController != null) {
                  tabController.animateTo(1);
                }
              }
            },
            child: const Text('Lancer la rencontre')
          );
        },
      ];
    }

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.0,
          children: [
            _EventWidgetTitle(
              range: range,
              event: event,
            ),
            MarkdownDisplayWidget(
              data: event.description,
              extraActionButtonBuilders: extraActionButtons,
            ),
            _EventNotesWidget(
              notes: event.notes,
              onChanged: (List<String> notes) {
                event.notes = notes;
              },
            ),
          ],
        )
      ),
    );
  }
}

class _EventWidgetTitle extends StatefulWidget {
  const _EventWidgetTitle({
    required this.range,
    required this.event,
  });

  final DayRange range;
  final SessionEvent event;

  @override
  State<_EventWidgetTitle> createState() => _EventWidgetTitleState();
}

class _EventWidgetTitleState extends State<_EventWidgetTitle> {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var session = context.read<GameSession>();

    var canRealize = false;
    if(widget.event.realized == null) {
      if(widget.event.isRealizedInASingleDay) {
        canRealize = session.day >= widget.range.start
            && session.day <= widget.range.end;
      }
      else {
        canRealize = session.day == widget.range.end;
      }
    }

    String realizationHint;
    if(widget.event.realized != null) {
      realizationHint = "Réalisé le ${session.relativeSessionDate(widget.event.realized!.end).toString()}";
    }
    else {
      realizationHint = "Réalisable : ";
      if(widget.range.start > session.day) {
        if(widget.event.isRealizedInASingleDay) {
          realizationHint += session.relativeSessionDateDescription(widget.range.start - session.day);
        }
        else {
          realizationHint += session.relativeSessionDateDescription(widget.range.end - session.day);
        }
      }
      else {
        if(widget.event.isRealizedInASingleDay) {
          realizationHint += "Aujourd'hui";
        }
        else {
          realizationHint += session.relativeSessionDateDescription(widget.range.end - session.day);
        }
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event.title,
                style: theme.textTheme.titleLarge!
                  .copyWith(
                    fontWeight: FontWeight.bold,
                    color: widget.event.realized == null
                      ? null
                      : theme.disabledColor,
                  ),
              ),
              if(widget.event.realized != null)
                Text(
                  realizationHint,
                  style: TextStyle(
                    color: theme.disabledColor,
                  ),
                ),
              if(widget.event.realized == null)
                Text(
                  realizationHint,
                ),
            ],
          ),
        ),
        if(canRealize)
          IconButton.outlined(
            onPressed: () {
              DayRange realizationRange;
              if(widget.event.isRealizedInASingleDay) {
                realizationRange = DayRange(start: session.day, end: session.day);
              }
              else {
                realizationRange = widget.range;
              }

              // TODO: manage events realized over a single day
              setState(() {
                session.sessionDays.markEventAsRealized(
                  widget.range,
                  widget.event.uuid,
                  realizationRange,
                );
              });
            },
            icon: Icon(Icons.check),
            tooltip: 'Marquer cet événément réalisé',
            iconSize: 18.0,
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }
}

class _EventNotesWidget extends StatefulWidget {
  const _EventNotesWidget({
    required this.notes,
    required this.onChanged,
  });

  final List<String> notes;
  final void Function(List<String>) onChanged;

  @override
  State<_EventNotesWidget> createState() => _EventNotesWidgetState();
}

class _EventNotesWidgetState extends State<_EventNotesWidget> {
  late List<String> notes;
  bool creating = false;

  @override
  void initState() {
    super.initState();

    notes = List<String>.from(widget.notes);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var notesWidgets = <Widget>[];
    for(var (index, note) in notes.indexed) {
      notesWidgets.add(
        _SingleNoteWidget(
          content: note,
          onChange: (String v) {
            setState(() {
              notes[index] = v;
            });
            widget.onChanged(notes);
          },
          onDelete: () {
            setState(() {
              notes.removeAt(index);
            });
            widget.onChanged(notes);
          }
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Text(
          'Notes',
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        ...notesWidgets,
        if(creating)
          _CreateNoteWidget(
            onCreate: (String v) {
              if(v.isNotEmpty) {
                setState(() {
                  notes.add(v);
                });
                widget.onChanged(notes);
              }
              creating = false;
            },
            onCancel: () {
              setState(() {
                creating = false;
              });
            }
          ),
        if(!creating)
          TextButton.icon(
            onPressed: () {
              setState(() {
                creating = true;
              });
            },
            label: const Text('Nouvelle note'),
            icon: Icon(Icons.add),
          ),
      ],
    );
  }
}

class _SingleNoteWidget extends StatefulWidget {
  const _SingleNoteWidget({
    required this.content,
    required this.onChange,
    required this.onDelete,
  });
  
  final String content;
  final void Function(String) onChange;
  final VoidCallback onDelete;

  @override
  State<_SingleNoteWidget> createState() => _SingleNoteWidgetState();
}

class _SingleNoteWidgetState extends State<_SingleNoteWidget> {
  bool editing = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if(editing) {
      return _CreateNoteWidget(
        initialValue: widget.content,
        onCreate: (String v) {
          if(v.isNotEmpty) {
            widget.onChange(v);
          }
          setState(() {
            editing = false;
          });
        },
        onCancel: () {
          setState(() {
            editing = false;
          });
        }
      );
    }
    else {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              Expanded(child: Text(widget.content)),
              Column(
                spacing: 8.0,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        editing = true;
                      });
                    },
                    icon: Icon(Icons.edit),
                    iconSize: 24.0,
                    padding: const EdgeInsets.all(4.0),
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: Icon(Icons.delete),
                    iconSize: 24.0,
                    padding: const EdgeInsets.all(4.0),
                    constraints: const BoxConstraints(),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}

class _CreateNoteWidget extends StatefulWidget {
  const _CreateNoteWidget({
    required this.onCreate,
    required this.onCancel,
    this.initialValue,
  });
  
  final void Function(String) onCreate;
  final VoidCallback onCancel;
  final String? initialValue;

  @override
  State<_CreateNoteWidget> createState() => _CreateNoteWidgetState();
}

class _CreateNoteWidgetState extends State<_CreateNoteWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            minLines: 4,
            maxLines: 8,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Column(
          spacing: 8.0,
          children: [
            IconButton.outlined(
              onPressed: () {
                widget.onCreate(controller.text);
              },
              icon: Icon(Icons.check),
              iconSize: 24.0,
              padding: const EdgeInsets.all(4.0),
              constraints: const BoxConstraints(),
            ),
            IconButton.outlined(
              onPressed: widget.onCancel,
              icon: Icon(Icons.close),
              iconSize: 24.0,
              padding: const EdgeInsets.all(4.0),
              constraints: const BoxConstraints(),
            )
          ],
        )
      ],
    );
  }
}