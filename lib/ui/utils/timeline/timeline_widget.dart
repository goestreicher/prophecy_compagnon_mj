import 'package:flutter/material.dart';

import '../../../classes/timeline/event.dart';
import '../../../classes/timeline/timeline.dart';

const _drawOppositeCustomPropertyName = 'timeline-draw-opposite';

class TimelineWidget extends StatefulWidget {
  const TimelineWidget({
    super.key,
    this.thickness = 16.0,
    required this.main,
    this.mainColor = Colors.black,
    this.opposite,
    this.oppositeColor,
  });

  final double thickness;
  final Timeline main;
  final Color mainColor;
  final Timeline? opposite;
  final Color? oppositeColor;

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  late Timeline consolidated;

  @override
  void initState() {
    super.initState();

    if(widget.opposite == null) {
      consolidated = widget.main;
    }
    else {
      consolidated = Timeline.from(widget.main);
      for(var entry in widget.opposite!.entries) {
        for(var event in entry.value) {
          event.properties[_drawOppositeCustomPropertyName] = true;
          consolidated.add(event);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemCount: consolidated.length,
          itemBuilder: (BuildContext context, int index) {
            var theme = Theme.of(context);

            var header = Text(
              consolidated.entries.elementAt(index).key.format('%Y'),
              style: theme.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
            );

            List<TimelineEvent> oppositeEvents = <TimelineEvent>[];
            List<TimelineEvent> mainEvents = <TimelineEvent>[];

            for(var e in consolidated.entries.elementAt(index).value) {
              if(e.hasProperty(_drawOppositeCustomPropertyName) && e.property<bool>(_drawOppositeCustomPropertyName)) {
                oppositeEvents.add(e);
              }
              else {
                mainEvents.add(e);
              }
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(oppositeEvents.isNotEmpty)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 32, 12, 32),
                        child: _TimelineEntryWidget(
                          header: Text(
                              ' ',
                              style: theme.textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          events: oppositeEvents,
                          alignment: _TimelineEntryAlignment.right,
                        ),
                      )
                    ),
                  if(oppositeEvents.isEmpty)
                    Expanded(child: SizedBox(width: 32)),
                  Stack(
                    alignment: AlignmentGeometry.topCenter,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              width: widget.thickness,
                              color: widget.mainColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                        child: SizedBox(
                          width: widget.thickness * 2,
                          height: widget.thickness * 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: mainEvents.isNotEmpty
                                  ? widget.mainColor
                                  : widget.oppositeColor ?? widget.mainColor,
                                width: widget.thickness / 3,
                              ),
                              borderRadius: BorderRadius.circular(widget.thickness),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(12, 32, 0, 32),
                      child: _TimelineEntryWidget(
                        header: header,
                        events: mainEvents,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        )
      ],
    );
  }
}

enum _TimelineEntryAlignment {
  left,
  right,
}

class _TimelineEntryWidget extends StatelessWidget {
  const _TimelineEntryWidget({
    this.header,
    required this.events,
    this.alignment = _TimelineEntryAlignment.left,
  });

  final Widget? header;
  final List<TimelineEvent> events;
  final _TimelineEntryAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment == _TimelineEntryAlignment.left
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end,
      children: [
        ?header,
        for(var event in events)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(event.title),
            ),
          )
      ],
    );
  }
}