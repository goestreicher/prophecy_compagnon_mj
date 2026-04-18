import 'dart:math';

import 'package:flutter/material.dart';

import '../../../classes/calendar.dart';
import 'enums.dart';
import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataAugure extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataAugure()
    : super(title: 'Augure');

  Augure? augure;
  Augure? currentAugure;

  @override
  Widget overviewWidget(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Augure : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: augure!.title,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Caractère : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: augurePlayerCharacterInfluences[augure]![AugurePlayerCharacterInfluencesType.character]!,
                style: theme.textTheme.bodyMedium,
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Motivation : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: augurePlayerCharacterInfluences[augure]![AugurePlayerCharacterInfluencesType.motivation]!,
                style: theme.textTheme.bodyMedium,
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Qualité : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: augurePlayerCharacterInfluences[augure]![AugurePlayerCharacterInfluencesType.quality]!,
                style: theme.textTheme.bodyMedium,
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Défault : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: augurePlayerCharacterInfluences[augure]![AugurePlayerCharacterInfluencesType.fault]!,
                style: theme.textTheme.bodyMedium,
              ),
            ]
          )
        ),
      ],
    );
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    return [sliverWrap([Column(
      spacing: 16.0,
      children: [
        Text(
          "À la façon des signes du zodiaque, tous les personnages de Prophecy naissent sous un Augure, majoritairement lié à l’un des neuf Grands Dragons. Ils définissent certaines des orientations du personnage et donnent une petite idée de la façon dont celui-ci va aborder les événements de sa vie. Les renseignements que donnent les Augures n’ont rien de rigide ou d’obligatoire. Ils déterminent les grandes lignes de son caractère, de ses motivations et de ses préférences."
        ),
        _AugureSelectionWidget(
          augure: currentAugure ?? augure,
          onSelected: (Augure a) {
            currentAugure = a;
            changed = currentAugure != augure;
          },
        )
      ],
    )])];
  }

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) => currentAugure != null;

  @override
  void init(PlayerCharacterWizardModel model) {
  }
  
  @override
  void reset(PlayerCharacterWizardModel model) {
    augure = null;
    currentAugure = null;
    model.augure = null;
  }
  
  @override
  void clear() {
    currentAugure = augure;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    augure = currentAugure;
    model.augure = augure;
  }
}

class _AugureSelectionWidget extends StatefulWidget {
  const _AugureSelectionWidget({
    this.augure,
    required this.onSelected
  });

  final Augure? augure;
  final void Function(Augure) onSelected;

  @override
  State<_AugureSelectionWidget> createState() => _AugureSelectionWidgetState();
}

class _AugureSelectionWidgetState extends State<_AugureSelectionWidget> {
  Augure? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.augure;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var rows = <TableRow>[];
    for(var (index, augure) in augurePlayerCharacterInfluences.keys.indexed) {
      var bgColor = index % 2 == 1
          ? theme.colorScheme.surfaceContainerHigh
          : theme.colorScheme.surfaceContainerLowest;
      Color? textColor;
      if(selected == augure) {
        bgColor = theme.colorScheme.primary;
        textColor = theme.colorScheme.onPrimary;
      }

      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: bgColor,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                augure.title,
                style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                augurePlayerCharacterInfluences[augure]![AugurePlayerCharacterInfluencesType.character]!,
                style: theme.textTheme.bodyMedium!
                  .copyWith(color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                augurePlayerCharacterInfluences[augure]![AugurePlayerCharacterInfluencesType.motivation]!,
                style: theme.textTheme.bodyMedium!
                  .copyWith(color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                augurePlayerCharacterInfluences[augure]![AugurePlayerCharacterInfluencesType.quality]!,
                style: theme.textTheme.bodyMedium!
                  .copyWith(color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                augurePlayerCharacterInfluences[augure]![AugurePlayerCharacterInfluencesType.fault]!,
                style: theme.textTheme.bodyMedium!
                  .copyWith(color: textColor),
              ),
            ),
          ]
        )
      );
    }

    return Column(
      spacing: 24.0,
      children: [
        Table(
          border: TableBorder(
            left: BorderSide(width: 1.0, color: Colors.black38),
            top: BorderSide(width: 1.0, color: Colors.black38),
            right: BorderSide(width: 1.0, color: Colors.black38),
            bottom: BorderSide(width: 1.0, color: Colors.black38),
          ),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Augure',
                    style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Caractère',
                    style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Motivation',
                    style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Qualité',
                    style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Défaut',
                    style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ...rows,
          ],
        ),
        ElevatedButton(
          onPressed: selected != null ? null : () {
            var idx = Random().nextInt(10);
            setState(() {
              selected = augurePlayerCharacterInfluences.keys.toList()[idx];
              widget.onSelected(selected!);
            });
          },
          child: Text("Tirer l'Augure de départ")
        )
      ],
    );
  }
}