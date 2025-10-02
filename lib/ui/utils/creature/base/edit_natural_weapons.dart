import 'package:flutter/material.dart';

import '../../../../classes/combat.dart';
import '../../../../classes/creature.dart';
import '../../num_input_widget.dart';
import '../../widget_group_container.dart';
import 'display_natural_weapon_widget.dart';

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
        weapon: nw,
        onChanged: (NaturalWeaponModel w) => setState(() {
          widget.creature.naturalWeapons[index] = w;
        }),
        onDelete: () => setState(() {
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
                  builder: (BuildContext context) => _NaturalWeaponEditDialog(),
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

class _NaturalWeaponEditWidget extends StatelessWidget {
  const _NaturalWeaponEditWidget({
    required this.weapon,
    required this.onChanged,
    required this.onDelete,
  });

  final NaturalWeaponModel weapon;
  final void Function(NaturalWeaponModel) onChanged;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          spacing: 16.0,
          children: [
            NaturalWeaponDisplayWidget(
              weapon: weapon,
            ),
            Spacer(),
            IconButton(
              style: IconButton.styleFrom(
                iconSize: 24.0,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(),
              onPressed: () async {
                NaturalWeaponModel? model = await showDialog(
                  context: context,
                  builder: (BuildContext context) => _NaturalWeaponEditDialog(
                    source: weapon,
                  ),
                );
                if(model == null) return;
                onChanged(model);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              style: IconButton.styleFrom(
                iconSize: 24.0,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(),
              onPressed: () => onDelete(),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class _NaturalWeaponEditDialog extends StatefulWidget {
  const _NaturalWeaponEditDialog({ this.source });

  final NaturalWeaponModel? source;

  @override
  State<_NaturalWeaponEditDialog> createState() => _NaturalWeaponEditDialogState();
}

class _NaturalWeaponEditDialogState extends State<_NaturalWeaponEditDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  int skill = 0;
  int damage = 0;
  final Map<WeaponRange, NaturalWeaponModelRangeSpecification> ranges =
      <WeaponRange, NaturalWeaponModelRangeSpecification>{};

  @override
  void initState() {
    super.initState();

    if(widget.source != null) {
      nameController.text = widget.source!.name;
      skill = widget.source!.skill;
      damage = widget.source!.damage;
      for(var r in widget.source!.ranges.keys) {
        ranges[r] = NaturalWeaponModelRangeSpecification(
          initiative: widget.source!.ranges[r]!.initiative,
          effectiveDistance: widget.source!.ranges[r]!.effectiveDistance,
          maximumDistance: widget.source!.ranges[r]!.maximumDistance,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var rangeWidgets = <Widget>[];
    for(var r in WeaponRange.values) {
      rangeWidgets.add(
        _NaturalWeaponRangeEditWidget(
          enabled: ranges.containsKey(r),
          range: r,
          specification: ranges[r],
          onEnableChanged: (bool enabled) {
            setState(() {
              if(enabled) {
                ranges[r] = NaturalWeaponModelRangeSpecification(
                  initiative: 0,
                  effectiveDistance: 0.0,
                  maximumDistance: 0.0,
                );
              }
              else {
                ranges.remove(r);
              }
            });
          },
          onInitiativeChanged: (int initiative) {
            if(!ranges.containsKey(r)) return;
            ranges[r]!.initiative = initiative;
          },
          onEffectiveDistanceChanged: (double distance) {
            if(!ranges.containsKey(r)) return;
            ranges[r]!.effectiveDistance = distance;
          },
          onMaximumDistanceChanged: (double distance) {
            if(!ranges.containsKey(r)) return;
            ranges[r]!.maximumDistance = distance;
          },
        )
      );
    }

    return AlertDialog(
      title: const Text('Éditer une arme naturelle'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            Row(
              spacing: 12.0,
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
                  child: NumIntInputWidget(
                    label: 'Compétence',
                    initialValue: skill,
                    minValue: 1,
                    maxValue: 30,
                    onChanged: (int value) => skill = value,
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: NumIntInputWidget(
                    label: 'Dégats',
                    initialValue: damage,
                    minValue: 1,
                    maxValue: 9999,
                    onChanged: (int value) => damage = value,
                  ),
                ),
              ],
            ),
            ...rangeWidgets,
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: ranges.isEmpty ? null : () {
            if(!formKey.currentState!.validate()) return;
            var model = NaturalWeaponModel(
              name: nameController.text,
              skill: skill,
              damage: damage,
              ranges: ranges,
            );
            Navigator.of(context).pop(model);
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}

class _NaturalWeaponRangeEditWidget extends StatefulWidget {
  const _NaturalWeaponRangeEditWidget({
    required this.enabled,
    required this.range,
    this.specification,
    required this.onEnableChanged,
    required this.onInitiativeChanged,
    required this.onEffectiveDistanceChanged,
    required this.onMaximumDistanceChanged,
  });

  final bool enabled;
  final WeaponRange range;
  final NaturalWeaponModelRangeSpecification? specification;
  final void Function(bool) onEnableChanged;
  final void Function(int) onInitiativeChanged;
  final void Function(double) onEffectiveDistanceChanged;
  final void Function(double) onMaximumDistanceChanged;

  @override
  State<_NaturalWeaponRangeEditWidget> createState() => _NaturalWeaponRangeEditWidgetState();
}

class _NaturalWeaponRangeEditWidgetState extends State<_NaturalWeaponRangeEditWidget> {
  late bool enabled;

  @override
  void initState() {
    super.initState();

    enabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 12.0,
      children: [
        Switch(
          value: enabled,
          onChanged: (bool v) {
            setState(() {
              enabled = v;
            });
            widget.onEnableChanged(v);
          },
        ),
        SizedBox(
          width: 90,
          child: Text(
            widget.range.title,
            style: theme.textTheme.bodySmall,
          ),
        ),
        SizedBox(
          width: 70,
          child: NumIntInputWidget(
            enabled: enabled,
            label: 'Initiative',
            initialValue: widget.specification?.initiative ?? 0,
            minValue: -20,
            maxValue: 20,
            onChanged: (int value) => widget.onInitiativeChanged(value),
          ),
        ),
        if(widget.range != WeaponRange.contact)
          SizedBox(
            width: 90,
            child: NumDoubleInputWidget(
              enabled: enabled,
              label: widget.range == WeaponRange.ranged
                ? 'Distance Eff.'
                : 'Distance',
              initialValue: widget.specification?.effectiveDistance ?? 0.0,
              minValue: 0.0,
              maxValue: 9999.0,
              onChanged: (double value) => widget.onEffectiveDistanceChanged(value),
            ),
          ),
        if(widget.range == WeaponRange.ranged)
          SizedBox(
            width: 90,
            child: NumDoubleInputWidget(
              enabled: enabled,
              label: 'Distance Max.',
              initialValue: widget.specification?.maximumDistance ?? 0.0,
              minValue: 0.0,
              maxValue: 99999.0,
              onChanged: (double value) => widget.onMaximumDistanceChanged(value),
            ),
          ),
      ],
    );
  }
}