import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/timeline/timeline.dart';
import 'package:prophecy_compagnon_shared/classes/timeline/world_events.dart';
import 'package:prophecy_compagnon_shared/ui/full_page_loading.dart';
import 'package:prophecy_compagnon_shared/ui/timeline/filter_widget.dart';
import 'package:prophecy_compagnon_shared/ui/timeline/timeline_widget.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({ super.key });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  WorldEventFilter filter = WorldEventFilter(age: KorAge.empires);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: TimelineEventFilterWidget(
            filter: filter,
            onFilterChanged: (WorldEventFilter f) {
              setState(() {
                filter = f;
              });
            }
          )
        ),
        FutureBuilder(
          future: WorldEvents.loadAll(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return FullPageLoadingWidget();
            }

            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error!);
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0.0),
                child: Center(
                  child: TimelineWidget(
                    main: Timeline(
                      resolution: TimelineResolution.year,
                      events: WorldEvents.matching(filter).toList(),
                    ),
                    mainColor: theme.colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}