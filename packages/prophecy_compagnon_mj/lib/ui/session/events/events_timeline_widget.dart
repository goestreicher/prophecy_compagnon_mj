import 'dart:collection';
import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:provider/provider.dart';

class SessionEventsTimelineWidget extends StatefulWidget {
  const SessionEventsTimelineWidget({
    super.key,
    required this.onDaySelected,
    this.timelinePadding = 8.0,
  });

  final void Function(int) onDaySelected;
  final double timelinePadding;

  @override
  State<SessionEventsTimelineWidget> createState() => _SessionEventsTimelineWidgetState();
}

class _SessionEventsTimelineWidgetState extends State<SessionEventsTimelineWidget> {
  int? selectedDay;
  int? lastSessionDay;

  void _updateRangesContaining(
      DayRange range,
      double y,
      double width,
      double spacing,
      SplayTreeMap<DayRange, ({double y, double w})> positioned
  ) {
    for(var pRange in positioned.keys) {
      if(
          range.start > pRange.start
          && range.end <= pRange.end
          && (y + width) > (positioned[pRange]!.y + positioned[pRange]!.w)
      ) {
        var pWidth = positioned[pRange]!.w + (y + width) - (positioned[pRange]!.y + positioned[pRange]!.w);
        positioned[pRange] = (y: positioned[pRange]!.y, w: pWidth);
        _updateRangesContaining(pRange, positioned[pRange]!.y, pWidth, spacing, positioned);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var session = context.watch<GameSession>();
    var theme = Theme.of(context);
    var pillWidth = 24.0;
    var pillHeight = 18.0;
    var pillSpacing = 6.0;
    var currentRangeY = 0.0;
    var multiDayRuns = <List<DayRange>>[];
    var singleDayRun = <DayRange>[];
    var positioned = SplayTreeMap<DayRange, ({double y, double w})>();
    var indicatorPositions = <int, double>{};
    var currentDayY = 0.0;
    var selectedDayY = 0.0;
    var dayMarkerWidth = 5.0;
    var dayIndicatorWidth = pillHeight;
    selectedDay ??= session.day;
    if(lastSessionDay != session.day) {
      lastSessionDay = session.day;
      selectedDay = session.day;
    }

    for(var currentRange in session.sessionDays.keys) {
      var currentRangeWidth = pillWidth;
      if(currentRange.length > 1) {
        currentRangeWidth = pillWidth * ((log(currentRange.length)/ln10) + 1);
      }

      // Find the best candidate for the previous range
      DayRange? previousRange;
      var bestMultiStartDelta = pow(2, 32).toInt();
      var bestSingleStartDelta = pow(2, 32).toInt();
      for(var p in positioned.keys) {
        var startDelta = currentRange.start - p.end;
        if(currentRange.start >= p.end) {
          if(p.length > 1 && startDelta >= 0 && startDelta <= bestMultiStartDelta) {
            bestMultiStartDelta = startDelta;
            previousRange = p;
          }
          else if(p.length == 1 && startDelta > 0 && startDelta <= bestSingleStartDelta) {
            bestSingleStartDelta = startDelta;
            previousRange = p;
          }
        }
      }

      // if the previous range and the current range have the same start
      // date, then current Y position is identical.
      // Only test here if the current range starts after the previous
      // range, as it is impossible (given the sort order) that the current
      // range starts before.
      if(previousRange != null && currentRange.start > previousRange.start) {
        var currentOffset = 0.0;

        if(previousRange.length > 1 && previousRange.end > previousRange.start) {
          currentOffset = positioned[previousRange]!.w / (previousRange.end - previousRange.start + 1);
          if (currentOffset < dayIndicatorWidth) {
            currentOffset = dayIndicatorWidth;
          }
        }

        if(currentRange.start > previousRange.end) {
          currentOffset += positioned[previousRange]!.w;
        }

        if(
            (previousRange.end < session.day && session.day < currentRange.start)
            || (previousRange.start < session.day && session.day < currentRange.start)
        ) {
          currentOffset += dayIndicatorWidth + pillSpacing;
        }

        currentRangeY = positioned[previousRange]!.y + currentOffset + pillSpacing;
      }
      _updateRangesContaining(currentRange, currentRangeY, currentRangeWidth, pillSpacing, positioned);

      if(currentRange.length == 1) {
        singleDayRun.add(currentRange);
      }
      else {
        var isPlaced = false;

        for(var run in multiDayRuns) {
          var candidateIndex = -1;

          for(var (placedIndex, placed) in run.indexed) {
            if(!(currentRange.overlaps(placed) || placed.overlaps(currentRange))) {
              candidateIndex = placedIndex + 1;
            }
            else if(candidateIndex > -1) {
              candidateIndex = -1;
            }
          }

          if(candidateIndex != -1) {
            run.insert(candidateIndex, currentRange);
            isPlaced = true;
            break;
          }
        }

        if(!isPlaced) {
          multiDayRuns.add([currentRange]);
        }
      }

      positioned[currentRange] = (y: currentRangeY, w: currentRangeWidth);
    }


    var runWidgets = <Widget>[];
    for(var run in multiDayRuns.reversed) {
      runWidgets.add(
        _TimelineRunWidget(
          pillHeight: pillHeight,
          run: SplayTreeMap<DayRange, ({double y, double w, bool r})>
                  .fromIterable(
                    run,
                    key: (r) => r,
                    value: (r) => (
                      y: positioned[r]!.y,
                      w: positioned[r]!.w,
                      r: session.sessionDays[r]!.unrealized().isEmpty,
                    ),
                  )
        ),
      );
    }

    runWidgets.add(
      _TimelineRunWidget(
        pillHeight: pillHeight,
        run: SplayTreeMap<DayRange, ({double y, double w, bool r})>
                .fromIterable(
                  singleDayRun,
                  key: (r) => r,
                  value: (r) => (
                    y: positioned[r]!.y,
                    w: positioned[r]!.w,
                    r: session.sessionDays[r]!.unrealized().isEmpty,
                  ),
                )
      ),
    );

    for(var range in positioned.keys) {
      if(indicatorPositions.containsKey(range.start)) continue;
      indicatorPositions[range.start] = positioned[range]!.y;
    }

    if(!indicatorPositions.containsKey(session.day)) {
      var currentDayRange = DayRange(start: session.day, end: session.day);
      var r = positioned.firstKeyAfter(currentDayRange)!;
      indicatorPositions[session.day] = positioned[r]!.y - dayIndicatorWidth - pillSpacing;
    }
    currentDayY = indicatorPositions[session.day]!;

    var currentDayColor = selectedDay == session.day
      ? theme.colorScheme.primaryContainer
      : theme.colorScheme.primaryFixedDim;

    var dayMarkers = <Widget>[
      Positioned(
        top: 0.0,
        left: currentDayY + dayIndicatorWidth/2 + widget.timelinePadding,
        child: Container(
          width: dayMarkerWidth,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: currentDayColor,
          ),
        )
      )
    ];

    if(selectedDay != session.day && indicatorPositions.containsKey(selectedDay)) {
      selectedDayY = indicatorPositions[selectedDay]! + dayIndicatorWidth / 2;
      dayMarkers.add(
        Positioned(
          top: 0.0,
          left: selectedDayY + widget.timelinePadding,
          child: Container(
            width: dayMarkerWidth,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
            ),
          )
        )
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.shadow,
      ),
      child: Stack(
        children: [
          ...dayMarkers,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 4.0,
              children: [
                ...runWidgets,
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: pillHeight,
                    child: Stack(
                      children: [
                        for(var d in indicatorPositions.keys)
                          Positioned(
                            left: indicatorPositions[d]! + (pillWidth - dayIndicatorWidth) / 2,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDay = d;
                                  });
                                  widget.onDaySelected(d);
                                },
                                child: Tooltip(
                                  richMessage: TextSpan(
                                    children: [
                                      TextSpan(text: session.relativeSessionDate(d).toString()),
                                      TextSpan(text: ' / (${session.relativeSessionDateDescription(d - session.day)})'),
                                    ]
                                  ),
                                  child: Container(
                                    height: dayIndicatorWidth,
                                    width: dayIndicatorWidth,
                                    decoration: BoxDecoration(
                                      color: selectedDay != null && d == selectedDay
                                        ? theme.colorScheme.primaryContainer
                                        : d == session.day
                                            ? theme.colorScheme.primaryFixedDim
                                            : theme.colorScheme.tertiaryContainer,
                                      borderRadius: BorderRadius.circular(dayIndicatorWidth / 2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRunWidget extends StatelessWidget {
  const _TimelineRunWidget({
    required this.pillHeight,
    required this.run,
    this.unrealizedColor = Colors.white,
    this.realizedColor = Colors.grey,
  });

  final double pillHeight;
  final SplayTreeMap<DayRange, ({double y, double w, bool r})> run;
  final Color unrealizedColor;
  final Color realizedColor;

  @override
  Widget build(BuildContext context) {
    var session = context.watch<GameSession>();
    var children = <Widget>[];

    for(var range in run.keys) {
      InlineSpan tooltip;
      if(range.length == 1) {
        tooltip = TextSpan(
          children: [
            TextSpan(text: session.relativeSessionDate(range.start).toString()),
            TextSpan(text: ' / (${session.relativeSessionDateDescription(range.start - session.day)})'),
          ]
        );
      }
      else {
        tooltip = TextSpan(
            children: [
              TextSpan(text: 'Début : '),
              TextSpan(text: session.relativeSessionDate(range.start).toString()),
              TextSpan(text: ' / (${session.relativeSessionDateDescription(range.start - session.day)})'),
              TextSpan(text: '\nFin : '),
              TextSpan(text: session.relativeSessionDate(range.end).toString()),
              TextSpan(text: ' / (${session.relativeSessionDateDescription(range.end - session.day)})'),
            ]
        );
      }

      children.add(
        Positioned(
          left: run[range]!.y,
          child: _TimelineDayWidget(
            width: run[range]!.w,
            height: pillHeight,
            color: run[range]!.r ? realizedColor : unrealizedColor,
            tooltip: tooltip,
          ),
        )
      );
    }

    return SizedBox(
      height: pillHeight,
      child: Stack(
        children: children,
      ),
    );
  }
}

class _TimelineDayWidget extends StatelessWidget {
  const _TimelineDayWidget({
    required this.width,
    required this.height,
    required this.tooltip,
    required this.color,
  });

  final double width;
  final double height;
  final InlineSpan tooltip;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      richMessage: tooltip,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height / 4.0),
        ),
      ),
    );
  }
}