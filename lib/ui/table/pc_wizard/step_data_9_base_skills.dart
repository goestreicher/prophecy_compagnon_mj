import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/calendar.dart';
import '../../../classes/caste/base.dart';
import '../../../classes/character/advantages.dart';
import '../../../classes/entity/skill.dart';
import '../../../classes/entity/skill_family.dart';
import '../../../classes/equipment/shield.dart';
import '../../../classes/equipment/weapon.dart';
import '../../../classes/human_character.dart';
import '../../../classes/magic.dart';
import 'model.dart';
import 'step_data.dart';
import 'utils.dart';

class PlayerCharacterWizardStepDataBaseSkills extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataBaseSkills({
    List<WizardSkillInstance?>? skills,
    this.starterSpecialization,
    List<WizardSkillInstance?>? advantageMentorSkills,
    List<WizardSkillInstance?>? advantageAugureSkills,
    this.advantageNaturalMagicSkill,
    this.advantageIntuitiveMagicSkill,
  })
    : skills = skills ?? List.generate(5, (int i) => null),
      advantageMentorSkills = advantageMentorSkills ?? List.generate(2, (int i) => null),
      advantageAugureSkills = advantageAugureSkills ?? List.generate(2, (int i) => null),
      super(title: 'Compétences de base')
  {
    currentSkills = List.from(this.skills);
    currentStarterSpecialization = starterSpecialization;
    currentAdvantageMentorSkills = List.from(this.advantageMentorSkills);
    currentAdvantageAugureSkills = List.from(this.advantageAugureSkills);
    currentAdvantageNaturalMagicSkill = advantageNaturalMagicSkill;
    currentAdvantageIntuitiveMagicSkill = advantageIntuitiveMagicSkill;
  }

  List<WizardSkillInstance?> skills;
  late List<WizardSkillInstance?> currentSkills;
  WizardSkillInstance? starterSpecialization;
  late WizardSkillInstance? currentStarterSpecialization;
  List<WizardSkillInstance?> advantageMentorSkills;
  late List<WizardSkillInstance?> currentAdvantageMentorSkills;
  List<WizardSkillInstance?> advantageAugureSkills;
  late List<WizardSkillInstance?> currentAdvantageAugureSkills;
  WizardSkillInstance? advantageNaturalMagicSkill;
  late WizardSkillInstance? currentAdvantageNaturalMagicSkill;
  WizardSkillInstance? advantageIntuitiveMagicSkill;
  late WizardSkillInstance? currentAdvantageIntuitiveMagicSkill;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    var advantageAugureWidgets = <Widget>[];
    bool hasAdvantageAugure = (model.advantages ?? <CharacterAdvantage>[])
        .any((CharacterAdvantage a) => a.advantage == Advantage.augureFavorable);
    if(hasAdvantageAugure) {
      var first = model.advantageAugureBaseSkills![0]!;
      var second = model.advantageAugureBaseSkills![1]!;
      advantageAugureWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Text(
              'Avantage Augure Favorable',
              style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '+1 à ${first.title}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '+1 à ${second.title}',
              ),
            )
          ],
        )
      );
    }

    var advantageMentorWidgets = <Widget>[];
    bool hasAdvantageMentor = (model.advantages ?? <CharacterAdvantage>[])
        .any((CharacterAdvantage a) => a.advantage == Advantage.mentor);
    if(hasAdvantageMentor) {
      var first = model.advantageMentorBaseSkills![0]!;
      var second = model.advantageMentorBaseSkills![1]!;
      advantageMentorWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Text(
              'Avantage Mentor',
              style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '+1 à ${first.title}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '+1 à ${second.title}',
              ),
            )
          ],
        )
      );
    }

    var advantageNaturalMagicWidgets = <Widget>[];
    bool hasAdvantageNaturalMagic = (model.advantages ?? <CharacterAdvantage>[])
        .any((CharacterAdvantage a) => a.advantage == Advantage.magieNaturelle);
    if(hasAdvantageNaturalMagic) {
      advantageNaturalMagicWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Text(
              'Avantage Magie Naturelle',
              style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '+2 à ${advantageNaturalMagicSkill!.implementation!}',
              ),
            ),
          ],
        )
      );
    }

    var advantageIntuitiveMagicWidgets = <Widget>[];
    bool hasAdvantageIntuitiveMagic = (model.advantages ?? <CharacterAdvantage>[])
        .any((CharacterAdvantage a) => a.advantage == Advantage.magieIntuitive);
    if(hasAdvantageIntuitiveMagic) {
      advantageIntuitiveMagicWidgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              Text(
                'Avantage Magie Intuitive',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '+2 à ${advantageIntuitiveMagicSkill!.implementation!}',
                ),
              ),
            ],
          )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        for(var skill in model.baseSkills!)
          Row(
            spacing: 4.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                skill!.title,
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                skill.value.toString(),
              ),
            ],
          ),
        Row(
          spacing: 4.0,
          children: [
            Text(
              "Spécialisation :",
              style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "${model.starterSpecialization!.title} / ${model.starterSpecialization!.specialization!}",
            ),
          ],
        ),
        ...advantageAugureWidgets,
        ...advantageMentorWidgets,
        ...advantageNaturalMagicWidgets,
        ...advantageIntuitiveMagicWidgets,
      ],
    );
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    return [sliverWrap([Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32.0,
        children: [
          Text(
            "Au départ de leur vie d’aventuriers, les personnages ont acquis un certain savoir, que ce soit par leur expérience personnelle ou dans les académies dans lesquelles ils ont passé plusieurs années. Ils ont donc développé certaines Compétences spécifiques à leur caste et connues de tous ses membres. Ils possèdent donc une base de 26 Points de Compétence répartis comme suit : 6/6/5/5/4.\nCes cinq scores de base devront être répartis dans, les Compétences communes à tous les membre de la caste."
          ),
          _BaseSkillsWidget(
            skills: currentSkills,
            onSkillsChanged: (List<WizardSkillInstance?> l) {
              currentSkills = l;
              changed = true;
            },
            starterSpecialization: currentStarterSpecialization,
            onStarterSpecializationChanged: (WizardSkillInstance? i) {
              currentStarterSpecialization = i;
              changed =
                  changed
                  || i?.implementation != starterSpecialization?.implementation
                  || i?.specialization != starterSpecialization?.specialization;
            },
            advantageAugureSkills: currentAdvantageAugureSkills,
            onAdvantageAugureSkillsChanged: (List<WizardSkillInstance?> l) {
              currentAdvantageAugureSkills = l;
              changed = true;
            },
            advantageNaturalMagicSkill: currentAdvantageNaturalMagicSkill,
            onAdvantageNaturalMagicSkillChanged: (WizardSkillInstance? i) {
              currentAdvantageNaturalMagicSkill = i;
              changed =
                  changed
                  || i?.implementation != advantageNaturalMagicSkill?.implementation;
            },
            advantageIntuitiveMagicSkill: currentAdvantageIntuitiveMagicSkill,
            onAdvantageIntuitiveMagicSkillChanged: (WizardSkillInstance? i) {
              currentAdvantageIntuitiveMagicSkill = i;
              changed =
                  changed
                  || i?.implementation != advantageIntuitiveMagicSkill?.implementation;
            },
            advantageMentorSkills: currentAdvantageMentorSkills,
            onAdvantageMentorSkillsChanged: (List<WizardSkillInstance?> l) {
              currentAdvantageMentorSkills = l;
              changed = true;
            },
          ),
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
    skills = List.generate(5, (int i) => null);
    currentSkills = List.generate(5, (int i) => null);
    model.baseSkills = null;

    starterSpecialization = currentStarterSpecialization = null;
    model.starterSpecialization = null;

    advantageAugureSkills = List.generate(2, (int i) => null);
    currentAdvantageAugureSkills = List.generate(2, (int i) => null);
    model.advantageAugureBaseSkills = null;

    advantageNaturalMagicSkill = null;
    currentAdvantageNaturalMagicSkill = null;
    model.advantageNaturalMagicSkill = null;

    advantageIntuitiveMagicSkill = null;
    currentAdvantageIntuitiveMagicSkill = null;
    model.advantageIntuitiveMagicSkill = null;

    advantageMentorSkills = List.generate(2, (int i) => null);
    currentAdvantageMentorSkills = List.generate(2, (int i) => null);
    model.advantageMentorBaseSkills = null;
  }

  @override
  void clear() {
    currentSkills = List.from(skills);
    currentStarterSpecialization = starterSpecialization;
    currentAdvantageAugureSkills = List.from(advantageAugureSkills);
    currentAdvantageNaturalMagicSkill =advantageNaturalMagicSkill;
    currentAdvantageIntuitiveMagicSkill = advantageIntuitiveMagicSkill;
    currentAdvantageMentorSkills = List.from(advantageMentorSkills);
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    skills = currentSkills;
    model.baseSkills = skills;
    currentSkills = List.from(skills);

    starterSpecialization = currentStarterSpecialization;
    model.starterSpecialization = currentStarterSpecialization;

    advantageAugureSkills = currentAdvantageAugureSkills;
    model.advantageAugureBaseSkills = advantageAugureSkills;
    currentAdvantageAugureSkills = List.from(advantageAugureSkills);

    advantageNaturalMagicSkill = currentAdvantageNaturalMagicSkill;
    model.advantageNaturalMagicSkill = advantageNaturalMagicSkill;

    advantageIntuitiveMagicSkill = currentAdvantageIntuitiveMagicSkill;
    model.advantageIntuitiveMagicSkill = advantageIntuitiveMagicSkill;

    advantageMentorSkills = currentAdvantageMentorSkills;
    model.advantageMentorBaseSkills = advantageMentorSkills;
    currentAdvantageMentorSkills = List.from(advantageMentorSkills);
  }
}

class _BaseSkillsWidget extends StatefulWidget {
  const _BaseSkillsWidget({
    required this.skills,
    required this.onSkillsChanged,
    this.starterSpecialization,
    required this.onStarterSpecializationChanged,
    required this.advantageAugureSkills,
    required this.onAdvantageAugureSkillsChanged,
    this.advantageNaturalMagicSkill,
    required this.onAdvantageNaturalMagicSkillChanged,
    this.advantageIntuitiveMagicSkill,
    required this.onAdvantageIntuitiveMagicSkillChanged,
    required this.advantageMentorSkills,
    required this.onAdvantageMentorSkillsChanged,
  });

  final List<WizardSkillInstance?> skills;
  final void Function(List<WizardSkillInstance?>) onSkillsChanged;
  final WizardSkillInstance? starterSpecialization;
  final void Function(WizardSkillInstance?) onStarterSpecializationChanged;
  final List<WizardSkillInstance?> advantageAugureSkills;
  final void Function(List<WizardSkillInstance?>) onAdvantageAugureSkillsChanged;
  final WizardSkillInstance? advantageNaturalMagicSkill;
  final void Function(WizardSkillInstance?) onAdvantageNaturalMagicSkillChanged;
  final WizardSkillInstance? advantageIntuitiveMagicSkill;
  final void Function(WizardSkillInstance?) onAdvantageIntuitiveMagicSkillChanged;
  final List<WizardSkillInstance?> advantageMentorSkills;
  final void Function(List<WizardSkillInstance?>) onAdvantageMentorSkillsChanged;

  @override
  State<_BaseSkillsWidget> createState() => _BaseSkillsWidgetState();
}

class _BaseSkillsWidgetState extends State<_BaseSkillsWidget> {
  late List<WizardSkillInstance?> currentSkills;
  late List<int> availableValues;
  late List<WizardSkillInstance?> currentAdvantageMentorSkills;
  late List<WizardSkillInstance?> currentAdvantageAugureSkills;

  @override
  void initState() {
    super.initState();

    currentSkills = List.from(widget.skills);
    currentAdvantageMentorSkills = List.from(widget.advantageMentorSkills);
    currentAdvantageAugureSkills = List.from(widget.advantageAugureSkills);

    availableValues = [6, 6, 5, 5, 4];
    for(var (idx, instance) in currentSkills.indexed) {
      if(instance == null) continue;
      var pos = availableValues.indexOf(instance.value);
      if(pos == -1) {
        // This value is used while it was not available, just replace
        // the instance by null
        currentSkills[idx] = null;
        continue;
      }
      availableValues.removeAt(pos);
    }
  }

  @override
  Widget build(BuildContext context) {
    var model = context.read<PlayerCharacterWizardModel>();

    bool hasAdvantageAugure = (model.advantages ?? <CharacterAdvantage>[])
      .any((CharacterAdvantage a) => a.advantage == Advantage.augureFavorable);

    bool hasAdvantageMentor = (model.advantages ?? <CharacterAdvantage>[])
      .any((CharacterAdvantage a) => a.advantage == Advantage.mentor);

    bool hasAdvantageNaturalMagic = (model.advantages ?? <CharacterAdvantage>[])
      .any((CharacterAdvantage a) => a.advantage == Advantage.magieNaturelle);

    bool hasAdvantageIntuitiveMagic = (model.advantages ?? <CharacterAdvantage>[])
        .any((CharacterAdvantage a) => a.advantage == Advantage.magieIntuitive);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 32.0,
      children: [
        _AvailableValuesFormField(
          values: availableValues,
          validator: (int? l) {
            if(l == null || l > 0) return 'Valeurs à répartir';
            return null;
          },
        ),
        _CasteSkillsWidget(
          skills: currentSkills,
          caste: model.caste!,
          onSkillsChanged: (List<WizardSkillInstance?> l) {
            setState(() {
              currentSkills = l;
            });
            widget.onSkillsChanged(l);
          },
          onValueAccepted: (int v) {
            var pos = availableValues.indexOf(v);
            if(pos == -1) {
              throw(ArgumentError("Valeur utilisée plusieurs fois : $v"));
            }
            setState(() {
              availableValues.removeAt(pos);
            });
          },
          onValueRemoved: (int v) {
            setState(() {
              availableValues.add(v);
              availableValues.sort(((int a, int b) => b.compareTo(a)));
            });
          },
        ),
        _StarterSpecializationWidget(
          specialization: widget.starterSpecialization,
          available: currentSkills
            .where((WizardSkillInstance? i) => i != null)
            .map((WizardSkillInstance? i) => i!)
            .toList(),
          onChanged: widget.onStarterSpecializationChanged,
        ),
        if(hasAdvantageAugure)
          _AdvantageAugureSkillWidget(
            augure: model.augure!,
            available: currentSkills
              .where((WizardSkillInstance? i) => i != null)
              .map((WizardSkillInstance? i) => i!)
              .toList(),
            skills: currentAdvantageAugureSkills,
            onSkillsChanged: (List<WizardSkillInstance?> l) {
              currentAdvantageAugureSkills = l;
              widget.onAdvantageAugureSkillsChanged(l);
            }
          ),
        if(hasAdvantageNaturalMagic)
          _AdvantageNaturalMagicWidget(
            skill: widget.advantageNaturalMagicSkill,
            onSkillChanged: (WizardSkillInstance? i) =>
              widget.onAdvantageNaturalMagicSkillChanged(i),
            advantageName: "Magie Naturelle",
          ),
        if(hasAdvantageIntuitiveMagic)
          _AdvantageNaturalMagicWidget(
            skill: widget.advantageIntuitiveMagicSkill,
            onSkillChanged: (WizardSkillInstance? i) =>
              widget.onAdvantageIntuitiveMagicSkillChanged(i),
            advantageName: "Magie Intuitive",
          ),
        if(hasAdvantageMentor)
          _AdvantageMentorSkillWidget(
            available: currentSkills
              .where((WizardSkillInstance? i) => i != null)
              .map((WizardSkillInstance? i) => i!)
              .toList(),
            skills: currentAdvantageMentorSkills,
            onSkillsChanged: (List<WizardSkillInstance?> l) {
              currentAdvantageMentorSkills = l;
              widget.onAdvantageMentorSkillsChanged(l);
            }
          ),
      ],
    );
  }
}

class _AvailableValuesFormField extends FormField<int> {
  _AvailableValuesFormField({
    required List<int> values,
    super.validator,
  })
    : super(
        initialValue: values.length,
        builder: (FormFieldState<int> state) {
          Widget ret = _AvailableValuesWidget(values: values);

          if(values.length != state.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                state.didChange(values.length));
          }

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
        },
    );
}

