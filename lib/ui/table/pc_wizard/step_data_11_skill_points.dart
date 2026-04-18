import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/caste/base.dart';
import '../../../classes/caste/character_caste.dart';
import '../../../classes/caste/privileges.dart';
import '../../../classes/character/advantages.dart';
import '../../../classes/entity/abilities.dart';
import '../../../classes/entity/attributes.dart';
import '../../../classes/entity/skill.dart';
import '../../../classes/entity/skill_family.dart';
import '../../../classes/entity/skill_instance.dart';
import '../../../classes/human_character.dart';
import '../../../classes/magic.dart';
import '../../../classes/magic_spell.dart';
import '../../utils/entity/base/skill_picker_dialog.dart';
import '../../utils/entity/magic/display_magic_spell_widget.dart';
import '../../utils/entity/magic/spell_picker_dialog.dart';
import '../../utils/uniform_height_wrap.dart';
import 'enums.dart';
import 'model.dart';
import 'step_data.dart';
import 'utils.dart';

class PlayerCharacterWizardStepDataSkillPoints extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataSkillPoints({
    this.privileges,
    this.augmentationSkills,
    this.augmentationStarterSpecialization,
    this.augmentationMagicSkills,
    this.additionalMagicPool,
    this.augmentationMagicSpheres,
    this.spells,
    this.advantageSpell,
    this.renown,
  })
    : super(title: 'Augmentations')
  {
    currentPrivileges = privileges != null
        ? List.from(privileges!)
        : <CharacterCastePrivilege>[];

    currentAugmentationSkills = augmentationSkills != null
        ? List.from(augmentationSkills!)
        : <WizardSkillInstance>[];
    currentAugmentationStarterSpecialization = augmentationStarterSpecialization;

    currentAugmentationMagicSkills = augmentationMagicSkills != null
        ? List.from(augmentationMagicSkills!)
        : <WizardSkillInstance>[];
    currentAdditionalMagicPool = additionalMagicPool ?? 0;
    currentAugmentationMagicSpheres = augmentationMagicSpheres != null
        ? List.from(augmentationMagicSpheres!)
        : <WizardSkillInstance>[];
    currentSpells = spells != null
        ? List.from(spells!)
        : <MagicSpell>[];
    currentAdvantageSpell = advantageSpell;

    currentRenown = renown ?? 0;
  }

  List<CharacterCastePrivilege>? privileges;
  late List<CharacterCastePrivilege> currentPrivileges;
  List<WizardSkillInstance>? augmentationSkills;
  late List<WizardSkillInstance> currentAugmentationSkills;
  WizardSkillInstance? augmentationStarterSpecialization;
  late WizardSkillInstance? currentAugmentationStarterSpecialization;
  List<WizardSkillInstance>? augmentationMagicSkills;
  late List<WizardSkillInstance> currentAugmentationMagicSkills;
  int? additionalMagicPool;
  late int currentAdditionalMagicPool;
  List<WizardSkillInstance>? augmentationMagicSpheres;
  late List<WizardSkillInstance> currentAugmentationMagicSpheres;
  List<MagicSpell>? spells;
  late List<MagicSpell> currentSpells;
  MagicSpell? advantageSpell;
  MagicSpell? currentAdvantageSpell;
  int? renown;
  late int currentRenown;

  @override
  Widget overviewWidget(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    return [
      SliverPersistentHeader(
        pinned: true,
        delegate: _RemainingSkillPointsHeader(
          height: 60.0,
        ),
      ),
      sliverWrap(
        [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32.0,
            children: [
              _AugmentationsWidget(
                privileges: currentPrivileges,
                onPrivilegesUpdated: (List<CharacterCastePrivilege> l) {
                  currentPrivileges = l;
                  changed = true;
                },
                skills: currentAugmentationSkills,
                onSkillsChanged: (List<WizardSkillInstance> l) {
                  currentAugmentationSkills = l;
                  changed = true;
                },
                specialization: currentAugmentationStarterSpecialization,
                onSpecializationChanged: (WizardSkillInstance? i) {
                  currentAugmentationStarterSpecialization = i;
                  changed =
                      changed
                      || augmentationStarterSpecialization?.implementation != currentAugmentationStarterSpecialization?.implementation
                      || augmentationStarterSpecialization?.specialization != currentAugmentationStarterSpecialization?.specialization
                      || augmentationStarterSpecialization?.value != currentAugmentationStarterSpecialization?.value;
                },
                magicSkills: currentAugmentationMagicSkills,
                onMagicSkillsChanged: (List<WizardSkillInstance> l) {
                  currentAugmentationMagicSkills = l;
                  changed = true;
                },
                additionalMagicPool: currentAdditionalMagicPool,
                onAdditionalMagicPoolChanged: (int v) {
                  currentAdditionalMagicPool = v;
                  changed = currentAdditionalMagicPool != additionalMagicPool;
                },
                spheres: currentAugmentationMagicSpheres,
                onSpheresChanged: (List<WizardSkillInstance> l) {
                  currentAugmentationMagicSpheres = l;
                  changed = true;
                },
                spells: currentSpells,
                onSpellsUpdated: (List<MagicSpell> l) {
                  currentSpells = l;
                  changed = true;
                },
                advantageSpell: currentAdvantageSpell,
                onAdvantageSpellChanged: (MagicSpell? s) {
                  currentAdvantageSpell = s;
                  changed = changed || currentAdvantageSpell != advantageSpell;
                },
                renown: currentRenown,
                onRenownChanged: (int v) {
                  currentRenown = v;
                  changed = changed || currentRenown != renown;
                },
              )
            ],
          )
        ]
      )
    ];
  }

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) {
    var errors = <String>[];

    if(model.remainingXP > 0) {
      errors.add('Tous les Points de Compétences doivent être dépensés');
    }

    if(model.caste! == Caste.mage && (model.spells?.length ?? 0) < 1) {
      errors.add("Le premier sort de mage n'a pas été choisi");
    }

    bool hasAdvantageNaturalMagic = (model.advantages ?? <CharacterAdvantage>[])
        .any((CharacterAdvantage a) => a.advantage == Advantage.magieNaturelle);
    bool hasAdvantageIntuitiveMagic = (model.advantages ?? <CharacterAdvantage>[])
        .any((CharacterAdvantage a) => a.advantage == Advantage.magieIntuitive);
    if(hasAdvantageIntuitiveMagic || hasAdvantageNaturalMagic) {
      var advantageName = hasAdvantageIntuitiveMagic
          ? "Magie Intuitive"
          : "Magie Naturelle";
      errors.add("Le sort de l'avantage $advantageName n'a pas été choisi");
    }

    if(errors.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Étape incomplète'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              for(var e in errors)
                Text(
                  "\u2022 $e",
                )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('OK'),
            )
          ]
        )
      );
    }

    return errors.isEmpty;
  }

  @override
  void init(PlayerCharacterWizardModel model) {
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    model.usedXP = 0;

    privileges = null;
    currentPrivileges = <CharacterCastePrivilege>[];
    model.privileges = null;

    augmentationSkills = null;
    currentAugmentationSkills = <WizardSkillInstance>[];
    model.augmentationSkills = null;

    augmentationStarterSpecialization = null;
    currentAugmentationStarterSpecialization = null;
    model.augmentationStarterSpecialization = null;

    augmentationMagicSkills = null;
    currentAugmentationMagicSkills = <WizardSkillInstance>[];
    model.augmentationMagicSkills = null;

    additionalMagicPool = null;
    currentAdditionalMagicPool = 0;
    model.additionalMagicPool = 0;

    augmentationMagicSpheres = null;
    currentAugmentationMagicSpheres = <WizardSkillInstance>[];
    model.augmentationMagicSpheres = null;

    spells = null;
    currentSpells = <MagicSpell>[];
    model.spells = null;

    advantageSpell = null;
    currentAdvantageSpell = null;
    model.advantageSpell = null;

    renown = null;
    currentRenown = 0;
    model.renown = 0;
  }

  @override
  void clear() {
    currentPrivileges = privileges != null
        ? List.from(privileges!)
        : <CharacterCastePrivilege>[];

    currentAugmentationSkills = augmentationSkills != null
        ? List.from(augmentationSkills!)
        : <WizardSkillInstance>[];
    currentAugmentationStarterSpecialization = augmentationStarterSpecialization;

    currentAugmentationMagicSkills = augmentationMagicSkills != null
        ? List.from(augmentationMagicSkills!)
        : <WizardSkillInstance>[];

    currentAdditionalMagicPool = additionalMagicPool ?? 0;

    currentAugmentationMagicSpheres = augmentationMagicSpheres != null
        ? List.from(augmentationMagicSpheres!)
        : <WizardSkillInstance>[];

    currentSpells = spells != null
        ? List.from(spells!)
        : <MagicSpell>[];

    currentAdvantageSpell = advantageSpell;

    currentRenown = renown ?? 0;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    privileges = currentPrivileges;
    model.privileges = privileges;
    currentPrivileges = List.from(privileges!);

    augmentationSkills = currentAugmentationSkills;
    model.augmentationSkills = augmentationSkills;
    currentAugmentationSkills = List.from(augmentationSkills!);

    augmentationStarterSpecialization = currentAugmentationStarterSpecialization;
    model.augmentationStarterSpecialization = augmentationStarterSpecialization;

    augmentationMagicSkills = currentAugmentationMagicSkills;
    model.augmentationMagicSkills = augmentationMagicSkills;
    currentAugmentationMagicSkills = List.from(augmentationMagicSkills!);

    additionalMagicPool = currentAdditionalMagicPool;
    model.additionalMagicPool = additionalMagicPool!;

    augmentationMagicSpheres = currentAugmentationMagicSpheres;
    model.augmentationMagicSpheres = augmentationMagicSpheres;
    currentAugmentationMagicSpheres = List.from(augmentationMagicSpheres!);

    spells = currentSpells;
    model.spells = spells;
    currentSpells = List.from(spells!);

    advantageSpell = currentAdvantageSpell;
    model.advantageSpell = advantageSpell;

    renown = currentRenown;
    model.renown = renown!;
  }
}

