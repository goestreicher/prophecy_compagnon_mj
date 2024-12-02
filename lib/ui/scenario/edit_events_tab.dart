import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../classes/scenario.dart';
import 'scenario_event_edit_dialog.dart';

class ScenarioEditEventsPage extends StatelessWidget {
  ScenarioEditEventsPage({
    super.key,
    required this.scenario
  })
      : _model = _ScenarioEventsModel(scenario: scenario);

  final Scenario scenario;
  final _ScenarioEventsModel _model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            boxShadow: [BoxShadow(
              color: Colors.grey,
              blurRadius: 4.0,
            )],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Monde',
                        style: theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          var result = await showDialog<ScenarioEventEditResult>(
                            context: context,
                            builder: (context) => ScenarioEventEditDialog(),
                          );
                          if(result == null) return;

                          _model.add(result.dayRange, ScenarioEventCategory.world, result.event);
                        },
                        icon: const Icon(Icons.add)
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Joueurs',
                        style: theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          var result = await showDialog<ScenarioEventEditResult>(
                            context: context,
                            builder: (context) => ScenarioEventEditDialog(),
                          );
                          if(result == null) return;

                          _model.add(result.dayRange, ScenarioEventCategory.pc, result.event);
                        },
                        icon: const Icon(Icons.add)
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ChangeNotifierProvider<_ScenarioEventsModel>.value(
              value: _model,
              child: _ScenarioEventsListWidget()
            ),
          )
        ),
      ],
    );
  }
}

class _ScenarioEventsModel extends ChangeNotifier {
  _ScenarioEventsModel({ required this.scenario });

  final Scenario scenario;

  List<ScenarioEventDayRange> days() {
    return scenario.events.keys.toList()
      ..sort((a, b) => a.start - b.start);
  }

  ScenarioDayEvents eventsForDay(ScenarioEventDayRange day) {
    return scenario.events[day]!;
  }

  void add(ScenarioEventDayRange day, ScenarioEventCategory category, ScenarioEvent event, { int pos = -1 }) {
    scenario.addEvent(day, category, event, pos: pos);
    notifyListeners();
  }

  void remove(ScenarioEventDayRange day, ScenarioEventCategory category, int pos) {
    scenario.removeEvent(day, category, pos);
    notifyListeners();
  }

  void move(ScenarioEventCategory category,
      ScenarioEventDayRange startDay, ScenarioEventDayRange endDay,
      int start, int dest
  ) {
    scenario.moveEvent(category, startDay, endDay, start, dest);
    notifyListeners();
  }
}

class _ScenarioEventsModelItem extends ChangeNotifier {
  _ScenarioEventsModelItem({ required this.dayRange, required this.event });

  final ScenarioEventDayRange dayRange;
  final ScenarioEvent event;
  bool _collapsed = true;

  bool get collapsed => _collapsed;
  set collapsed(bool c) {
    _collapsed = c;
    notifyListeners();
  }

  void eventUpdated() => notifyListeners();
}

class _EventDragModel extends ChangeNotifier {
  _EventDragModel();

  ScenarioEventDayRange? dayRange;
  ScenarioEventCategory? category;
  int? eventPos;

  final double dragTargetHeight = 24.0;
  final double dragTargetAcceptsHeight = 56.0;

  bool get dragging => _dragging;
  set dragging(bool d) {
    _dragging = d;
    notifyListeners();
  }

  ScenarioEventDayRange? get hoverDayRange => _hoverDayRange;
  set hoverDayRange(ScenarioEventDayRange? r) {
    _hoverDayRange = r;
    notifyListeners();
  }

  bool _dragging = false;
  ScenarioEventDayRange? _hoverDayRange;
}

class _ScenarioEventsListWidget extends StatelessWidget {
  const _ScenarioEventsListWidget();

  @override
  Widget build(BuildContext context) {
    var events = context.watch<_ScenarioEventsModel>();
    var days = events.days();

    return ChangeNotifierProvider<_EventDragModel>(
      create: (_) => _EventDragModel(),
      child: ScrollablePositionedList.builder(
        itemCount: days.length,
        itemBuilder: (BuildContext context, int index) {
          return _ScenarioDayEventsWidget(
            dayRange: days[index],
            events: events.eventsForDay(days[index]),
            onDelete: (ScenarioEventCategory category, int pos) {
              events.remove(days[index], category, pos);
            },
          );
        }
      ),
    );
  }
}

