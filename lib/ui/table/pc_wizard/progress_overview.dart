import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'step_data.dart';
import 'stepper.dart';

class PlayerCharacterWizardProgressOverview extends StatelessWidget {
  const PlayerCharacterWizardProgressOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var stepper = context.watch<PlayerCharacterWizardStepper>();

    var children = <Widget>[];
    for(var (index, step) in stepper.steps.indexed) {
      children.addAll([
        _StepOverviewWidget(
          index: index,
          stepData: step,
          isCurrent: index == stepper.currentStep,
        ),
        Divider(),
      ]);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Divider(),
          ...children,
        ],
      ),
    );
  }
}

class _StepOverviewWidget extends StatelessWidget {
  const _StepOverviewWidget({
    required this.index,
    required this.stepData,
    this.isCurrent = false,
  });

  final int index;
  final PlayerCharacterWizardStepData stepData;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var stepper = context.watch<PlayerCharacterWizardStepper>();

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.0,
          children: [
            Row(
              spacing: 12,
              children: [
                if(isCurrent)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                if(!isCurrent)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: stepData.completed ? theme.colorScheme.secondary : Colors.black26,
                      borderRadius: BorderRadius.circular(48.0),
                    ),
                    child: Center(
                      child: Text(
                        (index+1).toString(),
                        style: theme.textTheme.bodySmall!
                          .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                Text(
                  stepData.title,
                  style: theme.textTheme.titleLarge!
                    .copyWith(
                      fontWeight: FontWeight.bold,
                      color: stepData.completed || isCurrent ? null : Colors.black26,
                    ),
                ),
              ],
            ),
            if(stepper.currentStep > index)
              stepData.overviewWidget(context),
          ],
        )
      ],
    );
  }
}