class _AvailableValuesWidget extends StatelessWidget {
  const _AvailableValuesWidget({
    required this.values,
  });

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      children: [
        Text(
          'Valeurs à répartir : ',
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        for(var v in values)
          IntValueDraggablePill(
            value: v,
          ),
      ],
    );
  }
}

class _CasteSkillsWidget extends StatelessWidget {
  const _CasteSkillsWidget({
    required this.skills,
    required this.caste,
    required this.onSkillsChanged,
    required this.onValueAccepted,
    required this.onValueRemoved,
  });

  final List<WizardSkillInstance?> skills;
  final Caste caste;
  final void Function(List<WizardSkillInstance?>) onSkillsChanged;
  final void Function(int) onValueAccepted;
  final void Function(int) onValueRemoved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        for(var (idx, s) in _casteBaseSkills[caste]!.indexed)
          _SingleSkillWidget(
            skills: s,
            instance: skills[idx],
            onValueAccepted: (int v) => onValueAccepted(v),
            onValueRemoved: (int v) => onValueRemoved(v),
            onSkillChanged: (WizardSkillInstance? instance) {
              skills[idx] = instance;
              onSkillsChanged(skills);
            },
          ),
      ],
    );
  }
}

class _StarterSpecializationWidget extends StatefulWidget {
  const _StarterSpecializationWidget({
    this.specialization,
    required this.onChanged,
    required this.available,
  });