class _AugmentationsWidget extends StatelessWidget {
  const _AugmentationsWidget({
    required this.skills,
    required this.onSkillsChanged,
    this.specialization,
    required this.onSpecializationChanged,
    required this.privileges,
    required this.onPrivilegesUpdated,
    required this.magicSkills,
    required this.onMagicSkillsChanged,
    required this.additionalMagicPool,
    required this.onAdditionalMagicPoolChanged,
    required this.spheres,
    required this.onSpheresChanged,
    required this.spells,
    required this.onSpellsUpdated,
    required this.advantageSpell,
    required this.onAdvantageSpellChanged,
    required this.renown,
    required this.onRenownChanged,
  });

  final List<CharacterCastePrivilege> privileges;
  final void Function(List<CharacterCastePrivilege>) onPrivilegesUpdated;

  final List<WizardSkillInstance> skills;
  final void Function(List<WizardSkillInstance>) onSkillsChanged;
  final WizardSkillInstance? specialization;
  final void Function(WizardSkillInstance?) onSpecializationChanged;

  final List<WizardSkillInstance> magicSkills;
  final void Function(List<WizardSkillInstance>) onMagicSkillsChanged;
  final int additionalMagicPool;
  final void Function(int) onAdditionalMagicPoolChanged;
  final List<WizardSkillInstance> spheres;
  final void Function(List<WizardSkillInstance>) onSpheresChanged;
  final List<MagicSpell> spells;
  final void Function(List<MagicSpell>) onSpellsUpdated;
  final MagicSpell? advantageSpell;
  final void Function(MagicSpell?) onAdvantageSpellChanged;
  final int renown;
  final void Function(int) onRenownChanged;

  @override
  Widget build(BuildContext context) {
    var model = context.read<PlayerCharacterWizardModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24.0,
      children: [
        _PrivilegesSelectionWidget(
          caste: model.caste!,
          privileges: privileges,
          onUpdated: (List<CharacterCastePrivilege> l) =>
            onPrivilegesUpdated(l),
        ),
        _SkillsWidget(
          skills: skills,
          onChanged: onSkillsChanged,
          specialization: specialization ?? WizardSkillInstance(
            skill: model.starterSpecialization!.skill,
            implementation: model.starterSpecialization!.implementation,
            specialization: model.starterSpecialization!.specialization!,
            value: 0,
          ),
          onSpecializationChanged: onSpecializationChanged,
        ),
        _MagicWidget(
          magicSkills: magicSkills,
          onSkillsChanged: onMagicSkillsChanged,
          additionalPool: additionalMagicPool,
          onAdditionalPoolChanged: onAdditionalMagicPoolChanged,
          spheres: spheres,
          onSpheresChanged: onSpheresChanged,
          spells: spells,
          onSpellsUpdated: onSpellsUpdated,
          advantageSpell: advantageSpell,
          onAdvantageSpellChanged: onAdvantageSpellChanged,
        ),
        _RenownWidget(
          renown: renown,
          onChanged: onRenownChanged,
        ),
      ],
    );
  }
}

