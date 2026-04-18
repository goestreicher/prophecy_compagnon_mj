import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/entity/attributes.dart';
import '../../utils/num_input_widget.dart';
import 'model.dart';
import 'step_data.dart';
import 'utils.dart';

class PlayerCharacterWizardStepDataAttributes extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataAttributes({
    Map<Attribute, int>? attributes,
  })
    : attributes = attributes ?? <Attribute, int>{},
      currentAttributes = attributes ?? <Attribute, int>{},
      super(title: 'Attributs');

  Map<Attribute, int> attributes;
  Map<Attribute, int> currentAttributes;
  int? luck;
  int? currentLuck;
  int? proficiency;
  int? currentProficiency;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                'Physique',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20,
              child: Text(
                model.attributeComputedValue(Attribute.physique).toString()
              ),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 70,
              child: Text(
                'Mental',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20,
              child: Text(
                model.attributeComputedValue(Attribute.mental).toString()
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                'Manuel',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20,
              child: Text(
                model.attributeComputedValue(Attribute.manuel).toString()
              ),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 70,
              child: Text(
                'Social',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20,
              child: Text(
                model.attributeComputedValue(Attribute.social).toString()
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                'Chance',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20,
              child: Text(
                model.luck.toString()
              ),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 70,
              child: Text(
                'Maîtrise',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20,
              child: Text(
                model.proficiency.toString()
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    var model = context.read<PlayerCharacterWizardModel>();

    return [sliverWrap([Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Text(
            "Ces valeurs sont sûrement celles qui seront les plus utilisées. Chaque fois qu’un joueur voudra que son personnage effectue une action, il devra en effet ajouter la valeur de la Compétence utilisée (par exemple, Armes tranchantes) à celle de l’Attribut Majeur en rapport (pour un combat, ce sera l’Attribut Physique). Alors que les Compétences déterminent le savoir-faire d’un personnage, les Attributs Majeurs permettent de gérer le type même de l’action. Ainsi, deux jets effectués à partir de la Compétence Armes tranchantes d’un personnage pourront utiliser deux Attributs Majeurs différents selon le type d’action entreprise (Physique + Armes tranchantes pour donner un coup d’épée, Manuel + Armes tranchantes pour forger ou réparer une arme).\nAvant chaque action, il appartiendra au meneur de jeu de décider quel Attribut Majeur sera utilisé, mais la description de l’action suffira généralement à orienter ce choix."
          ),
          _AttributesEditWidget(
            attributes: currentAttributes,
            values: model.age!.attributesValues,
            onAttributeChanged: (Attribute a, int? v) {
              if(v == null) {
                currentAttributes.remove(a);
              }
              else {
                currentAttributes[a] = v;
              }
              changed = _checkChanged();
            },
            luck: currentLuck ?? luck,
            onLuckChanged: (int v) {
              currentLuck = v;
              changed = _checkChanged();
            },
            proficiency: currentProficiency ?? proficiency,
            onProficiencyChanged: (int v) {
              currentProficiency = v;
              changed = _checkChanged();
            },
          ),
        ],
      ),
    )])];
  }

  bool _checkChanged() {
    bool attributeChanged = false;
    for(var a in currentAttributes.keys) {
      if(!attributes.containsKey(a)) {
        attributeChanged = true;
        break;
      }
      if(attributes[a]! != currentAttributes[a]) {
        attributeChanged = true;
        break;
      }
    }

    return attributeChanged
        || currentLuck != luck
        || currentProficiency != proficiency;
  }

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) => formKey.currentState!.validate();

  @override
  void init(PlayerCharacterWizardModel model) {
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    currentAttributes = attributes = <Attribute, int>{};
    model.attributes = null;

    currentLuck = luck = null;
    model.luck = null;

    currentProficiency = proficiency = null;
    model.proficiency = null;
  }

  @override
  void clear() {
    currentAttributes = Map.from(attributes);
    currentLuck = luck;
    currentProficiency = proficiency;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    attributes = currentAttributes;
    model.attributes = attributes;
    currentAttributes = Map.from(attributes);

    luck = currentLuck ?? model.age!.baseLuck;
    model.luck = luck;

    proficiency = currentProficiency ?? model.age!.baseProficiency;
    model.proficiency = currentProficiency;
  }
}

class _AttributesEditWidget extends StatefulWidget {
  const _AttributesEditWidget({
    this.attributes,
    required this.values,
    required this.onAttributeChanged,
    this.luck,
    required this.onLuckChanged,
    this.proficiency,
    required this.onProficiencyChanged,
  });

