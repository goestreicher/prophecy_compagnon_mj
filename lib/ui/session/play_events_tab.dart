import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

import '../../classes/calendar.dart';
import '../../classes/session/game_session.dart';
import '../../classes/player_character.dart';
import 'command_dispatcher.dart';
import 'pc_review_dialog.dart';
import 'events/day_widget.dart';
import 'events/events_timeline_widget.dart';

class PlayEventsPage extends StatefulWidget {
  const PlayEventsPage({ super.key });

  @override
  State<PlayEventsPage> createState() => _PlayEventsPageState();
}

class _PlayEventsPageState extends State<PlayEventsPage> {
  bool isWorking = false;
  int? selectedDay;
  int? lastSessionDay;

  @override
  Widget build(BuildContext context) {
    var session = context.watch<GameSession>();
    selectedDay ??= session.day;
    if(lastSessionDay != session.day) {
      lastSessionDay = session.day;
      selectedDay = session.day;
    }

    return Stack(
      children: [
        Column(
          children: [
            ListenableBuilder(
              listenable: session.sessionDays,
              builder: (BuildContext context, Widget? child) =>
                SessionEventsTimelineWidget(
                  onDaySelected: (int d) {
                    setState(() {
                      selectedDay = d;
                    });
                  },
                )
            ),
            Expanded(
              child: SessionDayWidget(
                day: selectedDay!,
              )
            ),
          ],
        ),
        if(isWorking)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if(isWorking)
          const Center(
            child: CircularProgressIndicator()
          ),
      ],
    );

    // return Stack(
    //   children: [
    //     ListView.builder(
    //       itemCount: session.scenario.encounters.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         var theme = Theme.of(context);
    //
    //         var startEncounterTooltip = 'Lancer la rencontre';
    //         var canStartEncounter = true;
    //         var startEncounterIcon = const Icon(Symbols.swords);
    //
    //         if(session.map == null) {
    //           canStartEncounter = false;
    //           startEncounterTooltip = 'Pas de carte chargée';
    //         }
    //         else if(session.encounter != null) {
    //           canStartEncounter = false;
    //           startEncounterTooltip = 'Rencontre en cours';
    //           if(session.encounter!.name == session.scenario.encounters[index].name) {
    //             startEncounterIcon = const Icon(Icons.timer);
    //           }
    //         }
    //
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
    //           child: Card(
    //               clipBehavior: Clip.hardEdge,
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    //                 child: Row(
    //                   children: [
    //                     Text(session.scenario.encounters[index].name),
    //                     const Spacer(),
    //                     Tooltip(
    //                       message: startEncounterTooltip,
    //                       child: TextButton(
    //                         onPressed: !canStartEncounter ? null : () async {
    //                           var selectedPcs = await showDialog<List<PlayerCharacter>>(
    //                             context: context,
    //                             builder: (BuildContext context) => PlayerCharacterReviewDialog(characters: session.table.players),
    //                           );
    //
    //                           if(selectedPcs == null || selectedPcs.isEmpty) return;
    //
    //                           setState(() {
    //                             _isWorking = true;
    //                           });
    //                           for(var pc in selectedPcs) {
    //                             await PlayerCharacterStore().save(pc);
    //                           }
    //                           setState(() {
    //                             _isWorking = false;
    //                           });
    //
    //                           dispatcher.dispatchCommand(
    //                               SessionCommand.encounterStart,
    //                               <String, dynamic>{'encounter': session.scenario.encounters[index].instantiate(selectedPcs)}
    //                           );
    //                         },
    //                         style: TextButton.styleFrom(textStyle: theme.textTheme.headlineSmall),
    //                         child: startEncounterIcon,
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               )
    //           ),
    //         );
    //       }
    //     ),
    //     if(_isWorking)
    //       const Opacity(
    //         opacity: 0.6,
    //         child: ModalBarrier(
    //           dismissible: false,
    //           color: Colors.black,
    //         ),
    //       ),
    //     if(_isWorking)
    //       const Center(
    //           child: CircularProgressIndicator()
    //       ),
    //   ],
    // );
  }
}