class _RemainingSkillPointsHeader extends SliverPersistentHeaderDelegate {
  const _RemainingSkillPointsHeader({
    required this.height,
  });

  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(covariant _RemainingSkillPointsHeader oldDelegate) =>
      height != oldDelegate.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _RemainingSkillPointsWidget();
  }
}

class _RemainingSkillPointsWidget extends StatelessWidget {
  const _RemainingSkillPointsWidget();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.watch<PlayerCharacterWizardModel>();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "Points de Compétence restants : ${model.remainingXP}",
          style: theme.textTheme.headlineMedium!
            .copyWith(fontWeight: FontWeight.bold),
        )
      ),
    );
  }
}

class _PrivilegesSelectionWidget extends StatefulWidget {
  const _PrivilegesSelectionWidget({
    required this.caste,
    required this.privileges,
    required this.onUpdated,
  });

  final Caste caste;
  final List<CharacterCastePrivilege> privileges;
  final void Function(List<CharacterCastePrivilege>) onUpdated;

  @override
  State<_PrivilegesSelectionWidget> createState() => _PrivilegesSelectionWidgetState();
}

class _PrivilegesSelectionWidgetState extends State<_PrivilegesSelectionWidget> {
  late List<CharacterCastePrivilege> current;
  Set<CastePrivilege> uniquePrivileges = <CastePrivilege>{};

  @override
  void initState() {
    super.initState();

    current = List.from(widget.privileges);
  }

