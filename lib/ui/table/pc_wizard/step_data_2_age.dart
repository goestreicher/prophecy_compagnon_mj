import 'package:flutter/material.dart';

import 'enums.dart';
import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataAge extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataAge()
    : super(title: "Âge");

  PlayerCharacterWizardAge? age;
  PlayerCharacterWizardAge? currentAge;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    return Text(age!.title);
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    return [sliverWrap([Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Text(
            "L'âge joue un rôle majeur dans le processus de création d’un personnage. Le système de Prophecy utilise l’âge pour accentuer les qualités et les défauts naturels de chaque personnage. Ainsi, un enfant sera souvent plus souple qu’un adulte, mais nettement moins compétent, car il aura eu moins de temps pour développer ses connaissances.\n\nEn termes de jeu, l’âge détermine un certain nombre de bonus et de malus qui viendront modifier les chiffres définissant les Caractéristiques, les Attributs ou les Compétences du personnage. Le choix de la tranche d'âge est donc très important.\n\nCinq tranches d’âge vous sont proposées : enfant, adolescent, adulte, ancien et vénérable.\n\nIl est important de préciser que les anciens et les vénérables, pour compenser leurs désavantages physiques, disposent d’un atout relativement important. Au moment de choisir leur caste (cf. plus loin), ils peuvent débuter l’aventure avec le deuxième Statut de celle-ci s’ils satisfont à toutes les conditions requises. Les différents niveaux d’évolution au sein d’une caste sont en effet liés aux Points de Compétence que les personnages ont accumulés, et seuls les personnages anciens ou vénérables ont une chance de disposer d'assez de points pour prétendre à un rang plus élevé que celui d’Apprenti (qui correspond au premier Statut). À l'opposé, les enfants, n'ayant qu’une courte expérience de la vie (et donc moins de Points de Compétence), disposeront d’un Autre avantage : celui d’éventuellement récupérer plus vite leurs Points de Chance (cf. Avantages)."
          ),
          _AgeSelectionWidget(
            age: currentAge ?? age,
            onSelected: (PlayerCharacterWizardAge a) {
              currentAge = a;
              changed = currentAge != age;
            },
          )
        ],
      ),
    )])];
  }

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) => formKey.currentState!.validate();

  @override
  void init(PlayerCharacterWizardModel model) {
  }
  
  @override
  void reset(PlayerCharacterWizardModel model) {
    age = null;
    currentAge = null;
    model.age = null;
  }

  @override
  void clear() {
    currentAge = age;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    age = currentAge;
    model.age = age;
  }
}

class _AgeSelectionWidget extends StatefulWidget {
  const _AgeSelectionWidget({
    this.age,
    required this.onSelected
  });

  final PlayerCharacterWizardAge? age;
  final void Function(PlayerCharacterWizardAge) onSelected;

  @override
  State<_AgeSelectionWidget> createState() => _AgeSelectionWidgetState();
}

class _AgeSelectionWidgetState extends State<_AgeSelectionWidget> {
  PlayerCharacterWizardAge? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.age;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: DropdownMenuFormField(
        initialSelection: selected,
        requestFocusOnTap: true,
        label: const Text('Âge'),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        expandedInsets: EdgeInsets.zero,
        dropdownMenuEntries: PlayerCharacterWizardAge.values
          .map(
            (PlayerCharacterWizardAge a) => DropdownMenuEntry(value: a, label: a.title),
          )
          .toList(),
        validator: (PlayerCharacterWizardAge? a) {
          if(a == null) return 'Valeur manquante';
          return null;
        },
        onSelected: (PlayerCharacterWizardAge? a) {
          if(a == null) return;
          widget.onSelected(a);
        },
      ),
    );
  }
}