  final Map<Attribute, int>? attributes;
  final Map<int, int> values;
  final void Function(Attribute, int?) onAttributeChanged;
  final int? luck;
  final void Function(int) onLuckChanged;
  final int? proficiency;
  final void Function(int) onProficiencyChanged;

  @override
  State<_AttributesEditWidget> createState() => _AttributesEditWidgetState();
}

class _AttributesEditWidgetState extends State<_AttributesEditWidget> {
  Map<Attribute, int> selected = <Attribute, int>{};
  late Map<int, int> availableValues;

  @override
  void initState() {
    super.initState();

    availableValues = Map.from(widget.values);

    for(var attribute in (widget.attributes?.keys ?? <Attribute>[])) {
      var value = widget.attributes![attribute]!;
      if((availableValues[value] ?? 0) > 0) {
        selected[attribute] = value;
        availableValues[value] = availableValues[value]! - 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    var attributeWidgets = <Widget>[
      Row(
        spacing: 8.0,
        children: [
          SizedBox(width: 250),
          SizedBox(width: intValueDraggablePillWidth + 30),
          SizedBox(
            width: 110,
            child: Text(
              "Modificateur",
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

    var finalAbilities = model.computedAbilities();

    for(var attribute in Attribute.values) {
      attributeWidgets.add(
        _AttributeEditFormField(
          attribute: attribute,
          initialValue: selected[attribute],
          modifier: EntityAttributes.attributeModifier(attribute, finalAbilities)!,
          onSet: (int v) {
            setState(() {
              selected[attribute] = v;
              availableValues[v] = availableValues[v]! - 1;
            });
            widget.onAttributeChanged(attribute, v);
          },
          onRemoved: (int v) {
            setState(() {
              selected.remove(attribute);
              availableValues[v] = availableValues[v]! + 1;
            });
            widget.onAttributeChanged(attribute, null);
          },
          validator: (int? v) {
            if(v == null) return 'Valeur manquante';
            return null;
          },
        )
      );
    }

    var attributePillWidgets = <Widget>[];
    for(var value in availableValues.keys) {
      if(availableValues[value]! > 0) {
        for(var v in Iterable.generate(availableValues[value]!, (i) => value)) {
          attributePillWidgets.add(
            IntValueDraggablePill(
              value: v,
            )
          );
        }
      }
    }

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
            ...attributePillWidgets,
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: attributeWidgets,
        ),
        _LuckProficiencyEditFormField(
          baseLuck: model.age!.baseLuck,
          luck: widget.luck,
          baseProficiency: model.age!.baseProficiency,
          proficiency: widget.proficiency,
          baseFreePoints: model.age!.lpFreePoints,
          onLuckChanged: (int v) => widget.onLuckChanged(v),
          onProficiencyChanged: (int v) => widget.onProficiencyChanged(v),
          validator: (int? v) {
            if(v != null && v > 0) return 'Tous les points doivent être répartis';
            return null;
          },
        ),
      ],
    );
  }
}

class _LuckProficiencyEditFormField extends FormField<int> {
  _LuckProficiencyEditFormField({
    required int baseLuck,
    int? luck,
    required int baseProficiency,
    int? proficiency,
    required baseFreePoints,
    required void Function(int) onLuckChanged,
    required void Function(int) onProficiencyChanged,
    super.validator,
  })
    : super(
        initialValue: baseFreePoints
          - ((luck ?? baseLuck) - baseLuck)
          - ((proficiency ?? baseProficiency) - baseProficiency),
        builder: (FormFieldState<int> state) {
          Widget ret = _LuckProficiencyEditWidget(
            baseLuck: baseLuck,
            luck: luck,
            baseProficiency: baseProficiency,
            proficiency: proficiency,
            baseFreePoints: baseFreePoints,
            onLuckChanged: (int v) => onLuckChanged(v),
            onProficiencyChanged: (int v) => onProficiencyChanged(v),
            onFreePointsChanged: (int v) {
              state.didChange(v);
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

class _LuckProficiencyEditWidget extends StatefulWidget {
  const _LuckProficiencyEditWidget({
    required this.baseLuck,
    this.luck,
    required this.baseProficiency,
    this.proficiency,
    required this.baseFreePoints,
    required this.onLuckChanged,
    required this.onProficiencyChanged,
    this.onFreePointsChanged,
  });

  final int baseLuck;
  final int? luck;
  final int baseProficiency;
  final int? proficiency;
  final int baseFreePoints;
  final void Function(int) onLuckChanged;
  final void Function(int) onProficiencyChanged;
  final void Function(int)? onFreePointsChanged;

  @override
  State<_LuckProficiencyEditWidget> createState() => _LuckProficiencyEditWidgetState();
}

class _LuckProficiencyEditWidgetState extends State<_LuckProficiencyEditWidget> {
  late int currentLuck;
  late int currentProficiency;
  late int remainingPoints;

  @override
  void initState() {
    super.initState();

    currentLuck = widget.luck ?? widget.baseLuck;
    currentProficiency = widget.proficiency ?? widget.baseProficiency;
    remainingPoints = widget.baseFreePoints
      - (currentLuck - widget.baseLuck)
      - (currentProficiency - widget.baseProficiency);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        Text(
          'Attributs secondaires ($remainingPoints points à répartir) :',
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'Chance',
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 80,
          child: NumIntInputWidget(
            initialValue: currentLuck,
            minValue: widget.baseLuck,
            maxValue: currentLuck + remainingPoints,
            onChanged: (int v) {
              var delta = v - currentLuck;
              setState(() {
                currentLuck = v;
                remainingPoints -= delta;
              });
              widget.onFreePointsChanged?.call(remainingPoints);
              widget.onLuckChanged(currentLuck);
            },
          ),
        ),
        Text(
          ' / Maîtrise',
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 80,
          child: NumIntInputWidget(
            initialValue: currentProficiency,
            minValue: widget.baseProficiency,
            maxValue: currentProficiency + remainingPoints,
            onChanged: (int v) {
              var delta = v - currentProficiency;
              setState(() {
                currentProficiency = v;
                remainingPoints -= delta;
              });
              widget.onFreePointsChanged?.call(remainingPoints);
              widget.onProficiencyChanged(currentProficiency);
            },
          ),
        ),
      ],
    );
  }
}

class _AttributeEditFormField extends FormField<int> {
  _AttributeEditFormField({
    required Attribute attribute,
    super.initialValue,
    required int modifier,
    required void Function(int) onSet,
    required void Function(int) onRemoved,
    super.validator,
  })
      : super(
          builder: (FormFieldState<int> state) {
            Widget ret = _AttributeEditWidget(
              attribute: attribute,
              initialValue: initialValue,
              modifier: modifier,
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

class _AttributeEditWidget extends StatefulWidget {
  const _AttributeEditWidget({
    required this.attribute,
    this.initialValue,
    required this.modifier,
    required this.onSet,
    required this.onRemoved,
  });

  final Attribute attribute;
  final int? initialValue;
  final int modifier;
  final void Function(int) onSet;
  final void Function(int) onRemoved;

  @override
  State<_AttributeEditWidget> createState() => _AttributeEditWidgetState();
}

class _AttributeEditWidgetState extends State<_AttributeEditWidget> {
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
                    widget.attribute.title,
                    style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if(expanded)
                Text(
                  _attributesInformation[widget.attribute]!,
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
          width: 110,
          child: Text(
            widget.modifier.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 100,
          child: Center(
            child: IntValuePill(
              value: (value ?? 0) + widget.modifier,
            ),
          ),
        )
      ],
    );
  }
}

const _attributesInformation = <Attribute, String>{
  Attribute.physique: "Cet Attribut mesure tous les efforts qu’un personnage est capable de fournir, du simple mouvement à la manœuvre la plus complexe, en passant par la course, le combat, la natation, etc. L’Attribut Physique est utilisé dans toutes les actions liées au combat et au mouvement. Il est donc très important pour les combattants.",
  Attribute.mental: "L’Attribut Mental sert à gérer les actions dites “intellectuelles”, qu’il s'agisse d’efforts de mémoire, de tentatives d'apprentissage, d’observations ou de conversations dans des dialectes régionaux ou étrangers. Il est fondamental pour les érudits, les savants et tous les personnages désireux d’utiliser les Compétences de Théorie et de Pratique.",
  Attribute.manuel: "Le Manuel représente à la fois l’adresse, l’habileté et la précision d’un personnage. C’est cet Attribut qui sera utilisé pour résoudre les actions de manipulation, de lancer, de visée, mais aussi de confection, de dessin ou de tout autre travail artistique. Il est donc aussi important pour les artisans que pour les archers et les personnages qui souhaiteront “faire les poches” de leurs petits camarades.",
  Attribute.social: "L'Attribut Social permet de mesurer l’aptitude d’un personnage à nouer et à gérer des relations avec les autres. Plus que le simple fait de dialoguer, cet Attribut sert à résoudre les actions de négociation, de diplomatie, de séduction, de commandement, de psychologie et de perception des émotions. Il est capital pour les commerçants et tous les grands chefs de guerre.",
};