class _ScenarioDayEventsWidget extends StatelessWidget {
  const _ScenarioDayEventsWidget({
    required this.dayRange,
    required this.events,
    required this.onDelete,
  });

  final ScenarioEventDayRange dayRange;
  final ScenarioDayEvents events;
  final void Function(ScenarioEventCategory, int) onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var gutterWidth = 16.0;

    var worldEvents = _SingleDayEventsWidget(
      dayRange: dayRange,
      category: ScenarioEventCategory.world,
      events: events.events.containsKey(ScenarioEventCategory.world)
        ? events.events[ScenarioEventCategory.world]!
        : [],
      onDelete: (int pos) async {
        onDelete(ScenarioEventCategory.world, pos);
      },
    );

    var pcEvents = _SingleDayEventsWidget(
      dayRange: dayRange,
      category: ScenarioEventCategory.pc,
      events: events.events.containsKey(ScenarioEventCategory.pc)
        ? events.events[ScenarioEventCategory.pc]!
        : [],
      onDelete: (int pos) async {
        onDelete(ScenarioEventCategory.pc, pos);
      },
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var dragModel = context.watch<_EventDragModel>();

        return DragTarget(
          onWillAcceptWithDetails: (_) {
            dragModel.hoverDayRange = dayRange;
            return false;
          },
          onLeave: (_) {
            dragModel.hoverDayRange = null;
          },
          builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                    child: Text(
                      dayRange.start == dayRange.end
                          ? "Jour ${dayRange.start}"
                          : "Jours ${dayRange.start} - ${dayRange.end}",
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth / 2 - gutterWidth,
                      child: worldEvents,
                    ),
                    Spacer(),
                    SizedBox(
                      width: constraints.maxWidth / 2 - gutterWidth,
                      child: pcEvents,
                    ),
                  ],
                )
              ],
            );
          },
        );
      }
    );
  }
}

class _SingleEventDragTarget extends StatefulWidget {
  const _SingleEventDragTarget({
    required this.position,
    required this.dayRange,
    required this.category
  });

  final int position;
  final ScenarioEventDayRange dayRange;
  final ScenarioEventCategory category;

  @override
  State<_SingleEventDragTarget> createState() => _SingleEventDragTargetState();
}

class _SingleEventDragTargetState extends State<_SingleEventDragTarget> {
  bool hasCandidateHovering = false;
  
  bool _canReceiveDraggedEvent(_EventDragModel dragModel) {
    if(!dragModel.dragging) {
      return false;
    }

    if(dragModel.category == null || dragModel.category != widget.category) {
      return false;
    }

    if(dragModel.hoverDayRange == null || dragModel.hoverDayRange != widget.dayRange) {
      return false;
    }

    if(dragModel.dayRange == widget.dayRange && (dragModel.eventPos == widget.position -1 || dragModel.eventPos == widget.position)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var scenarioModel = context.watch<_ScenarioEventsModel>();
    var dragModel = context.watch<_EventDragModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
      child: DragTarget(
        hitTestBehavior: HitTestBehavior.translucent,
        builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: hasCandidateHovering
                ? dragModel.dragTargetAcceptsHeight
                : _canReceiveDraggedEvent(dragModel)
                  ? dragModel.dragTargetHeight
                  : 0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
        },
        onWillAcceptWithDetails: (DragTargetDetails<_SingleEventDragData> details) {
          // Just set the dragModel hoverDayRange here too to prevent jitter due to
          // onLeave being called for the parent
          dragModel.hoverDayRange = widget.dayRange;

          if(widget.category != details.data.category) {
            return false;
          }

          hasCandidateHovering = true;
          return true;
        },
        onLeave: (_) => hasCandidateHovering = false,
        onAcceptWithDetails: (DragTargetDetails<_SingleEventDragData> details) {
          scenarioModel.move(details.data.category,
              details.data.dayRange, widget.dayRange,
              details.data.position, widget.position);
          hasCandidateHovering = false;
        },
      ),
    );
  }
}

