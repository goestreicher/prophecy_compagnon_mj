import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/entity/abilities.dart';
import '../../../classes/entity/attributes.dart';
import '../../../classes/entity/injury.dart';
import 'model.dart';
import 'step_data.dart';
import 'utils.dart';

class PlayerCharacterWizardStepDataAbilities extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataAbilities({
    Map<Ability, int>? abilities,
    this.transferFrom,
    this.transferTo,
  })
    : abilities = abilities ?? <Ability, int>{},
      currentAbilities = abilities ?? <Ability, int>{},
      super(title: 'Caractéristiques');

  Map<Ability, int> abilities;
  Map<Ability, int> currentAbilities;
  Ability? transferFrom;
  Ability? currentTransferFrom;
  Ability? transferTo;
  Ability? currentTransferTo;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();
    var abilitiesRows = [
      (Ability.force, Ability.resistance),
      (Ability.intelligence, Ability.volonte),
      (Ability.coordination, Ability.perception),
      (Ability.presence, Ability.empathie),
    ];
    var rows = <Widget>[];

    for(var (col1, col2) in abilitiesRows) {
      rows.add(
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                col1.short,
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20,
              child: Text(model.abilityComputedValue(col1).toString()),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 40,
              child: Text(
                col2.short,
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20,
              child: Text(model.abilityComputedValue(col2).toString()),
            ),
          ],
        )
      );
    }

    return Column(
      children: rows,
    );
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
            "L'âge de départ et la caste étant choisis, il faut maintenant déterminer le corps et l’esprit du personnage. Sa force physique, son intelligence, son adresse naturelle et sa beauté sont autant de renseignements qui sont regroupés ici sous le terme de “Caractéristiques”. Les personnages de Prophecy sont définis par huit Caractéristiques. Quatre sont liées au corps (Force, Résistance, Perception et Coordination), et quatre à l’esprit (Intelligence, Volonté, Empathie et Présence). Pour un être humain, leurs valeurs en termes de jeu seront comprises entre 1 et 10. La moyenne étani de 5, un score inférieur à 3 indiquera une Caractéristique très faible (signe de mauvaise santé ou de maladresse) et une valeur supérieure à 7, une Caractéristique très développée (signe de grande force physique ou de vivacité d'esprit).\nÀ la création, tous les joueurs bénéficient de huit valeurs qu’ils peuvent attribuer aux Caractéristiques de leur choix. Un joueur souhaitant créer un combattant a donc la possibilité de lui mettre la valeur la plus haute en Force plutôt qu’en Intelligence. Une fois réparties entre les huit Caractéristiques, ces valeurs de départ seront modifiées par la tranche d’âge du personnage. Un enfant, par exemple, aura un bonus en Empathie et un malus en Force."
          ),
          _AbilitiesEditWidget(
            abilities: currentAbilities,
            transferFrom: currentTransferFrom,
            transferTo: currentTransferTo,
            onAbilityChanged: (Ability a, int? v) {
              if(v == null) {
                currentAbilities.remove(a);
              }
              else {
                currentAbilities[a] = v;
              }
              changed = _checkChanged();
            },
            onTransferFromChanged: (Ability? a) {
              currentTransferFrom = a;
              changed = _checkChanged();
            },
            onTransferToChanged: (Ability? a) {
              currentTransferTo = a;
              changed = _checkChanged();
            },
          ),
        ],
      ),
    )])];
  }

  bool _checkChanged() {
    bool abilityChanged = false;
    for(var a in currentAbilities.keys) {
      if(!abilities.containsKey(a)) {
        abilityChanged = true;
        break;
      }
      if(abilities[a]! != currentAbilities[a]) {
        abilityChanged = true;
        break;
      }
    }

    return abilityChanged
        || currentTransferFrom != transferFrom
        || currentTransferTo != transferTo;
  }

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) => formKey.currentState!.validate();

  @override
  void init(PlayerCharacterWizardModel model) {
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    currentAbilities = abilities = <Ability, int>{};
    model.abilities = null;

    currentTransferFrom = transferFrom = null;
    model.abilityTransferFrom = null;

    currentTransferTo = transferTo = null;
    model.abilityTransferTo = null;
  }

  @override
  void clear() {
    currentAbilities = Map.from(abilities);
    currentTransferFrom = transferFrom;
    currentTransferTo = transferTo;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    abilities = currentAbilities;
    currentAbilities = Map.from(abilities);
    model.abilities = abilities;

    transferFrom = currentTransferFrom;
    model.abilityTransferFrom = transferFrom;

    transferTo = currentTransferTo;
    model.abilityTransferTo = transferTo;
  }
}

