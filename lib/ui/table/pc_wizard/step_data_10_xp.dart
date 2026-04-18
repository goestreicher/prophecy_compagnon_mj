import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'enums.dart';
import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataXP extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataXP({
    this.additionalBaseXp,
  })
      : super(title: "Points de Compétences")
  {
    currentAdditionalBaseXp = additionalBaseXp ?? 0;
  }

  int? additionalBaseXp;
  late int? currentAdditionalBaseXp;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    var model = context.read<PlayerCharacterWizardModel>();
    return Text(
      experienceLevels[model.additionalBaseXP] ?? "",
    );
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    return [sliverWrap([Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24.0,
        children: [
          Text("Le joueur reçoit un nombre de Points de Compétence qui dépend de son âge. Ces points sont utilisés pour développer des Compétences, augmenter les valeurs déjà attribuées, et surtout acheter les Privilèges de caste. Les mages et les différents utilisateurs de magie les utiliseront également pour acheter leurs sorts et pour augmenter leur Réserve de magie."),
          Text(
            "Points de Compétences liés à l'âge : ${model.baseXP}",
            style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
          ),
          Text("Si le meneur de jeu le désire, il peut décider de créer des personnages plus expérimentés que ceux obtenus par le système normal. Pour chaque degré d'expérience (qui correspond à un nombre de Points d'Expérience acquis avant de devenir un personnage, joueur) sont indiqués le nombre de Points de Compétences de base."),
          SizedBox(
            width: 250,
            child: DropdownMenuFormField(
              initialSelection: currentAdditionalBaseXp,
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              textStyle: theme.textTheme.bodySmall,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isCollapsed: true,
                constraints: BoxConstraints(maxHeight: 36.0),
                contentPadding: EdgeInsets.all(12.0),
              ),
              dropdownMenuEntries: experienceLevels.entries
                  .map((MapEntry<int, String> entry) =>
                      DropdownMenuEntry(value: entry.key, label: entry.value))
                  .toList(),
              onSelected: (int? v) {
                currentAdditionalBaseXp = v;
                changed = currentAdditionalBaseXp != additionalBaseXp;
              },
            ),
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
    currentAdditionalBaseXp = additionalBaseXp = null;
    model.additionalBaseXP = null;
  }

  @override
  void clear() {
    currentAdditionalBaseXp = additionalBaseXp;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    additionalBaseXp = currentAdditionalBaseXp;
    model.additionalBaseXP = additionalBaseXp;
  }
}