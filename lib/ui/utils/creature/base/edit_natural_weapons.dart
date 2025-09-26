import 'package:flutter/material.dart';

import '../../../../classes/combat.dart';
import '../../../../classes/creature.dart';
import '../../character_digit_input_widget.dart';
import '../../widget_group_container.dart';

class CreatureEditNaturalWeapons extends StatefulWidget {
  const CreatureEditNaturalWeapons({ super.key, required this.creature });
  
  final Creature creature;

  @override
  State<CreatureEditNaturalWeapons> createState() => _CreatureEditNaturalWeaponsState();
}

class _CreatureEditNaturalWeaponsState extends State<CreatureEditNaturalWeapons> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];
    for(var (index, nw) in widget.creature.naturalWeapons.indexed) {
      widgets.add(_NaturalWeaponEditWidget(
        key: UniqueKey(),
        weapon: nw,
        onDelete: () =>
            setState(() {
              widget.creature.naturalWeapons.removeAt(index);
            }),
      ));
    }

    return WidgetGroupContainer(
      title: Text(
        'Armes naturelles',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: Center(
        //alignment: AlignmentGeometry.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.0,
          children: [
            ...widgets,
            ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                size: 16.0,
              ),
              style: ElevatedButton.styleFrom(
                textStyle: theme.textTheme.bodySmall,
              ),
              label: const Text('Nouvelle arme naturelle'),
              onPressed: () async {
                NaturalWeaponModel? weapon = await showDialog(
                  context: context,
                  builder: (BuildContext context) => _NaturalWeaponCreateDialog(),
                );
                if(weapon == null) return;
                setState(() {
                  widget.creature.naturalWeapons.add(weapon);
                });
              },
            ),
          ],
        ),
      )
    );
  }
}

class _NaturalWeaponEditWidget extends StatefulWidget {
  const _NaturalWeaponEditWidget({
    super.key,
    required this.weapon,
    required this.onDelete,
  });

  final NaturalWeaponModel weapon;
  final void Function() onDelete;

  @override
  State<_NaturalWeaponEditWidget> createState() => _NaturalWeaponEditWidgetState();
}

class _NaturalWeaponEditWidgetState extends State<_NaturalWeaponEditWidget> {
  final TextEditingController nameController = TextEditingController();
  late int currentSkill;
  late int currentDamage;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.weapon.name;
    currentSkill = widget.weapon.skill;
    currentDamage = widget.weapon.damage;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        Expanded(
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              label: const Text('Nom'),
              labelStyle: theme.textTheme.labelSmall,
              floatingLabelStyle: theme.textTheme.labelLarge,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(12.0),
              error: null,
              errorText: null,
              isDense: true,
            ),
            style: theme.textTheme.bodySmall,
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return 'Valeur manquante';
              }
              return null;
            },
          ),
        ),
        SizedBox(
          width: 90,
          child: CharacterDigitInputWidget(
            label: 'Compétence',
            initialValue: currentSkill,
            minValue: 1,
            maxValue: 30,
            onChanged: (int value) {
              widget.weapon.skill = value;
            },
          )
        ),
        SizedBox(
          width: 90,
          child: CharacterDigitInputWidget(
            label: 'Dégats',
            initialValue: currentDamage,
            minValue: 1,
            maxValue: 9999,
            onChanged: (int value) {
              widget.weapon.damage = value;
            },
          )
        ),
        // TODO: add range management
        IconButton(
          style: IconButton.styleFrom(
            iconSize: 16.0,
          ),
          padding: const EdgeInsets.all(8.0),
          constraints: const BoxConstraints(),
          onPressed: () => widget.onDelete(),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}

class _NaturalWeaponCreateDialog extends StatefulWidget {
  const _NaturalWeaponCreateDialog();

  @override
  State<_NaturalWeaponCreateDialog> createState() => _NaturalWeaponCreateDialogState();
}

class _NaturalWeaponCreateDialogState extends State<_NaturalWeaponCreateDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  int skill = 0;
  int damage = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle arme naturelle'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                label: const Text('Nom'),
                border: const OutlineInputBorder(),
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return 'Valeur manquante';
                }
                return null;
              },
            ),
            Row(
              spacing: 16.0,
              children: [
                Spacer(),
                SizedBox(
                  width: 90,
                  child: CharacterDigitInputWidget(
                    label: 'Compétence',
                    initialValue: 0,
                    minValue: 1,
                    maxValue: 30,
                    onChanged: (int value) => skill = value,
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: CharacterDigitInputWidget(
                    label: 'Dégats',
                    initialValue: 0,
                    minValue: 1,
                    maxValue: 9999,
                    onChanged: (int value) => damage = value,
                  ),
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            if(!_formKey.currentState!.validate()) return;
            var model = NaturalWeaponModel(
              name: nameController.text,
              skill: skill,
              damage: damage,
              // TODO: add range management
              ranges: {WeaponRange.contact: 0.0},
            );
            Navigator.of(context).pop(model);
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}