class _AbilitiesEditWidget extends StatefulWidget {
  const _AbilitiesEditWidget({
    this.abilities,
    this.transferFrom,
    this.transferTo,
    required this.onAbilityChanged,
    required this.onTransferFromChanged,
    required this.onTransferToChanged,
  });

  final Map<Ability, int>? abilities;
  final Ability? transferFrom;
  final Ability? transferTo;
  final void Function(Ability, int?) onAbilityChanged;
  final void Function(Ability?) onTransferFromChanged;
  final void Function(Ability?) onTransferToChanged;

  @override
  State<_AbilitiesEditWidget> createState() => _AbilitiesEditWidgetState();
}

class _AbilitiesEditWidgetState extends State<_AbilitiesEditWidget> {
  Map<Ability, int> selected = <Ability, int>{};
  Map<int, int> availableValues = <int, int>{
    7: 1,
    6: 2,
    5: 2,
    4: 2,
    3: 1,
  };
  Ability? selectedTransferFrom;
  Ability? selectedTransferTo;

  @override
  void initState() {
    super.initState();

    for(var ability in (widget.abilities?.keys ?? <Ability>[])) {
      var value = widget.abilities![ability]!;
      if((availableValues[value] ?? 0) > 0) {
        selected[ability] = value;
        availableValues[value] = availableValues[value]! - 1;
      }
    }

    selectedTransferFrom = widget.transferFrom;
    selectedTransferTo = widget.transferTo;
  }

