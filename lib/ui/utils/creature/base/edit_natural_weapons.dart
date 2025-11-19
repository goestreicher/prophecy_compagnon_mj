import 'package:flutter/material.dart';

import '../../../../classes/combat.dart';
import '../../../../classes/creature.dart';
import '../../../../classes/entity/abilities.dart';
import '../../../../classes/entity/base.dart';
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
            Expanded(
              child: NaturalWeaponDisplayWidget(
                weapon: weapon,
              ),
            ),
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
  final TextEditingController capabilityController = TextEditingController();

  int skill = 0;
  AttributeBasedCalculator damage = AttributeBasedCalculator(static: 0);
  final Map<WeaponRange, NaturalWeaponModelRangeSpecification> ranges =
      <WeaponRange, NaturalWeaponModelRangeSpecification>{};

  @override
  void initState() {
    super.initState();

    if(widget.source != null) {
      nameController.text = widget.source!.name;
      if(widget.source!.special != null) {
        capabilityController.text = widget.source!.special!;
      }
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
              ],
            ),
            _NaturalWeaponDamageEditWidget(
              damage: damage,
              onChanged: (AttributeBasedCalculator d) {
                setState(() {
                  damage = d;
                });
              },
            ),
            TextField(
              controller: capabilityController,
              decoration: InputDecoration(
                label: const Text('Capacité'),
                labelStyle: theme.textTheme.labelSmall,
                floatingLabelStyle: theme.textTheme.labelLarge,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(12.0),
                error: null,
                errorText: null,
                isDense: true,
              ),
              style: theme.textTheme.bodySmall,
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
              special: capabilityController.text.isEmpty
                ? null
                : capabilityController.text,
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

enum _NaturalWeaponDamageType {
  static,
  ability,
}

class _NaturalWeaponDamageEditWidget extends StatefulWidget {
  const _NaturalWeaponDamageEditWidget({ this.damage, required this.onChanged });

  final AttributeBasedCalculator? damage;
  final void Function(AttributeBasedCalculator) onChanged;

  @override
  State<_NaturalWeaponDamageEditWidget> createState() => _NaturalWeaponDamageEditWidgetState();
}

class _NaturalWeaponDamageEditWidgetState extends State<_NaturalWeaponDamageEditWidget> {
  _NaturalWeaponDamageType type = _NaturalWeaponDamageType.static;
  late AttributeBasedCalculator damage;

  @override
  void initState() {
    super.initState();

    if(widget.damage == null) {
      damage = AttributeBasedCalculator(static: 0.0);
    }
    else {
      if(widget.damage!.ability != null) {
        type = _NaturalWeaponDamageType.ability;
      }

      damage = AttributeBasedCalculator(
        static: widget.damage!.static,
        ability: widget.damage!.ability,
        multiply: widget.damage!.multiply,
        add: widget.damage!.add,
        dice: widget.damage!.dice,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 12.0,
      children: [
        Text(
          'Dégats :',
          style: theme.textTheme.bodySmall,
        ),
        DropdownMenu(
          initialSelection: type,
          requestFocusOnTap: true,
          label: const Text('Type'),
          textStyle: theme.textTheme.bodySmall,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            isCollapsed: true,
            constraints: BoxConstraints(maxHeight: 36.0),
            contentPadding: EdgeInsets.all(12.0),
          ),
          dropdownMenuEntries: [
            DropdownMenuEntry(value: _NaturalWeaponDamageType.static, label: 'Statique'),
            DropdownMenuEntry(value: _NaturalWeaponDamageType.ability, label: 'Attribut'),
          ],
          onSelected: (_NaturalWeaponDamageType? t) {
            if(t == null) return;

            if(t == _NaturalWeaponDamageType.static && type == _NaturalWeaponDamageType.ability) {
              damage = AttributeBasedCalculator(static: 0.0);
              widget.onChanged(damage);
            }
            else if(t == _NaturalWeaponDamageType.ability && type == _NaturalWeaponDamageType.static) {
              damage = AttributeBasedCalculator(ability: Ability.force);
              widget.onChanged(damage);
            }

            setState(() {
              type = t;
            });
          },
        ),
        if(type == _NaturalWeaponDamageType.static)
          SizedBox(
            width: 70,
            child: NumIntInputWidget(
              label: 'Dégats',
              initialValue: damage.static?.floor() ?? 0,
              minValue: 0,
              maxValue: 9999,
              onChanged: (int value) {
                damage = AttributeBasedCalculator(
                  static: value.toDouble(),
                  dice: damage.dice,
                );
                widget.onChanged(damage);
              },
            ),
          ),
        if(type == _NaturalWeaponDamageType.ability)
          _NaturalWeaponAttributeDamageEditWidget(
            damage: damage,
            onAbilityChanged: (Ability a) {
              setState(() {
                damage = AttributeBasedCalculator(
                  ability: a,
                  multiply: damage.multiply,
                  add: damage.add,
                  dice: damage.dice,
                );
              });
              widget.onChanged(damage);
            },
            onMultiplyChanged: (int value) {
              setState(() {
                damage = AttributeBasedCalculator(
                  ability: damage.ability,
                  multiply: value,
                  add: damage.add,
                  dice: damage.dice,
                );
              });
              widget.onChanged(damage);
            },
            onAddChanged: (int value) {
              setState(() {
                damage = AttributeBasedCalculator(
                  ability: damage.ability,
                  multiply: damage.multiply,
                  add: value,
                  dice: damage.dice,
                );
              });
              widget.onChanged(damage);
            },
          ),
        Text('+'),
        SizedBox(
          width: 70,
          child: NumIntInputWidget(
            initialValue: 0,
            minValue: 0,
            maxValue: 9999,
            onChanged: (int value) {
              setState(() {
                damage = AttributeBasedCalculator(
                  static: damage.static,
                  ability: damage.ability,
                  multiply: damage.multiply,
                  add: damage.add,
                  dice: value,
                );
              });
              widget.onChanged(damage);
            },
          ),
        ),
        Text('D10'),
      ],
    );
  }
}

class _NaturalWeaponAttributeDamageEditWidget extends StatefulWidget {
  const _NaturalWeaponAttributeDamageEditWidget({
    required this.damage,
    required this.onAbilityChanged,
    required this.onMultiplyChanged,
    required this.onAddChanged,
  });

  final AttributeBasedCalculator damage;
  final void Function(Ability) onAbilityChanged;
  final void Function(int) onMultiplyChanged;
  final void Function(int) onAddChanged;

  @override
  State<_NaturalWeaponAttributeDamageEditWidget> createState() => _NaturalWeaponAttributeDamageEditWidgetState();
}

class _NaturalWeaponAttributeDamageEditWidgetState extends State<_NaturalWeaponAttributeDamageEditWidget> {
  late Ability ability;
  late int multiply;
  late int add;

  @override
  void initState() {
    super.initState();

    ability = widget.damage.ability!;
    multiply = widget.damage.multiply;
    add = widget.damage.add;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 12.0,
      children: [
        DropdownMenu(
          initialSelection: widget.damage.ability!,
          requestFocusOnTap: true,
          textStyle: theme.textTheme.bodySmall,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            isCollapsed: true,
            constraints: BoxConstraints(maxHeight: 36.0),
            contentPadding: EdgeInsets.all(12.0),
          ),
          dropdownMenuEntries: Ability.values
            .map((Ability a) => DropdownMenuEntry(value: a, label: a.short))
            .toList(),
          onSelected: (Ability? a) {
            if(a == null) return;
            widget.onAbilityChanged(a);
          },
        ),
        Text('x'),
        SizedBox(
          width: 70,
          child: NumIntInputWidget(
            initialValue: multiply,
            minValue: 1,
            maxValue: 10,
            onChanged: (int value) => widget.onMultiplyChanged(value),
          ),
        ),
        Text('+'),
        SizedBox(
          width: 70,
          child: NumIntInputWidget(
            initialValue: add,
            minValue: 0,
            maxValue: 9999,
            onChanged: (int value) => widget.onAddChanged(value),
          ),
        ),
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
            onChanged: (double value) {
              widget.onEffectiveDistanceChanged(value);
              if(widget.range != WeaponRange.ranged) {
                widget.onMaximumDistanceChanged(value);
              }
            },
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