  final WizardSkillInstance? specialization;
  final void Function(WizardSkillInstance?) onChanged;
  final List<WizardSkillInstance> available;

  @override
  State<_StarterSpecializationWidget> createState() => _StarterSpecializationWidgetState();
}

class _StarterSpecializationWidgetState extends State<_StarterSpecializationWidget> {
  TextEditingController instanceController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  FocusNode specializationFocusNode = FocusNode();
  GlobalKey specializationAutocompleteKey = GlobalKey();
  Timer? specializationDebounce;
  WizardSkillInstance? instance;
  WizardSkillInstance? currentSpecialization;

  @override
  void initState() {
    super.initState();

    if(widget.specialization != null) {
      currentSpecialization = widget.specialization;
      instanceController.text = currentSpecialization!.title;
      specializationController.text = currentSpecialization!.specialization!;

      for(var i in widget.available) {
        if(i.title == currentSpecialization!.title) {
          instance = i;
        }
      }
    }
  }

  @override
  void dispose() {
    specializationDebounce?.cancel();
    specializationFocusNode.dispose();

    super.dispose();
  }

  void onSpecializationChanged(String? v) {
    if(specializationDebounce?.isActive ?? false) {
      specializationDebounce?.cancel();
    }
    specializationDebounce = Timer(
      const Duration(milliseconds: 300),
      () {
        updateForSpecialization(v);
      }
    );
  }