  Map<Ability, int> computeFinalAbilities(PlayerCharacterWizardModel model) {
    var ageModifiers = model.age!.abilitiesModifiers;
    var ret = <Ability, int>{};

    for(var a in Ability.values) {
      ret[a] = (selected[a] ?? 0)
          + ageModifiers[a]!
          + (selectedTransferFrom == a
              ? -1
              : selectedTransferTo == a
                  ? 1
                  : 0);
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    var abilityWidgets = <Widget>[
      Row(
        spacing: 8.0,
        children: [
          SizedBox(width: 250),
          SizedBox(width: intValueDraggablePillWidth + 30),
          SizedBox(
            width: 130,
            child: Text(
              "Modificateur d'âge",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 130,
            child: Text(
              "Transfert de point",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              "Valeur finale",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )
    ];

    for(var ability in Ability.values) {
      abilityWidgets.add(
        _AbilityEditFormField(
          ability: ability,
          initialValue: selected[ability],
          ageModifier: model.age!.abilitiesModifiers[ability]!,
          transferFrom: ability == selectedTransferFrom,
          transferTo: ability == selectedTransferTo,
          onSet: (int v) {
            setState(() {
              selected[ability] = v;
              availableValues[v] = availableValues[v]! - 1;
            });
            widget.onAbilityChanged(ability, v);
          },
          onRemoved: (int v) {
            setState(() {
              selected.remove(ability);
              availableValues[v] = availableValues[v]! + 1;
            });
            widget.onAbilityChanged(ability, null);
          },
          validator: (int? v) {
            if(v == null) return 'Valeur manquante';
            return null;
          },
        )
      );
    }

    var abilityPillWidgets = <Widget>[];
    for(var value in availableValues.keys) {
      if(availableValues[value]! > 0) {
        for(var v in Iterable.generate(availableValues[value]!, (i) => value)) {
          abilityPillWidgets.add(
            IntValueDraggablePill(
              value: v,
            )
          );
        }
      }
    }

    var finalAbilities = computeFinalAbilities(model);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Row(
          children: [
            Text(
              'Valeurs à répartir : ',
              style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
            ),
            ...abilityPillWidgets,
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: VerticalDivider(),
            ),
            _AbilityTransferWidget(
              from: selectedTransferFrom,
              to: selectedTransferTo,
              onFromChanged: (Ability? a) => setState(() {
                selectedTransferFrom = a;
                widget.onTransferFromChanged(a);
              }),
              onToChanged: (Ability? a) => setState(() {
                selectedTransferTo = a;
                widget.onTransferToChanged(a);
              }),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32.0,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: abilityWidgets,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 2,
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: [
                    _InitiativeDisplayWidget(
                      coordination: finalAbilities[Ability.coordination]!,
                      perception: finalAbilities[Ability.perception]!,
                    ),
                    _AttributeModifierDisplayWidget(
                      abilities: finalAbilities,
                    ),
                    _InjuryLevelsDisplayWidget(
                      resistance: finalAbilities[Ability.resistance]!,
                      volonte: finalAbilities[Ability.volonte]!,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _AbilityTransferWidget extends StatefulWidget {
  const _AbilityTransferWidget({
    this.from,
    this.to,
    required this.onFromChanged,
    required this.onToChanged,
  });

  final Ability? from;
  final Ability? to;
  final void Function(Ability?) onFromChanged;
  final void Function(Ability?) onToChanged;

  @override
  State<_AbilityTransferWidget> createState() => _AbilityTransferWidgetState();
}

class _AbilityTransferWidgetState extends State<_AbilityTransferWidget> {
  TextEditingController fromController = TextEditingController();
  Ability? selectedFrom;
  TextEditingController toController = TextEditingController();
  Ability? selectedTo;

  @override
  void initState() {
    super.initState();
    selectedFrom = widget.from;
    selectedTo = widget.to;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        Text(
          'Transférer un point de',
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: selectedFrom == null ? 90 : 120,
          child: DropdownMenu(
            initialSelection: selectedFrom,
            controller: fromController,
            requestFocusOnTap: true,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            expandedInsets: EdgeInsets.zero,
            leadingIcon: selectedFrom == null ? null : GestureDetector(
              onTap: () {
                setState(() {
                  selectedTo = null;
                  toController.clear();
                  widget.onToChanged(selectedTo);
                  selectedFrom = null;
                  fromController.clear();
                  widget.onFromChanged(selectedFrom);
                });
              },
              child: Icon(Icons.cancel, size: 16.0,)
            ),
            dropdownMenuEntries: Ability.values
              .map((Ability a) => DropdownMenuEntry(value: a, label: a.short))
              .toList(),
            onSelected: (Ability? a) => setState(() {
              selectedFrom = a;
              widget.onFromChanged(selectedFrom);
              if(a == selectedTo) {
                selectedTo = null;
                widget.onToChanged(selectedTo);
                toController.clear();
              }
            }),
          ),
        ),
        Text(
          'vers',
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 90,
          child: DropdownMenuFormField(
            enabled: selectedFrom != null,
            initialSelection: selectedTo,
            controller: toController,
            requestFocusOnTap: true,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: Ability.values
              .where((Ability a) => a != selectedFrom)
              .map((Ability a) => DropdownMenuEntry(value: a, label: a.short))
              .toList(),
            onSelected: (Ability? a) => setState(() {
              selectedTo = a;
              widget.onToChanged(selectedTo);
            }),
            validator: (Ability? a) {
              if(selectedFrom != null && selectedTo == null) {
                return '!';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class _AbilityEditFormField extends FormField<int> {
  _AbilityEditFormField({
    required Ability ability,
    super.initialValue,
    required int ageModifier,
    required bool transferFrom,
    required bool transferTo,
    required void Function(int) onSet,
    required void Function(int) onRemoved,
    super.validator,
  })
    : super(
        builder: (FormFieldState<int> state) {
          Widget ret = _AbilityEditWidget(
            ability: ability,
            initialValue: initialValue,
            ageModifier: ageModifier,
            transferFrom: transferFrom,
            transferTo: transferTo,
            onSet: (int v) {
              state.didChange(v);
              onSet(v);
            },
            onRemoved: (int v) {
              state.didChange(null);
              onRemoved(v);
            },
          );

          if(state.hasError) {
            ret = Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ret,
              ),
            );
          }

          return ret;
        }
      );
}

class _AbilityEditWidget extends StatefulWidget {
  const _AbilityEditWidget({
    required this.ability,
    this.initialValue,
    required this.ageModifier,
    required this.transferFrom,
    required this.transferTo,
    required this.onSet,
    required this.onRemoved,
  });

  final Ability ability;
  final int? initialValue;
  final int ageModifier;
  final bool transferFrom;
  final bool transferTo;
  final void Function(int) onSet;
  final void Function(int) onRemoved;

  @override
  State<_AbilityEditWidget> createState() => _AbilityEditWidgetState();
}

class _AbilityEditWidgetState extends State<_AbilityEditWidget> {
  bool expanded = false;
  int? value;

  @override
  void initState() {
    super.initState();

    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              Row(
                spacing: 4.0,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => setState(() {
                        expanded = !expanded;
                      }),
                      child: Icon(
                        expanded ? Icons.help : Icons.help_outline,
                        size: 18.0,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.ability.title} (${widget.ability.short})',
                    style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if(expanded)
                Text(
                  _abilitiesInformation[widget.ability]!,
                  style: theme.textTheme.bodySmall,
                )
            ],
          ),
        ),
        SizedBox(
          width: intValueDraggablePillWidth + 30,
          child: IntValueDragTarget(
            initialValue: value,
            onValueAccepted: (int v) {
              setState(() {
                value = v;
              });
              widget.onSet(v);
            },
            onValueRemoved: (int v) {
              setState(() {
                value = null;
              });
              widget.onRemoved(v);
            },
          ),
        ),
        SizedBox(
          width: 130,
          child: Text(
            widget.ageModifier.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 130,
          child: Text(
            widget.transferFrom
              ? '-1'
              : widget.transferTo
                  ? '1'
                  : '',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 100,
          child: Center(
            child: IntValuePill(
              value: (value ?? 0)
                + widget.ageModifier
                + (widget.transferFrom ? -1 : widget.transferTo ? 1 : 0),
            ),
          ),
        )
      ],
    );
  }
}

// class _AbilityValueDragTarget extends StatefulWidget {
//   const _AbilityValueDragTarget({
//     this.initialValue,
//     required this.onValueAccepted,
//     required this.onValueRemoved,
//   });
//
//   final int? initialValue;
//   final void Function(int) onValueAccepted;
//   final void Function(int) onValueRemoved;
//
//   @override
//   State<_AbilityValueDragTarget> createState() => _AbilityValueDragTargetState();
// }
//
// class _AbilityValueDragTargetState extends State<_AbilityValueDragTarget> {
//   int? value;
//
//   @override
//   void initState() {
//     super.initState();
//
//     value = widget.initialValue;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var finalWidget = Row(
//       spacing: 4.0,
//       children: [
//         Container(
//           width: _pillWidth,
//           height: _pillHeight,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4.0),
//             color: Colors.black12,
//           ),
//           child: value == null
//             ? SizedBox.shrink()
//             : _AbilityValueDraggablePill(
//                 value: value!,
//                 onValueAccepted: () => setState(() {
//                   widget.onValueRemoved(value!);
//                   value = null;
//                 }),
//               )
//         ),
//         if(value != null)
//           MouseRegion(
//             cursor: SystemMouseCursors.click,
//             child: GestureDetector(
//               onTap: () {
//                 widget.onValueRemoved(value!);
//                 setState(() {
//                   value = null;
//                 });
//               },
//               child: Icon(
//                 Icons.cancel,
//                 size: 24.0,
//               ),
//             ),
//           )
//       ],
//     );
//
//     if(value != null) {
//       return finalWidget;
//     }
//     else {
//       return DragTarget(
//         hitTestBehavior: HitTestBehavior.translucent,
//         builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
//           return finalWidget;
//         },
//         onWillAcceptWithDetails: (DragTargetDetails<_AbilityValueDragData> details) {
//           return value == null;
//         },
//         onAcceptWithDetails: (DragTargetDetails<_AbilityValueDragData> details) {
//           setState(() {
//             value = details.data.value;
//           });
//           widget.onValueAccepted(value!);
//         },
//       );
//     }
//   }
// }
//
// class _AbilityValueDraggablePill extends StatelessWidget {
//   const _AbilityValueDraggablePill({
//     required this.value,
//     required this.onValueAccepted,
//   });
//
//   final int value;
//   final void Function() onValueAccepted;
//
//   @override
//   Widget build(BuildContext context) {
//     return LongPressDraggable<_AbilityValueDragData>(
//       delay: Duration(milliseconds: 100),
//       data: _AbilityValueDragData(value: value),
//       feedback: _AbilityValuePill(value: value),
//       childWhenDragging: _AbilityValueEmptyPill(),
//       onDragCompleted: () {
//         onValueAccepted();
//       },
//       child: _AbilityValuePill(value: value),
//     );
//   }
// }
//
// class _AbilityValuePill extends StatelessWidget {
//   const _AbilityValuePill({ required this.value });
//
//   final int value;
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//
//     return SizedBox(
//       width: _pillWidth,
//       height: _pillHeight,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
//         child: Center(
//           child: Text(
//             value.toString(),
//             style: theme.textTheme.bodyLarge!
//               .copyWith(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _AbilityValueEmptyPill extends StatelessWidget {
//   const _AbilityValueEmptyPill();
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: _pillWidth,
//       height: _pillHeight,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4.0),
//           color: Colors.black12,
//         ),
//       ),
//     );
//   }
// }

class _InitiativeDisplayWidget extends StatelessWidget {
  const _InitiativeDisplayWidget({
    required this.coordination,
    required this.perception,
  });

  final int coordination;
  final int perception;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var sum = coordination + perception;
    var init = 0;

    switch(sum) {
      case >= 2 && <= 5:
        init = 1;
      case >= 6 && <= 9:
        init = 2;
      case >= 10 && <= 13:
        init = 3;
      case >= 14 && <= 16:
        init = 4;
      case >= 17:
        init = 5;
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Initiative : ',
            style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: init.toString(),
            style: theme.textTheme.titleMedium,
          )
        ]
      )
    );
  }
}

class _AttributeModifierDisplayWidget extends StatelessWidget {
  const _AttributeModifierDisplayWidget({ required this.abilities });

  final Map<Ability, int> abilities;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var attributeWidgets = <Widget>[];
    for(var attribute in Attribute.values) {
      var modifier = EntityAttributes.attributeModifier(attribute, abilities);

      attributeWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            spacing: 4.0,
            children: [
              Text(
                '${attribute.title} (${attribute.relatedAbilities.map((a) => a.short).join("+")}) :',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                modifier == null ? 'N/A' : modifier.toString(),
              ),
            ],
          ),
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.0,
      children: [
        Text(
          "Modificateurs d'Attributs",
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        ...attributeWidgets,
      ],
    );
  }
}

class _InjuryLevelsDisplayWidget extends StatelessWidget {
  const _InjuryLevelsDisplayWidget({
    this.resistance,
    this.volonte,
  });

  final int? resistance;
  final int? volonte;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var levelsWidgets = <Widget>[];
    var manager = InjuryManager.getInjuryManagerForAbilities(
        resistance: (resistance ?? 0),
        volonte: (volonte ?? 0),
      );
    for(var level in manager.levels()) {
      levelsWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            spacing: 4.0,
            children: [
              Text(
                '${level.type.title} :',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                resistance == null || volonte == null
                  ? 'N/A'
                  : level.capacity.toString(),
              ),
            ],
          ),
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.0,
      children: [
        Text(
          "Seuils de blessures",
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        ...levelsWidgets,
      ],
    );
  }
}

const _abilitiesInformation = <Ability, String>{
  Ability.force: "Cette Caractéristique mesure l’effort physique qu’un personnage est capable de fournir. Elle donne une bonne idée de sa carrure, du poids qu'il peut soulever et des dommages qu’il inflige en combat. Un entraînement quotidien et de nombreuses activités physiques peuvent permettre à certains humains d’atteindre des scores élevés représentant une puissance physique effrayante.",
  Ability.resistance: "La Résistance est en quelque sorte le capital santé d’un personnage. C’est cette Caractéristique qui permet de gérer l’endurance, le souffle et la capacité de résistance aux maladies, à l'alcool, au poison, etc. Avec l’âge, l’affaiblissement de cette Caractéristique entraîne une baisse des Seuils de blessure.",
  Ability.intelligence: "L'Intelligence mesure à la fois la capacité d’apprentissage, la sagesse, la vivacité d’esprit et la mémoire d’un personnage. C’est la Caractéristique principale des érudits, car elle influe sur l’Attribut Mental, qui sert à gérer toutes les actions en rapport avec la connaissance.",
  Ability.volonte: "Cette Caractéristique sert à définir la force de caractère et le sang-froid d’un personnage. Face à une situation de stress, une forte Volonté permettra par exemple de garder son calme et d’agir de façon lucide. À l’inverse, un faible score dans cette Caractéristique indiquera un personnage manquant cruellement d’assurance.",
  Ability.perception: "La Perception regroupe les cinq sens d’un personnage (la vue, l’ouïe, l’odorat, le goût et le toucher). Elle permet également de mesurer la capacité d’un personnage à évaluer son environnement et à réagir face à toutes sortes d’événements. C’est une Caractéristique très importante, notamment pour caleuler l’Initiative.",
  Ability.coordination: "Mélange d’adresse, d’agilité et de souplesse, la Coordination représente la maîtrise qu’un personnage a de son corps et de ses mains. Caractéristique principale des artisans, elle détermine la précision de toutes sortes d’actions et influe directement sur l’Attribut Manuel, ainsi que sur la rapidité de réaction (l'Initiative).",
  Ability.empathie: "L'Empathie représente le côté “intuitif” d’un personnage, une sorte de sixième sens qui mêle sa sensibilité et son don de la psychologie. Cette Caractéristique sert à gérer la plupart des actions sociales et relationnelles, ainsi que de nombreux phénomènes magiques.",
  Ability.presence: "La Présence regroupe à la fois la beauté physique et le charisme du personnage. Très utile pour les futurs commerçants, elle entre en jeu dans de nombreuses actions sociales et donne une bonne idée des réactions que le personnage suscite lors des rencontres.",
};