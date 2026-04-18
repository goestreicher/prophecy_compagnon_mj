import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/player_character.dart';
import '../../utils/character/display_widget.dart';
import 'finalize.dart';
import 'model.dart';
import 'stepper.dart';

class PlayerCharacterWizardCurrentStep extends StatefulWidget {
  const PlayerCharacterWizardCurrentStep({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  final void Function() onCancel;
  final void Function(PlayerCharacter) onSave;

  @override
  State<PlayerCharacterWizardCurrentStep> createState() => _PlayerCharacterWizardCurrentStepState();
}

class _PlayerCharacterWizardCurrentStepState extends State<PlayerCharacterWizardCurrentStep> {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<PlayerCharacterWizardModel>();
    var stepper = context.watch<PlayerCharacterWizardStepper>();
    var step = stepper.steps[stepper.currentStep];

    return CustomScrollView(
      slivers: <Widget>[
        ...step.stepWidget(context),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 12.0,
                  children: [
                    TextButton(
                      onPressed: () => widget.onCancel(),
                      child: Text('Annuler')
                    ),
                    SizedBox(width: 16.0),
                    TextButton(
                      onPressed: stepper.currentStep == 0 ? null : () {
                        stepper.currentStep -= 1;
                      },
                      child: Text('Précédent'),
                    ),
                    if(step.canSkip)
                      TextButton(
                        onPressed: () {
                          step.save(model);
                          stepper.currentStep += 1;
                        },
                        child: Text('Passer'),
                      ),
                    FilledButton(
                      onPressed: () async {
                        var status = step.validate(model, context);
                        if(!step.canSkip && !status) return;

                        bool hasNextCompleted = false;
                        for(var s in stepper.steps.getRange(stepper.currentStep, stepper.steps.length)) {
                          if(s.completed) {
                            hasNextCompleted = true;
                            break;
                          }
                        }
                        if(step.changed && step.clearNextOnChange && hasNextCompleted) {
                          var confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmer les modifications"),
                                content: SizedBox(
                                  width: 300,
                                  child: Text(
                                    "Les changements sur cette page vont supprimer les renseignements des pages suivantes. Voulez-vous continuer ?"
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop(true);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            }
                          );

                          if(!context.mounted) return;
                          if(confirm == null || !confirm) return;

                          for(var s in stepper.steps.getRange(stepper.currentStep+1, stepper.steps.length)) {
                            s.reset(model);
                            s.completed = false;
                            s.changed = false;
                          }
                        }

                        step.save(model);
                        step.completed = true;
                        step.changed = false;

                        if(stepper.currentStep == stepper.steps.length - 1) {
                          var error = validateFinalize(model);

                          if(error != null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Problème pour finaliser le personnage"),
                                  content: SizedBox(
                                    width: 800,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 12.0,
                                        children: [
                                          Text(
                                            "Cette erreur empêche de finaliser le personnage :"
                                          ),
                                          Text(
                                            error,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                );
                              }
                            );
                          }
                          else {
                            var pc = playerCharacterWizardFinalize(model);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(model.characterName!),
                                  content: SizedBox(
                                    width: 900,
                                    child: SingleChildScrollView(
                                      child: CharacterDisplayWidget(character: pc),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                                      child: const Text("J'ai encore des modifications"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        widget.onSave(pc);
                                        Navigator.of(context, rootNavigator: true).pop();
                                      },
                                      child: const Text("C'est tout bon pour moi"),
                                    ),
                                  ],
                                );
                              }
                            );
                          }
                        }
                        else {
                          if(!stepper.steps[stepper.currentStep+1].completed) {
                            stepper.steps[stepper.currentStep + 1].init(model);
                          }
                          stepper.currentStep += 1;
                        }
                      },
                      child: Text(
                        stepper.currentStep == stepper.steps.length - 1
                          ? 'Terminer'
                          : 'Suivant'
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}