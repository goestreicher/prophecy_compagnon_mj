import 'package:flutter/material.dart';

import '../../../classes/player_character.dart';
import '../../../classes/scenario/scenario_encounter.dart';
import '../../../classes/session/board/board.dart';
import '../../../classes/session/board/item.dart';
import '../../../classes/session/board/item_map.dart';
import '../../../classes/session/game_session.dart';
import '../../../classes/session/encounter.dart';
import '../../utils/session/clients/session_message_bus_client.dart';
import '../../utils/session/messages/action/start_pc_review.dart';
import '../../utils/session/messages/session_message.dart';
import '../../utils/session/messages/session_message_response.dart';
import '../board/item_picker.dart';

class StartEncounterResult {
  StartEncounterResult({
    this.map,
    required this.encounter,
  });

  final SessionBoardItemMap? map;
  final SessionEncounter encounter;
}

class StartEncounterManager {
  StartEncounterManager({
    required this.session,
    required this.scenarioEncounter,
    required this.context,
  });

  final GameSession session;
  final ScenarioEncounter scenarioEncounter;
  final BuildContext context;

  Future<bool> start() async {
    var mapResult = await showDialog<_SelectMapDialogResult>(
      context: context,
      builder: (BuildContext context) =>
          _SelectMapDialog(board: session.board),
    );
    if(!context.mounted) return false;
    // TODO: mapResult can be null, in which case no map will be pushed
    // TODO: In that case, how to manage the board and the thumbnail?
    if(mapResult == null) return false;

    var reviewResponse = await SessionMessageBusClient.instance
        ?.publishAndWaitForResponse(
            SessionStartPlayerCharacterReview(
              destination: SessionMessage.masterIdentifier,
            ),
          );
    if(!context.mounted) return false;
    if(reviewResponse == null) return false;

    if(reviewResponse.status != SessionMessageResponseStatus.accepted) {
      // TODO: display a nice message?
      return false;
    }

    var selectedCharacters = (reviewResponse.data as List<PlayerCharacter>?);
    if(selectedCharacters == null || selectedCharacters.isEmpty) {
      // TODO: display a nice message?
      return false;
    }

    session.encounter.value = await scenarioEncounter.instantiate(
      characters: selectedCharacters,
    );

    if(mapResult.map != null) {
      mapResult.map!.encounter = session.encounter.value;
      session.board.push(mapResult.map!);
    }

    return true;
  }
}

class _SelectMapDialogResult {
  const _SelectMapDialogResult({ this.reference, this.map });

  final String? reference;
  final SessionBoardItemMap? map;
}

class _SelectMapDialog extends StatefulWidget {
  const _SelectMapDialog({ required this.board });

  final SessionGameBoard board;

  @override
  State<_SelectMapDialog> createState() => _SelectMapDialogState();
}

class _SelectMapDialogState extends State<_SelectMapDialog> {
  bool useBoardMap = false;
  _SelectMapDialogResult? result;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélectionner la carte de la rencontre'),
      content: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,
            children: [
              Row(
                spacing: 12.0,
                children: [
                  Switch(
                    value: useBoardMap,
                    onChanged: (bool v) {
                      setState(() {
                        useBoardMap = v;
                        result = null;
                      });
                    },
                  ),
                  const Text('Utiliser une carte du plateau'),
                ],
              ),
              if(useBoardMap)
                DropdownMenu<String>(
                  requestFocusOnTap: true,
                  label: const Text('Nom de la carte'),
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(),
                  ),
                  expandedInsets: EdgeInsets.zero,
                  dropdownMenuEntries: widget.board
                    .whereType<SessionBoardItemMap>()
                    .map((SessionBoardItem i) => DropdownMenuEntry(value: i.title, label: i.title))
                    .toList(),
                  onSelected: (String? ref) {
                    setState(() {
                      if(ref == null) {
                        result = null;
                      }
                      else {
                        result = _SelectMapDialogResult(reference: ref);
                      }
                    });
                  }
                ),
              if(!useBoardMap)
                SessionBoardItemPickerWidget(
                  onItemPicked: (SessionBoardItem? i) {
                    if(i is SessionBoardItemMap) {
                      setState(() {
                        result = _SelectMapDialogResult(map: i);
                      });
                    }
                    else {
                      setState(() {
                        result = null;
                      });
                    }
                  },
                  isMap: true,
                ),
            ],
          )
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: result == null ? null : () {
            Navigator.of(context, rootNavigator: true).pop(result);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
        ),
      ]
    );
  }
}