  void updateUniquePrivileges() {
    uniquePrivileges.clear();
    for(var p in current) {
      if(p.privilege.unique) {
        uniquePrivileges.add(p.privilege);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.watch<PlayerCharacterWizardModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Text(
          "Privilèges",
          style: theme.textTheme.headlineMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "Les Privilèges sont des techniques enseignées par les Maîtres de caste afin de perfectionner le citoyen dans la maîtrise de son art. Il s’agit parfois d’avantages matériels mais le plus souvent, les Privilèges sont des facultés quasiment intuitives, si profondément ancrées dans l’esprit du personnage qu’elles en deviennent presque surnaturelles.\nLes Privilèges sont réservés aux membres des castes concernées, mais certains ont été jugés utiles par d’autres castes et également enseignés.\nLes Privilèges sont achetés avec les Points de Compétence, à raison de TROIS fois le coût indiqué entre parenthèses."
          ),
        ),
        for(var p in current)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 8.0,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${p.privilege.title} (${p.cost.toString()})',
                              style: theme.textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                            ),
                            if(p.description?.isNotEmpty ?? false)
                              Text(
                                p.description!,
                                style: theme.textTheme.bodyMedium!
                                  .copyWith(fontStyle: FontStyle.italic)
                              ),
                            Text(
                              p.privilege.description,
                            )
                          ],
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            model.usedXP -= 3 * p.cost;
                            setState(() {
                              current.remove(p);
                            });
                            updateUniquePrivileges();
                            widget.onUpdated(current);
                          },
                          child: Icon(
                            Icons.cancel,
                            size: 18.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton.filled(
            onPressed: () async {
              var p = await showDialog<CharacterCastePrivilege>(
                context: context,
                builder: (BuildContext context) =>
                  _PrivilegeSelectionDialog(
                    caste: widget.caste,
                    exclude: uniquePrivileges.toList(),
                    maxCost: model.remainingXP,
                  ),
              );
              if(p == null) return;
              if(!context.mounted) return;

              setState(() {
                current.add(p);
              });
              model.usedXP += 3 * p.cost;
              updateUniquePrivileges();
              widget.onUpdated(current);
            },
            iconSize: 18.0,
            padding: const EdgeInsets.all(8.0),
            constraints: BoxConstraints(),
            icon: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _PrivilegeSelectionDialog extends StatefulWidget {
  const _PrivilegeSelectionDialog({
    required this.caste,
    required this.exclude,
    required this.maxCost,
  });

  final Caste caste;
  final List<CastePrivilege> exclude;
  final int maxCost;

  @override
  State<_PrivilegeSelectionDialog> createState() => _PrivilegeSelectionDialogState();
}

class _PrivilegeSelectionDialogState extends State<_PrivilegeSelectionDialog> {
  late List<CastePrivilege> privileges;
  CastePrivilege? viewing;
  CastePrivilege? privilege;
  List<int> costs = <int>[];
  int? cost;
  String? details;
  CharacterCastePrivilege? selected;

  @override
  void initState() {
    super.initState();

    privileges = CastePrivilege.values
        .where(
            (CastePrivilege p) =>
                p.caste == widget.caste
                && p.cost.any((int c) => 3*c <= widget.maxCost)
                && !widget.exclude.contains(p)
        )
        .toList();
  }

  bool _canFinish() {
    if(privilege == null) return false;
    if(costs.isEmpty) return false;
    if(cost == null && costs.length > 1) return false;
    if(privilege!.requireDetails && details == null) return false;

    return true;
  }

  void _prepareFinish() {
    if(!_canFinish()) return;

    selected = CharacterCastePrivilege(
      privilege: privilege!,
      selectedCost: cost ?? costs[0],
      description: details,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Choix du Privilège"),
      content: SizedBox(
        width: 800,
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(privilege == null)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: privileges.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(privileges[index].title),
                            onTap: () => setState(() {
                              viewing = privileges[index];
                            }),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => Divider(),
                      ),
                    ),
                    Expanded(
                      child: viewing == null
                          ? SizedBox.shrink()
                          : _PrivilegeSelectionWidget(
                              privilege: viewing!,
                              onSelected: () => setState(() {
                                privilege = viewing;
                                costs = privilege!.cost
                                  .where((int c) => 3*c <= widget.maxCost)
                                  .toList();

                                if(_canFinish()) {
                                  _prepareFinish();
                                  Navigator.of(context, rootNavigator: true).pop(selected!);
                                }
                              }),
                            ),
                    ),
                  ],
                ),
              ),
            if(privilege != null && (costs.isNotEmpty || privilege!.requireDetails))
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: _PrivilegeSelectionWidget(
                        privilege: viewing!,
                        costs: costs,
                        onSelected: () {},
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.0,
                        children: [
                          Text(
                            'Privilège : ${privilege!.title}',
                            style: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            spacing: 12.0,
                            children: [
                              Text(
                                'Coût',
                                style: theme.textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 80,
                                child: DropdownMenu<int>(
                                  requestFocusOnTap: true,
                                  expandedInsets: EdgeInsets.zero,
                                  textStyle: theme.textTheme.bodySmall,
                                  inputDecorationTheme: const InputDecorationTheme(
                                    border: OutlineInputBorder(),
                                    isCollapsed: true,
                                    constraints: BoxConstraints(maxHeight: 36.0),
                                    contentPadding: EdgeInsets.all(12.0),
                                  ),
                                  dropdownMenuEntries: costs
                                      .where((int c) => c <= widget.maxCost)
                                      .map((int c) => DropdownMenuEntry(
                                          value: c, label: c.toString()
                                      ))
                                      .toList(),
                                  onSelected: (int? v) {
                                    if(v == null) return;
                                    setState(() {
                                      cost = v;
                                      _prepareFinish();
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          if(privilege!.requireDetails)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8.0,
                                children: [
                                  Text(
                                    'Détails',
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        isCollapsed: true,
                                        constraints: BoxConstraints(maxHeight: 36.0),
                                        contentPadding: EdgeInsets.all(12.0),
                                      ),
                                      minLines: 1,
                                      maxLines: 3,
                                      onChanged: (String? v) {
                                        if(v == null || v.isEmpty) return;
                                        setState(() {
                                          details = v;
                                          _prepareFinish();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: selected == null ? null : () {
            Navigator.of(context, rootNavigator: true).pop(selected!);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _PrivilegeSelectionWidget extends StatelessWidget {
  const _PrivilegeSelectionWidget({
    required this.privilege,
    this.costs,
    required this.onSelected,
  });

  final CastePrivilege privilege;
  final List<int>? costs;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => onSelected(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8.0,
              children: [
                Text(
                  '${privilege.title} (${(costs ?? privilege.cost).join("/")})',
                  style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  privilege.description,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SingleSkillWidget extends StatefulWidget {
  const _SingleSkillWidget({
    required this.title,
    required this.initialValue,
    this.baseValue = 0,
    this.maxValue = 10,
    required this.costMultiplier,
    required this.onChanged,
    this.enabled = true,
  });

  final String title;
  final int initialValue;
  final int baseValue;
  final int maxValue;
  final double costMultiplier;
  final void Function(int value, int cost) onChanged;
  final bool enabled;

  @override
  State<_SingleSkillWidget> createState() => _SingleSkillWidgetState();
}

class _SingleSkillWidgetState extends State<_SingleSkillWidget> {
  late int currentValue;

  @override
  void initState() {
    super.initState();

    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.watch<PlayerCharacterWizardModel>();

    var ageMaxValue = 0;
    switch(model.age!) {
      case PlayerCharacterWizardAge.enfant:
        ageMaxValue = 6;
      case PlayerCharacterWizardAge.adolescent:
        ageMaxValue = 7;
      case PlayerCharacterWizardAge.adulte:
        ageMaxValue = 8;
      case PlayerCharacterWizardAge.ancien:
        ageMaxValue = 9;
      case PlayerCharacterWizardAge.venerable:
        ageMaxValue = 10;
    }

    var effectiveMaxValue = max(ageMaxValue, widget.baseValue);

    var entries = <DropdownMenuEntry<int>>[];
    for(int v in List.generate(effectiveMaxValue - widget.baseValue + 1, (int i) => i)) {
      var cost = skillUpgradeCost(currentValue, v + widget.baseValue, multiplier: widget.costMultiplier);
      if(cost <= model.remainingXP) {
        entries.add(
            DropdownMenuEntry(
              value: v + widget.baseValue,
              label: '${v + widget.baseValue} (${skillUpgradeCost(currentValue, v + widget.baseValue, multiplier: widget.costMultiplier)} pts)'
            )
        );
      }
    }

    return Row(
      spacing: 8.0,
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.end,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: BoxBorder.fromLTRB(
                bottom: BorderSide(color: Colors.black26)
              )
            ),
            child: Text(' '),
          )
        ),
        SizedBox(
          width: 130,
          child: DropdownMenu<int>(
            enabled: widget.enabled,
            initialSelection: currentValue,
            requestFocusOnTap: true,
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            dropdownMenuEntries: entries,
            onSelected: (int? v) {
              if(v == null) return;
              widget.onChanged(v - widget.baseValue, skillUpgradeCost(currentValue, v, multiplier: widget.costMultiplier));
              setState(() {
                currentValue = v;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _SkillsWidget extends StatefulWidget {
  const _SkillsWidget({
    required this.skills,
    required this.onChanged,
    required this.specialization,
    required this.onSpecializationChanged,
  });

  final List<WizardSkillInstance> skills;
  final void Function(List<WizardSkillInstance>) onChanged;
  final WizardSkillInstance specialization;
  final void Function(WizardSkillInstance?) onSpecializationChanged;

  @override
  State<_SkillsWidget> createState() => _SkillsWidgetState();
}

class _SkillsWidgetState extends State<_SkillsWidget> {
  late Map<Attribute, List<WizardSkillInstance>> currentSkills = <Attribute, List<WizardSkillInstance>>{};

  @override
  void initState() {
    super.initState();

    for(var a in Attribute.values) {
      currentSkills[a] = <WizardSkillInstance>[];
    }

    for(var i in widget.skills) {
      if(i.skill is! WizardStandardSkillWrapper) continue;
      var si = i.skill as WizardStandardSkillWrapper;
      if(!currentSkills.containsKey(si.skill.family.defaultAttribute)) continue;
      currentSkills[si.skill.family.defaultAttribute]!.add(i);
    }
  }

  void mergeAndNotify() {
    var merged = <WizardSkillInstance>[];
    for(var v in currentSkills.values) {
      merged.addAll(v);
    }
    widget.onChanged(merged);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var groupWidth = 450.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Text(
          "Compétences",
          style: theme.textTheme.headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "Une fois les valeurs de base attribuées, on considère que les Compétences sont développées. Les Points de Compétence servent à les “augmenter”. Ils se gèrent et se dépensent comme les Points d’Expérience. De ce fait, il faut tenir compte des restrictions susceptibles de doubler le coût en points nécessaires.\nAttention ! Dans le cas où un personnage choisit de développer une Compéience réservée appartenant à une autre caste que la sienne, il devra dépenser deux fois plus de points. De plus, toutes les Compétences interdites qui pourraient être acquises à la création voient leur coût systématiquement doublé.\nExemple : un érudit souhaite développer Médecine, qui est une Compétence réservée pour sa caste. Il désire un score de 5. Il doit donc dépenser 15 points. Si un mage tente d'acquérir le même savoir-faire dans son entourage de sorciers, il lui en coûtera 80 points."
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: UniformHeightWrap(
            spacing: 16.0,
            runSpacing: 12.0,
            children: [
              SizedBox(
                width: groupWidth,
                child: _SkillGroupWidget(
                  attribute: Attribute.physique,
                  skills: widget.skills,
                  onChanged: (List<WizardSkillInstance> l) {
                    setState(() {
                      currentSkills[Attribute.physique] = l;
                    });
                    mergeAndNotify();
                  },
                  specialization: widget.specialization,
                  onSpecializationChanged: widget.onSpecializationChanged,
                ),
              ),
              SizedBox(
                width: groupWidth,
                child: _SkillGroupWidget(
                  attribute: Attribute.mental,
                  skills: widget.skills,
                  onChanged: (List<WizardSkillInstance> l) {
                    setState(() {
                      currentSkills[Attribute.mental] = l;
                    });
                    mergeAndNotify();
                  },
                  specialization: widget.specialization,
                  onSpecializationChanged: widget.onSpecializationChanged,
                ),
              ),
              SizedBox(
                width: groupWidth,
                child: _SkillGroupWidget(
                  attribute: Attribute.manuel,
                  skills: widget.skills,
                  onChanged: (List<WizardSkillInstance> l) {
                    setState(() {
                      currentSkills[Attribute.manuel] = l;
                    });
                    mergeAndNotify();
                  },
                  specialization: widget.specialization,
                  onSpecializationChanged: widget.onSpecializationChanged,
                ),
              ),
              SizedBox(
                width: groupWidth,
                child: _SkillGroupWidget(
                  attribute: Attribute.social,
                  skills: widget.skills,
                  onChanged: (List<WizardSkillInstance> l) {
                    setState(() {
                      currentSkills[Attribute.social] = l;
                    });
                    mergeAndNotify();
                  },
                  specialization: widget.specialization,
                  onSpecializationChanged: widget.onSpecializationChanged,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _SkillGroupWidget extends StatefulWidget {
  const _SkillGroupWidget({
    required this.attribute,
    required this.skills,
    required this.onChanged,
    required this.specialization,
    required this.onSpecializationChanged,
  });

  final Attribute attribute;
  final List<WizardSkillInstance> skills;
  final void Function(List<WizardSkillInstance>) onChanged;
  final WizardSkillInstance specialization;
  final void Function(WizardSkillInstance?) onSpecializationChanged;

  @override
  State<_SkillGroupWidget> createState() => _SkillGroupWidgetState();
}

class _SkillGroupWidgetState extends State<_SkillGroupWidget> {
  late Map<SkillFamily, List<WizardSkillInstance>> currentSkills = <SkillFamily, List<WizardSkillInstance>>{};

  @override
  void initState() {
    super.initState();

    var families = SkillFamily.values
        .where((SkillFamily f) => f.defaultAttribute == widget.attribute);
    for(var f in families) {
      currentSkills[f] = <WizardSkillInstance>[];
    }

    for(var i in widget.skills) {
      if(i.skill is! WizardStandardSkillWrapper) continue;
      var si = i.skill as WizardStandardSkillWrapper;
      if(!currentSkills.containsKey(si.skill.family)) continue;
      currentSkills[si.skill.family]!.add(i);
    }
  }

  void mergeAndNotify() {
    var merged = <WizardSkillInstance>[];
    for(var v in currentSkills.values) {
      merged.addAll(v);
    }
    widget.onChanged(merged);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Text(
              widget.attribute.title,
              style: theme.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
            ),
            for(var entry in currentSkills.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _SkillFamilyWidget(
                  family: entry.key,
                  skills: entry.value,
                  onChanged: (List<WizardSkillInstance> l) {
                    setState(() {
                      currentSkills[entry.key] = l;
                    });
                    mergeAndNotify();
                  },
                  specialization: widget.specialization,
                  onSpecializationChanged: widget.onSpecializationChanged,
                ),
              )
          ],
        )
      )
    );
  }
}

class _SkillFamilyWidget extends StatefulWidget {
  const _SkillFamilyWidget({
    required this.family,
    required this.skills,
    required this.onChanged,
    required this.specialization,
    required this.onSpecializationChanged,
  });

  final SkillFamily family;
  final List<WizardSkillInstance> skills;
  final void Function(List<WizardSkillInstance>) onChanged;
  final WizardSkillInstance specialization;
  final void Function(WizardSkillInstance?) onSpecializationChanged;

  @override
  State<_SkillFamilyWidget> createState() => _SkillFamilyWidgetState();
}

class _SkillFamilyWidgetState extends State<_SkillFamilyWidget> {
  late Map<String, WizardSkillInstance> currentSkills = <String, WizardSkillInstance>{};
  late WizardSkillInstance currentStarterSpecialization;

  @override
  void initState() {
    super.initState();

    for(var i in widget.skills) {
      if(i.skill is! WizardStandardSkillWrapper) continue;
      currentSkills[i.title] = i;
    }

    currentStarterSpecialization = widget.specialization;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();
    var starterSpecialization = model.starterSpecialization!;
    var starterSpecializationValue = model.effectiveStarterSpecialization;
    var starterSpecializationSkill = (starterSpecialization.skill as WizardStandardSkillWrapper).skill;
    var seenSkills = <Skill>{};
    var skillWidgets = <Widget>[];

    var baseSkills = <String>{};
    for(var i in model.effectiveBaseSkills) {
      if(i.skill is! WizardStandardSkillWrapper) continue;
      var si = i.skill as WizardStandardSkillWrapper;
      if(si.skill.family != widget.family) continue;

      if(!si.skill.requireConcreteImplementation) {
        seenSkills.add(si.skill);
      }

      double costMultiplier = si.skill.reservedCastes.isEmpty || si.skill.reservedCastes.contains(model.caste!)
          ? 1
          : 2;

      baseSkills.add(i.title);
      skillWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            spacing: 8.0,
            children: [
              _SingleSkillWidget(
                title: i.title,
                initialValue: i.value + (currentSkills[i.title]?.value ?? 0),
                baseValue: i.value,
                costMultiplier: costMultiplier,
                onChanged: (int value, int cost) {
                  if(!currentSkills.containsKey(i.title)) {
                    currentSkills[i.title] = WizardSkillInstance(
                      skill: i.skill,
                      implementation: i.implementation,
                      value: 0
                    );
                  }

                  setState(() {
                    currentSkills[i.title]!.value = value;
                  });
                  widget.onChanged(currentSkills.values.toList());
                  model.usedXP += cost;
                }
              ),
              if(starterSpecializationSkill == si.skill)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: _SingleSkillWidget(
                    title: starterSpecialization.specialization!,
                    initialValue: starterSpecializationValue + currentStarterSpecialization.value,
                    baseValue: starterSpecializationValue,
                    costMultiplier: 0.5,
                    onChanged: (int value, int cost) {
                      setState(() {
                        currentStarterSpecialization.value = value;
                      });
                      widget.onSpecializationChanged(currentStarterSpecialization);
                      model.usedXP += cost;
                    }
                  ),
                )
            ],
          ),
        )
      );
    }

    for(var entry in currentSkills.entries) {
      if(baseSkills.contains(entry.key)) continue;
      var si = entry.value.skill as WizardStandardSkillWrapper;

      if(!si.skill.requireConcreteImplementation) {
        seenSkills.add(si.skill);
      }

      double costMultiplier = si.skill.reservedCastes.isEmpty || si.skill.reservedCastes.contains(model.caste!)
          ? 1
          : 2;

      skillWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            spacing: 4.0,
            children: [
              IconButton(
                onPressed: () {
                  var cost = skillUpgradeCost(0, entry.value.value);
                  setState(() {
                    currentSkills.remove(entry.key);
                  });
                  model.usedXP -= cost;
                  widget.onChanged(currentSkills.values.toList());
                },
                iconSize: 18.0,
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(),
                icon: Icon(Icons.delete),
              ),
              Expanded(
                child: _SingleSkillWidget(
                  title: entry.key,
                  initialValue: entry.value.value,
                  costMultiplier: costMultiplier,
                  onChanged: (int value, int cost) {
                    setState(() {
                      currentSkills[entry.key]!.value = value;
                    });
                    widget.onChanged(currentSkills.values.toList());
                    model.usedXP += cost;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    var recommended = (_recommendedSkills[model.caste!] ?? <Skill>{})
      .difference(seenSkills)
      .where((Skill s) => s.family == widget.family)
      .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4.0,
          children: [
            Text(
              widget.family.title,
              style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () async {
                var s = await showDialog<SkillInstance>(
                  context: context,
                  builder: (BuildContext context) => SkillPickerDialog(
                    family: widget.family,
                    excluded: seenSkills.toList(),
                    doNotIndicateReservedForCaste: model.caste!,
                    forbidden: false,
                  ),
                );
                if(s == null) return;
                if(!context.mounted) return;

                var instance = WizardSkillInstance(
                  skill: WizardStandardSkillWrapper(skill: s.skill),
                  implementation: s.implementation,
                  value: 0,
                );
                currentSkills[instance.title] = instance;
                widget.onChanged(currentSkills.values.toList());
              },
              iconSize: 18.0,
              padding: const EdgeInsets.all(8.0),
              constraints: BoxConstraints(),
              icon: Icon(Icons.add),
            )
          ],
        ),
        ...skillWidgets,
        for(var s in recommended)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Recommandé : ${s.title}',
              style: theme.textTheme.bodyMedium!
                .copyWith(color: Colors.black54),
            ),
          ),
      ],
    );
  }
}

class _MagicWidget extends StatelessWidget {
  const _MagicWidget({
    required this.magicSkills,
    required this.onSkillsChanged,
    required this.additionalPool,
    required this.onAdditionalPoolChanged,
    required this.spheres,
    required this.onSpheresChanged,
    required this.spells,
    required this.onSpellsUpdated,
    this.advantageSpell,
    required this.onAdvantageSpellChanged,
  });

  final List<WizardSkillInstance> magicSkills;
  final void Function(List<WizardSkillInstance>) onSkillsChanged;
  final int additionalPool;
  final void Function(int) onAdditionalPoolChanged;
  final List<WizardSkillInstance> spheres;
  final void Function(List<WizardSkillInstance>) onSpheresChanged;
  final List<MagicSpell> spells;
  final void Function(List<MagicSpell>) onSpellsUpdated;
  final MagicSpell? advantageSpell;
  final void Function(MagicSpell?) onAdvantageSpellChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Text(
          "Magie",
          style: theme.textTheme.headlineMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "À la création, tous les personnages peuvent développer des Compétences de magie. Les Disciplines et les Sphères de magie sont toutefois réservées pour les mages, ce qui leur permet de les développer à coût normal. Pour toutes les autres castes, le coût sera doublé. Il en va de même pour les sorts, qui sont plus facilement accessibles aux mages qu’aux autres personnages.\nUn mage dispose à sa création d’un sort de niveau 1 d’une Sphère de son choix. Les autres sorts sont achetés avec des Points de Compétence, en dépensant autant de points que la complexité du sort désiré. À la création, seuls des sorts de niveau 1 et 2 peuvent ainsi être achetés.\nLes personnages des autres castes ayant développé des Compétences de magie peuvent acheter des sorts, en dépensant le double de Points de Compétences requis.\nÀ la création, les mages peuvent également augmenter leur Réserve de magie. Cette Réserve s'accroît comme une Compétence en dépensant des Points de Compétence. Sa valeur de base est égale à la Volonté. Seuls les mages peuvent augmenter leur Réserve de magie à la création."
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: _MagicSkillsWidget(
            magicSkills: magicSkills,
            onSkillsChanged: onSkillsChanged,
            additionalPool: additionalPool,
            onAdditionalPoolChanged: onAdditionalPoolChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: _MagicSpheresWidget(
            spheres: spheres,
            onChanged: onSpheresChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: _MagicSpellsWidget(
            spells: spells,
            onSpellsUpdated: onSpellsUpdated,
            advantageSpell: advantageSpell,
            onAdvantageSpellChanged: onAdvantageSpellChanged
          ),
        ),
      ],
    );
  }
}

class _MagicSkillsWidget extends StatefulWidget {
  const _MagicSkillsWidget({
    required this.magicSkills,
    required this.onSkillsChanged,
    required this.additionalPool,
    required this.onAdditionalPoolChanged,
  });

  final List<WizardSkillInstance> magicSkills;
  final void Function(List<WizardSkillInstance>) onSkillsChanged;
  final int additionalPool;
  final void Function(int) onAdditionalPoolChanged;

  @override
  State<_MagicSkillsWidget> createState() => _MagicSkillsWidgetState();
}

class _MagicSkillsWidgetState extends State<_MagicSkillsWidget> {
  late Map<MagicSkill, WizardSkillInstance> currentMagicSkills = <MagicSkill, WizardSkillInstance>{};
  late int currentPool;

  @override
  void initState() {
    super.initState();

    for(var i in widget.magicSkills) {
      if(i.implementation == MagicSkill.instinctive.title) {
        currentMagicSkills[MagicSkill.instinctive] = i;
      }
      else if(i.implementation == MagicSkill.invocatoire.title) {
        currentMagicSkills[MagicSkill.invocatoire] = i;
      }
      else if(i.implementation == MagicSkill.sorcellerie.title) {
        currentMagicSkills[MagicSkill.sorcellerie] = i;
      }
    }

    for(var s in MagicSkill.values) {
      if(!currentMagicSkills.containsKey(s)) {
        currentMagicSkills[s] = WizardSkillInstance(
          skill: WizardMagicSkillSkillWrapper(),
          implementation: s.title,
          value: 0
        );
      }
    }

    currentPool = widget.additionalPool;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    var baseInstinctive =
      model.effectiveBaseSkill(currentMagicSkills[MagicSkill.instinctive]!.title)
      ?? 0;
    var baseInvocatoire =
        model.effectiveBaseSkill(currentMagicSkills[MagicSkill.invocatoire]!.title)
        ?? 0;
    var baseSorcellerie =
        model.effectiveBaseSkill(currentMagicSkills[MagicSkill.sorcellerie]!.title)
        ?? 0;

    double costMultiplier = model.caste! == Caste.mage ? 1 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Text(
          "Compétences magiques",
          style: theme.textTheme.headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: _SingleSkillWidget(
                  title: MagicSkill.instinctive.title,
                  initialValue: baseInstinctive + currentMagicSkills[MagicSkill.instinctive]!.value,
                  baseValue: baseInstinctive,
                  costMultiplier: costMultiplier,
                  onChanged: (int value, int cost) {
                    setState(() {
                      currentMagicSkills[MagicSkill.instinctive]!.value = value;
                    });
                    widget.onSkillsChanged(currentMagicSkills.values.toList());
                    model.usedXP += cost;
                  },
                ),
              ),
              Expanded(
                child: _SingleSkillWidget(
                  title: MagicSkill.invocatoire.title,
                  initialValue: baseInvocatoire + currentMagicSkills[MagicSkill.invocatoire]!.value,
                  baseValue: baseInvocatoire,
                  costMultiplier: costMultiplier,
                  onChanged: (int value, int cost) {
                    setState(() {
                      currentMagicSkills[MagicSkill.invocatoire]!.value = value;
                    });
                    widget.onSkillsChanged(currentMagicSkills.values.toList());
                    model.usedXP += cost;
                  },
                ),
              ),
              Expanded(
                child: _SingleSkillWidget(
                  title: MagicSkill.sorcellerie.title,
                  initialValue: baseSorcellerie + currentMagicSkills[MagicSkill.sorcellerie]!.value,
                  baseValue: baseSorcellerie,
                  costMultiplier: costMultiplier,
                  onChanged: (int value, int cost) {
                    setState(() {
                      currentMagicSkills[MagicSkill.sorcellerie]!.value = value;
                    });
                    widget.onSkillsChanged(currentMagicSkills.values.toList());
                    model.usedXP += cost;
                  },
                ),
              ),
              Expanded(
                child: _SingleSkillWidget(
                  title: 'Réserve de magie = ${model.abilities![Ability.volonte]!} +',
                  enabled: model.caste! == Caste.mage,
                  initialValue: currentPool,
                  baseValue: 0,
                  maxValue: 10,
                  costMultiplier: 1,
                  onChanged: (int value, int cost) {
                    setState(() {
                      currentPool = value;
                    });
                    widget.onAdditionalPoolChanged(value);
                    model.usedXP += cost;
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _MagicSpheresWidget extends StatefulWidget {
  const _MagicSpheresWidget({
    required this.spheres,
    required this.onChanged,
  });

  final List<WizardSkillInstance> spheres;
  final void Function(List<WizardSkillInstance>) onChanged;

  @override
  State<_MagicSpheresWidget> createState() => _MagicSpheresWidgetState();
}

class _MagicSpheresWidgetState extends State<_MagicSpheresWidget> {
  Map<MagicSphere, WizardSkillInstance> currentSpheres = <MagicSphere, WizardSkillInstance>{};

  @override
  void initState() {
    super.initState();

    for(var i in widget.spheres) {
      for(var s in MagicSphere.values) {
        if(i.implementation == s.title) {
          currentSpheres[s] = i;
        }
      }
    }

    for(var s in MagicSphere.values) {
      if(!currentSpheres.containsKey(s)) {
        currentSpheres[s] = WizardSkillInstance(
          skill: WizardMagicSphereSkillWrapper(),
          implementation: s.title,
          value: 0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();
    double costMultiplier = model.caste! == Caste.mage ? 1 : 2;
    var sphereRows = <Widget>[];

    var sphereInstance = WizardSkillInstance(
      skill: WizardMagicSphereSkillWrapper(),
      value: 0,
    );
    for(var i = 0; i < 3; ++i) {
      var currentRow = <Widget>[];

      for(var j = 0; j < 3; ++j) {
        var sphere = MagicSphere.values[j+i*3];
        sphereInstance.implementation = sphere.title;
        var baseValue = model.effectiveBaseSkill(sphereInstance.title) ?? 0;

        currentRow.add(
          SizedBox(
            width: 250,
            child: _SingleSkillWidget(
              title: sphere.title,
              initialValue: baseValue + currentSpheres[sphere]!.value,
              baseValue: baseValue,
              costMultiplier: costMultiplier,
              onChanged: (int v, int cost) {
                setState(() {
                  currentSpheres[sphere]!.value = v;
                });
                widget.onChanged(currentSpheres.values.toList());
                model.usedXP += cost;
              }
            ),
          )
        );
      }

      sphereRows.add(
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            spacing: 24.0,
            children: currentRow,
          ),
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Text(
          "Sphères",
          style: theme.textTheme.headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        ...sphereRows,
      ],
    );
  }
}

class _MagicSpellsWidget extends StatefulWidget {
  const _MagicSpellsWidget({
    required this.spells,
    required this.onSpellsUpdated,
    this.advantageSpell,
    required this.onAdvantageSpellChanged,
  });

  final List<MagicSpell> spells;
  final void Function(List<MagicSpell>) onSpellsUpdated;
  final MagicSpell? advantageSpell;
  final void Function(MagicSpell?) onAdvantageSpellChanged;

  @override
  State<_MagicSpellsWidget> createState() => _MagicSpellsWidgetState();
}

class _MagicSpellsWidgetState extends State<_MagicSpellsWidget> {
  late List<MagicSpell> current;
  late MagicSpell? currentAdvantageSpell;

  @override
  void initState() {
    super.initState();

    current = List.from(widget.spells);
    currentAdvantageSpell = widget.advantageSpell;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();
    var costMultiplier = model.caste! == Caste.mage ? 1 : 2;

    bool hasAdvantageNaturalMagic = (model.advantages ?? <CharacterAdvantage>[])
        .any((CharacterAdvantage a) => a.advantage == Advantage.magieNaturelle);
    bool hasAdvantageIntuitiveMagic = (model.advantages ?? <CharacterAdvantage>[])
        .any((CharacterAdvantage a) => a.advantage == Advantage.magieIntuitive);

    Widget? advantageSpellWidget;
    if(hasAdvantageIntuitiveMagic || hasAdvantageNaturalMagic) {
      if(currentAdvantageSpell != null) {
        advantageSpellWidget = Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: DisplayMagicSpellWidget(
            spell: currentAdvantageSpell!,
            onDelete: () {
              setState(() {
                currentAdvantageSpell = null;
              });
              widget.onAdvantageSpellChanged(currentAdvantageSpell);
            },
          ),
        );
      }
      else {
        var advantageName = hasAdvantageIntuitiveMagic
            ? "Magie Intuitive"
            : "Magie Naturelle";

        advantageSpellWidget = Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  spacing: 16.0,
                  children: [
                    Text(
                      "Sort de l'avantage $advantageName",
                      style: theme.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton.filled(
                      onPressed: () async {
                        var s = await showDialog<MagicSpell>(
                          context: context,
                          builder: (BuildContext context) =>
                            MagicSpellPickerDialog(
                              maxLevel: 1,
                            )
                        );
                        if(s == null) return;
                        if(!context.mounted) return;

                        setState(() {
                          currentAdvantageSpell = s;
                        });
                        widget.onAdvantageSpellChanged(currentAdvantageSpell);
                      },
                      icon: Icon(Icons.add),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Text(
          "Sorts",
          style: theme.textTheme.headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        ?advantageSpellWidget,
        for(var s in current)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: DisplayMagicSpellWidget(
              spell: s,
              onDelete: () {
                setState(() {
                  current.remove(s);
                });
                widget.onSpellsUpdated(current);
                model.usedXP -= costMultiplier * s.complexity;
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton.filled(
            onPressed: () async {
              var s = await showDialog<MagicSpell>(
                context: context,
                builder: (BuildContext context) =>
                  MagicSpellPickerDialog(
                    maxLevel: 2,
                    maxComplexity: (model.remainingXP / costMultiplier).floor(),
                  )
              );
              if(s == null) return;
              if(!context.mounted) return;

              setState(() {
                current.add(s);
              });
              model.usedXP += costMultiplier * s.complexity;
              widget.onSpellsUpdated(current);
            },
            iconSize: 18.0,
            padding: const EdgeInsets.all(8.0),
            constraints: BoxConstraints(),
            icon: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _RenownWidget extends StatelessWidget {
  const _RenownWidget({
    required this.renown,
    required this.onChanged,
  });

  final int renown;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Text(
          "Renommée",
          style: theme.textTheme.headlineMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "Les personnages commencent normalement avec une Renommée de 0, mais il est possible d’utiliser des Points de Compétence pour l’augmenter. Cet Attribut Mineur est noté sur 10. À chaque fois qu’un personnage est susceptible d’être reconnu, le Meneur de Jeu jette un D10. Si le résultat est inférieur ou égal à la Renommée, son interlocuteur le reconnaît. Dans certains cas, ce jet ne sera pas possible ou automatiquement réussi (revenir dans son village d’origine, parvenir à un village isolé depuis vingt ans, etc.)."
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SizedBox(
            width: 250,
            child: _SingleSkillWidget(
              title: "Renommée",
              initialValue: renown,
              baseValue: 0,
              costMultiplier: 1.0,
              onChanged: (int value, int cost) {
                onChanged(value);
                model.usedXP += cost;
              }
            ),
          ),
        )
      ],
    );
  }
}

const _recommendedSkills = <Caste, Set<Skill>>{
  Caste.artisan: {
    Skill.alchimie,
    Skill.baratin,
    Skill.castes,
    Skill.connaissanceDeLaMagie,
    Skill.contrefacon,
    Skill.estimation,
    Skill.lois,
  },
  Caste.combattant: {
    Skill.armesDeSiege,
    Skill.attelages,
    Skill.connaissanceDesAnimaux,
    Skill.dressage,
    Skill.eloquence,
    Skill.equitation,
    Skill.jeu,
    Skill.natation,
    Skill.premiersSoins,
    Skill.strategie,
    Skill.armesTranchantes,
    Skill.armesDeJet,
    Skill.armesContondantes,
    Skill.armesArticulees,
    Skill.armesDoubles,
    Skill.armesDHast,
    Skill.armesDeChoc,
  },
  Caste.commercant: {
    Skill.attelages,
    Skill.castes,
    Skill.contrefacon,
    Skill.deguisement,
    Skill.diplomatie,
    Skill.discretion,
    Skill.faireLesPoches,
    Skill.histoire,
    Skill.jeu,
    Skill.lois,
    Skill.matieresPremieres,
    Skill.orientation,
    Skill.psychologie,
  },
  Caste.erudit: {
    Skill.alchimie,
    Skill.astrologie,
    Skill.conte,
    Skill.donArtistique,
    Skill.herboristerie,
    Skill.medecine,
    Skill.premiersSoins,
  },
  Caste.mage: {
    Skill.acrobatie,
    Skill.artisanat,
    Skill.athletisme,
    Skill.connaissanceDesDragons,
    Skill.histoire,
    Skill.intimidation,
    Skill.jongler,
    Skill.marchandage,
    Skill.matieresPremieres,
  },
  Caste.prodige: {
    Skill.acrobatie,
    Skill.athletisme,
    Skill.castes,
    Skill.commandement,
    Skill.connaissanceDesAnimaux,
    Skill.diplomatie,
    Skill.discretion,
    Skill.dressage,
    Skill.eloquence,
    Skill.histoire,
    Skill.intimidation,
    Skill.jongler,
    Skill.pister,
  },
  Caste.protecteur: {
    Skill.armesDeSiege,
    Skill.artisanat,
    Skill.corpsACorps,
    Skill.diplomatie,
    Skill.eloquence,
    Skill.esquive,
    Skill.histoire,
    Skill.intimidation,
    Skill.jeu,
    Skill.lireEtEcrire,
    Skill.vieEnCite,
  },
  Caste.voyageur: {
    Skill.acrobatie,
    Skill.artisanat,
    Skill.astrologie,
    Skill.connaissanceDesAnimaux,
    Skill.deguisement,
    Skill.diplomatie,
    Skill.discretion,
    Skill.dressage,
    Skill.escalade,
    Skill.esquive,
    Skill.faireLesPoches,
    Skill.herboristerie,
    Skill.histoire,
    Skill.jeu,
    Skill.jongler,
    Skill.marchandage,
    Skill.natation,
    Skill.pieges,
    Skill.pister,
    Skill.premiersSoins,
  },
};