  void updateForSpecialization(String? v) {
    if(v == null || v.isEmpty) {
      currentSpecialization = null;
    }
    else {
      currentSpecialization = WizardSkillInstance(
        skill: WizardStandardSkillWrapper(
          skill: (instance!.skill as WizardStandardSkillWrapper).skill,
        ),
        implementation: instance!.implementation,
        specialization: v,
        value: instance!.value,
      );
    }
    widget.onChanged(currentSpecialization);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget? autocompleteWidget;
    if(instance != null && instance!.skill is WizardStandardSkillWrapper) {
      var w = instance!.skill as WizardStandardSkillWrapper;
      var options = Iterable<String>.empty();

      if(w.skill == Skill.bouclier) {
        options = ShieldModel.ids()
            .map((String id) => ShieldModel.get(id))
            .where((ShieldModel? m) => m != null && !m.unique)
            .map((ShieldModel? m) => m!.name);
      }
      else if(WeaponModel.weaponSkills().contains(w.skill)) {
        options = WeaponModel.idsBySkill(w.skill)
            .map((String id) => WeaponModel.get(id))
            .where((WeaponModel? m) => m != null && !m.unique)
            .map((WeaponModel? m) => m!.name);
      }

      if(options.isNotEmpty) {
        autocompleteWidget = RawAutocomplete<String>(
          textEditingController: specializationController,
          focusNode: specializationFocusNode,
          key: specializationAutocompleteKey,
          onSelected: updateForSpecialization,
          optionsBuilder: (TextEditingValue value) {
            if(value.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return options
                .where((String w) => w.toLowerCase().contains(value.text.toLowerCase()));
          },
          optionsViewBuilder:
            (
              BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options,
            ) {
              return Material(
                elevation: 4.0,
                child: ListView(
                  shrinkWrap: true,
                  children: options
                    .map(
                        (String option) => GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(title: Text(option)),
                        ),
                      )
                      .toList(),
                ),
              );
            },
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            "Spécialisation de départ",
            style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          spacing: 8.0,
          children: [
            Row(
              spacing: 16.0,
              children: [
                SizedBox(
                  width: 250,
                  child: DropdownMenuFormField(
                    initialSelection: widget.specialization,
                    controller: instanceController,
                    requestFocusOnTap: true,
                    expandedInsets: EdgeInsets.zero,
                    textStyle: theme.textTheme.bodySmall,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      constraints: BoxConstraints(maxHeight: 36.0),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    dropdownMenuEntries: widget.available
                      .where((WizardSkillInstance i) => i.skill is WizardStandardSkillWrapper)
                      .map((WizardSkillInstance i) => DropdownMenuEntry(value: i, label: i.title))
                      .toList(),
                    onSelected: (WizardSkillInstance? i) {
                      if(i == null) {
                        setState(() {
                          specializationController.clear();
                          instance = null;
                          currentSpecialization = null;
                          widget.onChanged(currentSpecialization);
                        });
                      }
                      else {
                        if(i.title != currentSpecialization?.title) {
                          setState(() {
                            specializationController.clear();
                            instance = i;
                            currentSpecialization = null;
                            widget.onChanged(currentSpecialization);
                          });
                        }
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                    validator: (WizardSkillInstance? i) {
                      if(i == null) return 'Valeur manquante';
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        enabled: instance != null,
                        controller: specializationController,
                        focusNode: specializationFocusNode,
                        decoration: const InputDecoration(
                          label: Text('Spécialisation'),
                          border: OutlineInputBorder(),
                          isCollapsed: true,
                          constraints: BoxConstraints(maxHeight: 36.0),
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        onChanged: onSpecializationChanged,
                        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                        validator: (String? v) {
                          if(v == null || v.isEmpty) return 'Valeur manquante';
                          return null;
                        },
                      ),
                      ?autocompleteWidget,
                    ],
                  ),
                ),
              ],
            ),
            if(instance != null)
              SizedBox(
                width: 516,
                child: Text(
                  (instance!.skill as WizardStandardSkillWrapper).skill.description,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SingleSkillWidget extends StatefulWidget {
  const _SingleSkillWidget({
    required this.skills,
    this.instance,
    required this.onValueAccepted,
    required this.onValueRemoved,
    required this.onSkillChanged,
  });

  final List<WizardSkillWrapper> skills;
  final WizardSkillInstance? instance;
  final void Function(int) onValueAccepted;
  final void Function(int) onValueRemoved;
  final void Function(WizardSkillInstance?) onSkillChanged;

  @override
  State<_SingleSkillWidget> createState() => _SingleSkillWidgetState();
}

class _SingleSkillWidgetState extends State<_SingleSkillWidget> {
  WizardSkillWrapper? selected;
  int? value;
  String? implementation;
  WizardSkillInstance? instance;

  @override
  void initState() {
    super.initState();

    if(widget.instance != null) {
      selected = widget.instance!.skill;
      value = widget.instance!.value;
      implementation = widget.instance!.implementation;
      instance = WizardSkillInstance(
        skill: selected!,
        implementation: implementation,
        value: value!
      );
    }
  }

  void finalizeSkill() {
    var notify = false;

    if(selected == null) {
      notify = instance != null;
      instance = null;
    }
    else if(value == null) {
      notify = instance != null;
      instance = null;
    }
    else if(selected!.requiresImplementation && implementation == null) {
      notify = instance != null;
      instance = null;
    }
    else {
      notify = true;
      instance = WizardSkillInstance(
        skill: selected!,
        implementation: implementation,
        value: value!
      );
    }

    if(notify) widget.onSkillChanged(instance);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        SizedBox(
          width: 250,
          child: DropdownMenuFormField(
            initialSelection: selected,
            requestFocusOnTap: true,
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            dropdownMenuEntries: widget.skills
              .map(
                (WizardSkillWrapper w) => DropdownMenuEntry(
                  value: w,
                  label: w.title
                )
              )
              .toList(),
            onSelected: (WizardSkillWrapper? w) {
              setState(() {
                selected = w;
              });
              finalizeSkill();
            },
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            validator: (WizardSkillWrapper? w) {
              if(w == null) return 'Valeur manquante';
              return null;
            },
          ),
        ),
        IntValueDragTarget(
          initialValue: value,
          onValueAccepted: (int v) {
            value = v;
            widget.onValueAccepted(v);
            finalizeSkill();
          },
          onValueRemoved: (int v) {
            value = null;
            widget.onValueRemoved(v);
            finalizeSkill();
          },
        ),
        if(selected?.requiresImplementation ?? false)
          _SingleSkillImplementationSelectWidget(
            implementations: selected!.implementations,
            onImplementationChanged: (String? i) {
              implementation = i;
              finalizeSkill();
            }
          )
      ],
    );
  }
}

class _SingleSkillImplementationSelectWidget extends StatelessWidget {
  const _SingleSkillImplementationSelectWidget({
    required this.implementations,
    this.selected,
    required this.onImplementationChanged,
    this.enabled = true,
  });

  final List<String> implementations;
  final String? selected;
  final void Function(String?) onImplementationChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget selectionWidget;

    if(implementations.isEmpty) {
      selectionWidget = TextFormField(
        enabled: enabled,
        initialValue: selected,
        style: theme.textTheme.bodySmall,
        decoration: const InputDecoration(
          label: Text('Implémentation'),
          border: OutlineInputBorder(),
          isCollapsed: true,
          constraints: BoxConstraints(maxHeight: 36.0),
          contentPadding: EdgeInsets.all(12.0),
        ),
        onChanged: (String? v) {
          onImplementationChanged(v);
        },
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        validator: (String? v) {
          if(v == null || v.isEmpty) return 'Valeur manquante';
          return null;
        },
      );
    }
    else {
      selectionWidget = DropdownMenuFormField(
        enabled: enabled,
        initialSelection: selected,
        requestFocusOnTap: true,
        expandedInsets: EdgeInsets.zero,
        textStyle: theme.textTheme.bodySmall,
        label: const Text('Implémentation'),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          isCollapsed: true,
          constraints: BoxConstraints(maxHeight: 36.0),
          contentPadding: EdgeInsets.all(12.0),
        ),
        dropdownMenuEntries: implementations
          .map((String i) => DropdownMenuEntry(value: i, label: i))
          .toList(),
        onSelected: (String? v) {
          onImplementationChanged(v);
        },
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        validator: (String? v) {
          if(v == null) return 'Valeur manquante';
          return null;
        },
      );
    }

    return SizedBox(
      width: 250,
      child: selectionWidget,
    );
  }
}

class _AdvantageMentorSkillWidget extends StatefulWidget {
  const _AdvantageMentorSkillWidget({
    required this.available,
    required this.skills,
    required this.onSkillsChanged,
  });

  final List<WizardSkillInstance> available;
  final List<WizardSkillInstance?> skills;
  final void Function(List<WizardSkillInstance?>) onSkillsChanged;

  @override
  State<_AdvantageMentorSkillWidget> createState() => _AdvantageMentorSkillWidgetState();
}

class _AdvantageMentorSkillWidgetState extends State<_AdvantageMentorSkillWidget> {
  late List<WizardSkillInstance?> currentSkills;
  TextEditingController firstSkillController = TextEditingController();
  TextEditingController secondSkillController = TextEditingController();

  @override
  void initState() {
    super.initState();

    currentSkills = List.generate(2, (int i) => null);
    currentSkills[0] = widget.skills.isNotEmpty ? widget.skills[0] : null;
    firstSkillController.text = currentSkills[0]?.title ?? "";
    currentSkills[1] = widget.skills.length > 1 ? widget.skills[1] : null;
    secondSkillController.text = currentSkills[1]?.title ?? "";

    if(currentSkills.length != widget.skills.length) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onSkillsChanged(currentSkills)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 16.0,
      children: [
        Text(
          "Compétences de l'avantage Mentor",
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 250,
          child: DropdownMenuFormField(
            initialSelection: currentSkills[0],
            controller: firstSkillController,
            requestFocusOnTap: true,
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            dropdownMenuEntries: widget.available
              .map((WizardSkillInstance i) => DropdownMenuEntry(value: i, label: i.title))
              .toList(),
            onSelected: (WizardSkillInstance? i) {
              if(i != null) {
                currentSkills[0] = WizardSkillInstance(
                  skill: i.skill,
                  implementation: i.implementation,
                  value: 1,
                );
              }
              else {
                currentSkills[0] = null;
              }
              widget.onSkillsChanged(currentSkills);
            },
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            validator: (WizardSkillInstance? i) {
              if(i == null) return 'Valeur manquante';
              return null;
            },
          ),
        ),
        SizedBox(
          width: 250,
          child: DropdownMenuFormField(
            initialSelection: currentSkills[1],
            controller: secondSkillController,
            requestFocusOnTap: true,
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            dropdownMenuEntries: widget.available
              .map((WizardSkillInstance i) => DropdownMenuEntry(
                value: i,
                label: i.title,
              ))
              .toList(),
            onSelected: (WizardSkillInstance? i) {
              if(i != null) {
                currentSkills[1] = WizardSkillInstance(
                  skill: i.skill,
                  implementation: i.implementation,
                  value: 1,
                );
              }
              else {
                currentSkills[1] = null;
              }
              widget.onSkillsChanged(currentSkills);
            },
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            validator: (WizardSkillInstance? i) {
              if(i == null) return 'Valeur manquante';
              return null;
            },
          ),
        )
      ],
    );
  }
}

class _AdvantageNaturalMagicWidget extends StatelessWidget {
  const _AdvantageNaturalMagicWidget({
    this.skill,
    required this.onSkillChanged,
    required this.advantageName,
  });

  final WizardSkillInstance? skill;
  final void Function(WizardSkillInstance?) onSkillChanged;
  final String advantageName;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 16.0,
      children: [
        Text(
          "Sphère de l'avantage $advantageName",
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 250,
          child: Column(
            spacing: 16.0,
            children: [
              _SingleSkillImplementationSelectWidget(
                implementations: WizardMagicSphereSkillWrapper().implementations,
                selected: skill?.implementation,
                onImplementationChanged: (String? v) {
                  if(v == null) {
                    onSkillChanged(null);
                  }
                  else {
                    var i = WizardSkillInstance(
                      skill: WizardMagicSphereSkillWrapper(),
                      implementation: v,
                      value: 2
                    );
                    onSkillChanged(i);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdvantageAugureSkillWidget extends StatefulWidget {
  const _AdvantageAugureSkillWidget({
    required this.augure,
    required this.available,
    required this.skills,
    required this.onSkillsChanged,
  });

  final Augure augure;
  final List<WizardSkillInstance> available;
  final List<WizardSkillInstance?> skills;
  final void Function(List<WizardSkillInstance?>) onSkillsChanged;

  @override
  State<_AdvantageAugureSkillWidget> createState() => _AdvantageAugureSkillWidgetState();
}

class _AdvantageAugureSkillWidgetState extends State<_AdvantageAugureSkillWidget> {
  WizardSkillWrapper? currentFirstSkill;
  TextEditingController firstSkillController = TextEditingController();
  String? currentFirstImplementation;
  TextEditingController firstImplementationController = TextEditingController();
  WizardSkillWrapper? currentSecondSkill;
  TextEditingController secondSkillController = TextEditingController();
  String? currentSecondImplementation;
  TextEditingController secondImplementationController = TextEditingController();
  bool secondImplementationEnabled = true;

  @override
  void initState() {
    super.initState();

    if(widget.skills.isNotEmpty) {
      currentFirstSkill = widget.skills[0]?.skill;
      currentFirstImplementation = widget.skills[0]?.implementation;
    }

    if(widget.skills.length > 1) {
      currentSecondSkill = widget.skills[1]?.skill;
      currentSecondImplementation = widget.skills[1]?.implementation;
    }

    if(widget.augure == Augure.chimere) {
      currentFirstSkill = WizardMagicSphereSkillWrapper();
      currentSecondSkill = WizardMagicSkillSkillWrapper();
      currentSecondImplementation = MagicSkill.instinctive.title;
      secondImplementationEnabled = false;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        firstSkillController.text = currentFirstSkill?.title ?? "";
        firstImplementationController.text = currentFirstImplementation ?? "";
        secondSkillController.text = currentSecondSkill?.title ?? "";
        secondImplementationController.text = currentSecondImplementation ?? "";
      }
    );
  }

  void finalizeSkills() {
    WizardSkillInstance? firstInstance;
    if(widget.augure == Augure.chimere && (currentFirstImplementation?.isNotEmpty ?? false)) {
      firstInstance = WizardSkillInstance(
          skill: WizardMagicSphereSkillWrapper(),
          implementation: currentFirstImplementation!,
          value: 1,
      );
    }
    else if(currentFirstSkill != null) {
      if(!currentFirstSkill!.requiresImplementation) {
        firstInstance = WizardSkillInstance(
            skill: currentFirstSkill!,
            value: 1
        );
      }
      else if(currentFirstImplementation?.isNotEmpty ?? false) {
        firstInstance = WizardSkillInstance(
            skill: currentFirstSkill!,
            implementation: currentFirstImplementation!,
            value: 1
        );
      }
    }

    WizardSkillInstance? secondInstance;
    if(widget.augure == Augure.chimere) {
      secondInstance = WizardSkillInstance(
        skill: WizardMagicSkillSkillWrapper(),
        implementation: MagicSkill.instinctive.title,
        value: 1,
      );
    }
    if(currentSecondSkill != null) {
      if(!currentSecondSkill!.requiresImplementation) {
        secondInstance = WizardSkillInstance(
            skill: currentSecondSkill!,
            value: 1
        );
      }
      else if(currentSecondImplementation?.isNotEmpty ?? false) {
        secondInstance = WizardSkillInstance(
            skill: currentSecondSkill!,
            implementation: currentSecondImplementation!,
            value: 1,
        );
      }
    }

    widget.onSkillsChanged([firstInstance, secondInstance]);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<WizardSkillWrapper> availableFirst;
    List<WizardSkillWrapper> availableSecond;

    switch(widget.augure) {
      case Augure.none:
        availableFirst = [];
        availableSecond = [];
      case Augure.fataliste:
        availableFirst = Skill.fromFamily(SkillFamily.influence)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
        availableSecond = Skill.fromFamily(SkillFamily.communication)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
      case Augure.volcan:
        availableFirst = Skill.fromFamily(SkillFamily.combat)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
        availableSecond = Skill.fromFamily(SkillFamily.combat)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
      case Augure.metal:
        availableFirst = Skill.fromFamily(SkillFamily.combat)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
        availableSecond = Skill.fromFamily(SkillFamily.technique)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
      case Augure.cite:
        availableFirst = Skill.fromFamily(SkillFamily.communication)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
        availableSecond = Skill.fromFamily(SkillFamily.communication)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
      case Augure.vent:
        availableFirst = Skill.fromFamily(SkillFamily.mouvement)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
        availableSecond = Skill.fromFamily(SkillFamily.mouvement)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
      case Augure.ocean:
        availableFirst = Skill.fromFamily(SkillFamily.theorie)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
        availableSecond = Skill.fromFamily(SkillFamily.pratique)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
      case Augure.chimere:
        availableFirst = [
            WizardMagicSphereSkillWrapper(),
          ];
        availableSecond = [
            WizardMagicSkillSkillWrapper(),
          ];
      case Augure.nature:
        availableFirst = Skill.fromFamily(SkillFamily.mouvement)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
        availableSecond = Skill.fromFamily(SkillFamily.pratique)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
      case Augure.pierre:
        availableFirst = Skill.fromFamily(SkillFamily.combat)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
        availableSecond = Skill.fromFamily(SkillFamily.influence)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
      case Augure.homme:
        availableFirst = Skill.fromFamily(SkillFamily.communication)
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
        availableSecond = Skill.values
            .where((Skill s) => s.canInstantiate)
            .map((Skill s) => WizardStandardSkillWrapper(skill: s))
            .toList();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Text(
          "Compétences de l'avantage Augure Favorable",
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 250,
          child: Column(
            spacing: 16.0,
            children: [
              DropdownMenuFormField<WizardSkillWrapper>(
                controller: firstSkillController,
                initialSelection: currentFirstSkill,
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                textStyle: theme.textTheme.bodySmall,
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  constraints: BoxConstraints(maxHeight: 36.0),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                dropdownMenuEntries: availableFirst
                    .map((WizardSkillWrapper w) => DropdownMenuEntry(value: w, label: w.title))
                    .toList(),
                onSelected: (WizardSkillWrapper? w) {
                  setState(() {
                    currentFirstSkill = w;
                  });
                  finalizeSkills();
                },
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                validator: (WizardSkillWrapper? w) {
                  if(w == null) return 'Valeur manquante';
                  return null;
                },
              ),
              if(currentFirstSkill != null && currentFirstSkill!.requiresImplementation)
                _SingleSkillImplementationSelectWidget(
                  implementations: currentFirstSkill!.implementations,
                  selected: currentFirstImplementation,
                  onImplementationChanged: (String? v) {
                    currentFirstImplementation = v;
                    finalizeSkills();
                  },
                ),
            ],
          ),
        ),
        SizedBox(
          width: 250,
          child: Column(
            spacing: 16.0,
            children: [
              DropdownMenuFormField<WizardSkillWrapper>(
                controller: secondSkillController,
                initialSelection: currentSecondSkill,
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                textStyle: theme.textTheme.bodySmall,
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  constraints: BoxConstraints(maxHeight: 36.0),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                dropdownMenuEntries: availableSecond
                    .map((WizardSkillWrapper w) => DropdownMenuEntry(value: w, label: w.title))
                    .toList(),
                onSelected: (WizardSkillWrapper? w) {
                  setState(() {
                    currentSecondSkill = w;
                  });
                  finalizeSkills();
                },
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                validator: (WizardSkillWrapper? w) {
                  if(w == null) return 'Valeur manquante';
                  return null;
                },
              ),
              if(currentSecondSkill != null && currentSecondSkill!.requiresImplementation)
                _SingleSkillImplementationSelectWidget(
                  enabled: secondImplementationEnabled,
                  implementations: currentSecondSkill!.implementations,
                  selected: currentSecondImplementation,
                  onImplementationChanged: (String? v) {
                    currentSecondImplementation = v;
                    finalizeSkills();
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

const _casteBaseSkills = <Caste, List<List<WizardSkillWrapper>>>{
  Caste.artisan: [
    [
      WizardStandardSkillWrapper(skill: Skill.connaissanceDesAnimaux),
      WizardStandardSkillWrapper(skill: Skill.dressage),
      WizardStandardSkillWrapper(skill: Skill.matieresPremieres)
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.armesArticulees),
      WizardStandardSkillWrapper(skill: Skill.armesContondantes),
      WizardStandardSkillWrapper(skill: Skill.armesDeJet),
      WizardStandardSkillWrapper(skill: Skill.armesTranchantes),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.donArtistique),
      WizardStandardSkillWrapper(skill: Skill.marchandage)
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.artisanat),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.artisanat),
    ]
  ],
  Caste.combattant: [
    [
      WizardStandardSkillWrapper(skill: Skill.bouclier),
      WizardStandardSkillWrapper(skill: Skill.armesArticulees),
      WizardStandardSkillWrapper(skill: Skill.armesDeChoc),
      WizardStandardSkillWrapper(skill: Skill.armesContondantes),
      WizardStandardSkillWrapper(skill: Skill.armesDeJet),
      WizardStandardSkillWrapper(skill: Skill.armesTranchantes),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.armesArticulees),
      WizardStandardSkillWrapper(skill: Skill.armesDeChoc),
      WizardStandardSkillWrapper(skill: Skill.armesContondantes),
      WizardStandardSkillWrapper(skill: Skill.armesDoubles),
      WizardStandardSkillWrapper(skill: Skill.armesDeJet),
      WizardStandardSkillWrapper(skill: Skill.armesTranchantes),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.artisanat),
      WizardStandardSkillWrapper(skill: Skill.corpsACorps),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.athletisme),
      WizardStandardSkillWrapper(skill: Skill.commandement),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.esquive),
    ]
  ],
  Caste.commercant: [
    [
      WizardStandardSkillWrapper(skill: Skill.baratin),
      WizardStandardSkillWrapper(skill: Skill.seduction),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.estimation),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.geographie),
      WizardStandardSkillWrapper(skill: Skill.vieEnCite),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.lireEtEcrire),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.marchandage),
    ]
  ],
  Caste.mage: [
    [
      WizardStandardSkillWrapper(skill: Skill.corpsACorps),
      WizardStandardSkillWrapper(skill: Skill.armesArticulees),
      WizardStandardSkillWrapper(skill: Skill.armesContondantes),
      WizardStandardSkillWrapper(skill: Skill.armesTranchantes),
      WizardMagicSphereSkillWrapper(),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.artDeLaScene),
      WizardStandardSkillWrapper(skill: Skill.donArtistique),
      WizardMagicSkillSkillWrapper(),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.connaissanceDeLaMagie),
    ],
    [
      WizardMagicSkillSkillWrapper(),
    ],
    [
      WizardMagicSphereSkillWrapper(),
    ]
  ],
  Caste.erudit: [
    [
      WizardStandardSkillWrapper(skill: Skill.connaissanceDeLaMagie),
      WizardStandardSkillWrapper(skill: Skill.connaissanceDesDragons),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.castes),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.diplomatie),
      WizardStandardSkillWrapper(skill: Skill.psychologie),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.geographie),
      WizardStandardSkillWrapper(skill: Skill.histoire),
      WizardStandardSkillWrapper(skill: Skill.lois),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.lireEtEcrire),
    ]
  ],
  Caste.prodige: [
    [
      WizardStandardSkillWrapper(skill: Skill.armesDoubles),
      WizardStandardSkillWrapper(skill: Skill.corpsACorps),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.connaissanceDesDragons),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.esquive),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.herboristerie),
      WizardStandardSkillWrapper(skill: Skill.medecine),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.premiersSoins),
    ],
  ],
  Caste.protecteur: [
    [
      WizardStandardSkillWrapper(skill: Skill.armesArticulees),
      WizardStandardSkillWrapper(skill: Skill.armesDeChoc),
      WizardStandardSkillWrapper(skill: Skill.armesContondantes),
      WizardStandardSkillWrapper(skill: Skill.armesDHast),
      WizardStandardSkillWrapper(skill: Skill.armesDoubles),
      WizardStandardSkillWrapper(skill: Skill.armesTranchantes),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.athletisme),
      WizardStandardSkillWrapper(skill: Skill.equitation),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.bouclier),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.castes),
      WizardStandardSkillWrapper(skill: Skill.strategie),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.commandement),
      WizardStandardSkillWrapper(skill: Skill.lois),
    ]
  ],
  Caste.voyageur: [
    [
      WizardStandardSkillWrapper(skill: Skill.armesAProjectiles),
      WizardStandardSkillWrapper(skill: Skill.armesArticulees),
      WizardStandardSkillWrapper(skill: Skill.armesContondantes),
      WizardStandardSkillWrapper(skill: Skill.armesDeJet),
      WizardStandardSkillWrapper(skill: Skill.armesTranchantes),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.athletisme),
      WizardStandardSkillWrapper(skill: Skill.attelages),
      WizardStandardSkillWrapper(skill: Skill.equitation),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.cartographie),
      WizardStandardSkillWrapper(skill: Skill.conte),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.geographie),
    ],
    [
      WizardStandardSkillWrapper(skill: Skill.orientation),
    ]
  ]
};