class _SingleDayEventsWidget extends StatefulWidget {
  const _SingleDayEventsWidget({
    required this.dayRange,
    required this.category,
    required this.events,
    required this.onDelete,
  });

  final ScenarioEventDayRange dayRange;
  final ScenarioEventCategory category;
  final List<ScenarioEvent> events;
  final void Function(int) onDelete;

  @override
  State<_SingleDayEventsWidget> createState() => _SingleDayEventsWidgetState();
}

class _SingleDayEventsWidgetState extends State<_SingleDayEventsWidget> {
  int? currentlyDraggedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var theme = Theme.of(context);
          var dragModel = context.watch<_EventDragModel>();

          var widgets = <Widget>[
            _SingleEventDragTarget(position: 0, dayRange: widget.dayRange, category: widget.category),
          ];

          for(var pos = 0; pos < widget.events.length; ++pos) {
            widgets.addAll([
              LongPressDraggable<_SingleEventDragData>(
                data: _SingleEventDragData(
                    dayRange: widget.dayRange,
                    category: widget.category,
                    position: pos,
                    event: widget.events[pos]
                ),
                delay: Duration(milliseconds: 200),
                onDragStarted: () {
                  dragModel.dragging = true;
                  dragModel.dayRange = widget.dayRange;
                  dragModel.category = widget.category;
                  dragModel.eventPos = pos;
                  setState(() {
                    currentlyDraggedItem = pos;
                  });
                },
                onDragEnd: (DraggableDetails details) {
                  dragModel.dragging = false;
                  dragModel.dayRange = null;
                  dragModel.category = null;
                  dragModel.eventPos = null;
                  dragModel.hoverDayRange = null;
                  setState(() {
                    currentlyDraggedItem = null;
                  });
                },
                feedback: SizedBox(
                  width: constraints.maxWidth - 16.0,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        widget.events[pos].title,
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ),
                child: ChangeNotifierProvider(
                  key: ObjectKey(widget.events[pos]),
                  create: (_) {
                    return _ScenarioEventsModelItem(
                        dayRange: widget.dayRange,
                        event: widget.events[pos]
                    );
                  },
                  child: Opacity(
                    opacity: currentlyDraggedItem == pos ? 0.2 : 1.0,
                    child: _SingleEventWidget(
                      onDelete: () => widget.onDelete(pos),
                    ),
                  ),
                ),
              ),
              _SingleEventDragTarget(position: pos+1, dayRange: widget.dayRange, category: widget.category),
            ]);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgets,
          );
        }
      ),
    );
  }
}

class _SingleEventDragData {
  _SingleEventDragData({
    required this.dayRange,
    required this.category,
    required this.position,
    required this.event
  });
  final ScenarioEventDayRange dayRange;
  final ScenarioEventCategory category;
  final int position;
  final ScenarioEvent event;
}

class _SingleEventWidget extends StatelessWidget {
  const _SingleEventWidget({
    required this.onDelete,
  });

  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var eventModel = context.watch<_ScenarioEventsModelItem>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => eventModel.collapsed = !eventModel.collapsed,
                  icon: Icon(
                    eventModel.collapsed
                        ? Icons.keyboard_arrow_right
                        : Icons.keyboard_arrow_down
                  ),
                  iconSize: 20.0,
                ),
                Text(
                  eventModel.event.title,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () async {
                    var result = await showDialog<ScenarioEventEditResult>(
                      context: context,
                      builder: (context) => ScenarioEventEditDialog(
                          dayRange: eventModel.dayRange,
                          event: eventModel.event,
                      ),
                    );
                    if(result == null) return;
                    eventModel.eventUpdated();
                  },
                  icon: const Icon(Icons.edit),
                  iconSize: 20.0,
                ),
                IconButton(
                  onPressed: () {
                    onDelete();
                  },
                  icon: const Icon(Icons.delete),
                  iconSize: 20.0,
                ),
              ],
            ),
            if(!eventModel.collapsed)
              const SizedBox(height: 4.0),
            if(!eventModel.collapsed)
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 12.0),
                child: Text(
                  eventModel.event.description,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}