import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../classes/player_character.dart';
import '../../classes/table.dart';
import 'pc_wizard/current_step.dart';
import 'pc_wizard/model.dart';
import 'pc_wizard/progress_overview.dart';
import 'pc_wizard/stepper.dart';

class PlayerCharacterWizard extends StatelessWidget {
  const PlayerCharacterWizard({
    super.key,
    required this.tableUuid,
  });

  final String tableUuid;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Material(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PlayerCharacterWizardModel()),
          ChangeNotifierProvider(create: (_) => PlayerCharacterWizardStepper()),
        ],
        child: ColoredBox(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: PlayerCharacterWizardProgressOverview(),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                    child: PlayerCharacterWizardCurrentStep(
                      onCancel: () {
                        context.go('/tables/$tableUuid');
                      },
                      onSave: (PlayerCharacter pc) async {
                        var table = await GameTableStore().get(tableUuid);
                        if(table == null) {
                          if(!context.mounted) return;
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Impossible de charger la table"),
                                content: SizedBox(
                                  width: 450,
                                  child: Text(
                                    "Erreur en sauvegardant le personnage.\nVous allez télécharger le résultat de l'assistant pour l'importer plus tard.",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      var jsonFull = pc.toJson();
                                      var jsonStr = json.encode(jsonFull);
                                      await FilePicker.saveFile(
                                        fileName: 'pc_${pc.uuid}.json',
                                        bytes: utf8.encode(jsonStr),
                                      );
                                      if(!context.mounted) return;
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                    child: const Text("Télécharger"),
                                  ),
                                ]
                              );
                            }
                          );
                        }
                        else {
                          table.loadPlayers();
                          await PlayerCharacterStore().save(pc);
                          table.playerSummaries.add(pc.summary);
                          await GameTableStore().save(table);
                          if(!context.mounted) return;
                          context.go(
                            '/tables/$tableUuid',
                          );
                        }
                      }
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}