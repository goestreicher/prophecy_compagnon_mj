import 'package:flutter/material.dart';

import '../../classes/armor.dart';
import '../../classes/combat.dart';
import '../../classes/entity/skill.dart';
import '../../classes/object_source.dart';
import '../../classes/shield.dart';
import '../../classes/weapon.dart';
import '../utils/equipment/armor_edit_dialog.dart';
import '../utils/equipment/shield_edit_dialog.dart';
import '../utils/equipment/weapon_edit_dialog.dart';

class EquipmentListPage extends StatelessWidget {
  const EquipmentListPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          _WeaponDataContainer(),
          _ShieldDataContainer(),
          _ArmorDataContainer(),
        ],
      ),
    );
  }
}

class _EquipmentTypeContainer extends StatefulWidget {
  const _EquipmentTypeContainer({
    required this.title,
    required this.child,
    this.titleSuffix,
  });

  final String title;
  final Widget child;
  final Widget? titleSuffix;

  @override
  State<_EquipmentTypeContainer> createState() => _EquipmentTypeContainerState();
}

class _EquipmentTypeContainerState extends State<_EquipmentTypeContainer> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 4.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ?widget.titleSuffix,
              ],
            ),
            if(expanded)
              widget.child,
          ],
        ),
      ),
    );
  }
}

class _SubCategoryTitle extends StatelessWidget {
  const _SubCategoryTitle({
    required this.title,
    this.titleSuffix
  });

  final String title;
  final Widget? titleSuffix;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
      child: Row(
        spacing: 4.0,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold
            ),
          ),
          ?titleSuffix,
        ],
      )
    );
  }
}

class _DefaultTableCell extends StatelessWidget {
  const _DefaultTableCell({ required this.child });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: child,
    );
  }
}

class _HeaderTableCell extends StatelessWidget {
  const _HeaderTableCell({ required this.child });
  
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: child,
      ),
    );
  }
}

class _WeaponDataContainer extends StatelessWidget {
  const _WeaponDataContainer();

  @override
  Widget build(BuildContext context) {
    var tables = <Widget>[];

    for(var skill in WeaponModel.weaponSkills()) {
      tables.add(
        _WeaponTypeContainer(
          title: skill.title,
          skill: skill,
        )
      );
    }

    return _EquipmentTypeContainer(
      title: 'Armes',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tables,
      )
    );
  }
}

class _WeaponTypeContainer extends StatefulWidget {
  const _WeaponTypeContainer({
    required this.title,
    required this.skill,
  });

  final String title;
  final Skill skill;

  @override
  State<_WeaponTypeContainer> createState() => _WeaponTypeContainerState();
}

class _WeaponTypeContainerState extends State<_WeaponTypeContainer> {
  bool expanded = false;
  List<WeaponModel> oneHandedWeapons = <WeaponModel>[];
  List<WeaponModel> twoHandedWeapons = <WeaponModel>[];

  @override
  void initState() {
    super.initState();

    loadWeapons();
  }

  void loadWeapons() {
    oneHandedWeapons.clear();
    twoHandedWeapons.clear();

    for(var wid in WeaponModel.idsBySkill(widget.skill)) {
      var weapon = WeaponModel.get(wid);
      if(weapon == null) continue;

      if(weapon.hands == 2) {
        twoHandedWeapons.add(weapon);
      }
      else {
        oneHandedWeapons.add(weapon);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    children.add(
      Padding(
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4.0,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  size: 18.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: _SubCategoryTitle(
                title: widget.skill.title,
                titleSuffix: IconButton(
                  onPressed: () async {
                    WeaponModel? wm = await showDialog(
                      context: context,
                      builder: (BuildContext context) => WeaponEditDialog(
                        skill: widget.skill,
                      ),
                    );
                    if(wm == null) return;
                    if(!context.mounted) return;
                    await WeaponModel.saveLocalModel(wm);
                    setState(() {
                      loadWeapons();
                    });
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 24.0,
                  padding: const EdgeInsets.all(4.0),
                  constraints: const BoxConstraints(),
                  tooltip: 'Nouvelle arme',
                ),
              ),
            ),
          ],
        ),
      )
    );

    if(expanded) {
      if (oneHandedWeapons.isEmpty && twoHandedWeapons.isEmpty) {
        children.add(Text('Aucune'));
      }
      else {
        var rows = <TableRow>[];

        if (oneHandedWeapons.isNotEmpty) {
          rows.add(
            _createSeparatorRow('Une main', context)
          );
          rows.addAll(_createWeaponRows(oneHandedWeapons, context));
        }

        if (twoHandedWeapons.isNotEmpty) {
          rows.add(
              _createSeparatorRow('Deux mains', context)
          );
          rows.addAll(_createWeaponRows(twoHandedWeapons, context));
        }

        children.add(
          Table(
            border: TableBorder(
              left: BorderSide(width: 1.0, color: Colors.black38),
              top: BorderSide(width: 1.0, color: Colors.black38),
              right: BorderSide(width: 1.0, color: Colors.black38),
              bottom: BorderSide(width: 1.0, color: Colors.black38),
              //verticalInside: BorderSide(width: 1.0, color: Colors.black38),
              //verticalInside: BorderSide.none,
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(140), // Name
              1: IntrinsicColumnWidth(), // Weight
              2: IntrinsicColumnWidth(), // Creation difficulty
              3: IntrinsicColumnWidth(), // Creation time
              4: IntrinsicColumnWidth(), // Village scarcity
              5: IntrinsicColumnWidth(), // City scarcity
              6: IntrinsicColumnWidth(), // Requirements
              7: IntrinsicColumnWidth(), // Initiative
              8: IntrinsicColumnWidth(), // Range
              9: IntrinsicColumnWidth(), // Damage
            },
            children: [
              TableRow(
                children: [
                  _HeaderTableCell(
                      child: Text(
                        'Nom',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'Poids',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'DC',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'TC',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'Rareté/Prix\n(villages)',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'Rareté/Prix\n(villes)',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'Pré-requis',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'Initiative\n(M/CC)',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'Portée\n(Eff./Max.)',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'Dommages',
                      )
                  ),
                  _HeaderTableCell(
                      child: Text(
                        'Spécial',
                      )
                  ),
                ]
              ),
              ...rows
            ],
          )
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  TableRow _createSeparatorRow(String name, BuildContext context) {
    var theme = Theme.of(context);

    return TableRow(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      children: [
        _DefaultTableCell(
            child: Text(
                name,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.wavy,
                )
            )
        ),
        _DefaultTableCell(child: Text('')),
        _DefaultTableCell(child: Text('')),
        _DefaultTableCell(child: Text('')),
        _DefaultTableCell(child: Text('')),
        _DefaultTableCell(child: Text('')),
        _DefaultTableCell(child: Text('')),
        _DefaultTableCell(child: Text('')),
        _DefaultTableCell(child: Text('')),
        _DefaultTableCell(child: Text('')),
        _DefaultTableCell(child: Text('')),
      ]
    );
  }

  Iterable<TableRow> _createWeaponRows(List<WeaponModel> weapons, BuildContext context) {
    var theme = Theme.of(context);
    var ret = <TableRow>[];

    for(var (idx, weapon) in weapons.indexed) {
      var reqsStr = '';
      if (weapon.requirements.isNotEmpty) {
        var reqs = <String>[];
        for (var a in weapon.requirements.keys) {
          reqs.add('${a.short} ${weapon.requirements[a]!}');
        }
        reqsStr = reqs.join(', ');
      }

      int? meleeInitiative = weapon.initiative[WeaponRange.melee];
      int? contactInitiative = weapon.initiative[WeaponRange.contact];
      var initStr = '${meleeInitiative ?? "NA"} / ${contactInitiative ?? "NA"}';

      ret.add(
        TableRow(
          decoration: BoxDecoration(
            color: idx % 2 == 1
              ? theme.colorScheme.surfaceContainerHigh
              : theme.colorScheme.surfaceContainerLowest
          ),
          children: [
            _DefaultTableCell(
              child: Row(
                spacing: 8.0,
                children: [
                  if(weapon.source == ObjectSource.local)
                    Column(
                      spacing: 4.0,
                      children: [
                        IconButton(
                          onPressed: () async {
                            WeaponModel? wm = await showDialog(
                              context: context,
                              builder: (BuildContext context) => WeaponEditDialog(
                                skill: weapon.skill.parent,
                                weapon: weapon,
                              ),
                            );
                            if(wm == null) return;
                            if(!context.mounted) return;
                            await WeaponModel.saveLocalModel(wm);
                            setState(() {
                              loadWeapons();
                            });
                          },
                          icon: const Icon(Icons.edit),
                          iconSize: 18.0,
                          padding: const EdgeInsets.all(4.0),
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () async {
                            await WeaponModel.deleteLocalModel(weapon.id);
                            setState(() {
                              loadWeapons();
                            });
                          },
                          icon: const Icon(Icons.delete),
                          iconSize: 18.0,
                          padding: const EdgeInsets.all(4.0),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: weapon.name),
                          if(weapon.unique)
                            TextSpan(text: ' '),
                          if(weapon.unique)
                            WidgetSpan(
                              child: Tooltip(
                                message: 'Unique',
                                child: Icon(
                                  Icons.looks_one_outlined,
                                  size: 18,
                                ),
                              ),
                            )
                        ]
                      )
                    )
                  ),
                ],
              )
            ),
            _DefaultTableCell(child: Text(weapon.weight.toString())),
            _DefaultTableCell(child: Text(weapon.creationDifficulty.toString())),
            _DefaultTableCell(child: Text(weapon.creationTime.toString())),
            _DefaultTableCell(child: Text('${weapon.villageAvailability.scarcity.short}/${weapon.villageAvailability.price.toString()}')),
            _DefaultTableCell(child: Text('${weapon.cityAvailability.scarcity.short}/${weapon.cityAvailability.price.toString()}')),
            _DefaultTableCell(child: Text(reqsStr)),
            _DefaultTableCell(child: Text(initStr)),
            _DefaultTableCell(child: Text('${weapon.rangeEffective.toString()} / ${weapon.rangeMax.toString()}')),
            _DefaultTableCell(child: Text(weapon.damage.toString())),
            _DefaultTableCell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  for(var sp in weapon.special)
                    Text(sp.description),
                ],
              )
            ),
          ]
        )
      );
    }

    return ret;
  }
}

class _ShieldDataContainer extends StatefulWidget {
  const _ShieldDataContainer();

  @override
  State<_ShieldDataContainer> createState() => _ShieldDataContainerState();
}

class _ShieldDataContainerState extends State<_ShieldDataContainer> {
  List<ShieldModel> shields = <ShieldModel>[];

  @override
  void initState() {
    super.initState();

    loadShields();
  }

  void loadShields() {
    shields.clear();
    for(var sid in ShieldModel.ids()) {
      var shield = ShieldModel.get(sid);
      if(shield == null) continue;
      shields.add(shield);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _EquipmentTypeContainer(
      title: 'Boucliers',
      titleSuffix: IconButton(
        onPressed: () async {
          ShieldModel? sm = await showDialog(
            context: context,
            builder: (BuildContext context) => ShieldEditDialog(),
          );
          if(sm == null) return;
          if(!context.mounted) return;
          await ShieldModel.saveLocalModel(sm);
          setState(() {
            loadShields();
          });
        },
        icon: const Icon(Icons.add),
        iconSize: 24.0,
        padding: const EdgeInsets.all(4.0),
        constraints: const BoxConstraints(),
        tooltip: 'Nouveau bouclier',
      ),
      child: _createShieldTable(shields, context),
    );
  }

  Table _createShieldTable(List<ShieldModel> shields, BuildContext context) {
    return Table(
      border: TableBorder(
        left: BorderSide(width: 1.0, color: Colors.black38),
        top: BorderSide(width: 1.0, color: Colors.black38),
        right: BorderSide(width: 1.0, color: Colors.black38),
        bottom: BorderSide(width: 1.0, color: Colors.black38),
        verticalInside: BorderSide(width: 1.0, color: Colors.black38),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(140),   // Name
        1: IntrinsicColumnWidth(),  // Weight
        2: IntrinsicColumnWidth(),  // Creation difficulty
        3: IntrinsicColumnWidth(),  // Creation time
        4: IntrinsicColumnWidth(),  // Village scarcity
        5: IntrinsicColumnWidth(),  // City scarcity
        6: IntrinsicColumnWidth(),  // Requirements
        7: IntrinsicColumnWidth(),  // Protection
        8: IntrinsicColumnWidth(),  // Penalty
        9: IntrinsicColumnWidth(),  // Damage
      },
      children: [
        TableRow(
          children: [
            _HeaderTableCell(
              child: Text(
                'Nom',
              )
            ),
            _HeaderTableCell(
              child: Text(
                'Poids',
              )
            ),
            _HeaderTableCell(
              child: Text(
                'DC',
              )
            ),
            _HeaderTableCell(
              child: Text(
                'TC',
              )
            ),
            _HeaderTableCell(
              child: Text(
                'Rareté/Prix\n(villages)',
              )
            ),
            _HeaderTableCell(
              child: Text(
                'Rareté/Prix\n(villes)',
              )
            ),
            _HeaderTableCell(
              child: Text(
                'Pré-requis',
              )
            ),
            _HeaderTableCell(
              child: Text(
                'Protection',
              )
            ),
            _HeaderTableCell(
              child: Text(
                'Pénalité',
              )
            ),
            _HeaderTableCell(
              child: Text(
                'Dommages',
              ),
            ),
            _HeaderTableCell(
              child: Text(
                'Spécial',
              )
            ),
          ]
        ),
        ...(_createShieldRows(shields, context).toList())
      ],
    );
  }

  Iterable<TableRow> _createShieldRows(List<ShieldModel> shields, BuildContext context) {
    var theme = Theme.of(context);
    var ret = <TableRow>[];

    for(var (idx, shield) in shields.indexed) {
      var reqsStr = '';
      if (shield.requirements.isNotEmpty) {
        var reqs = <String>[];
        for (var a in shield.requirements.keys) {
          reqs.add('${a.short} ${shield.requirements[a]!}');
        }
        reqsStr = reqs.join(', ');
      }

      ret.add(
        TableRow(
          decoration: BoxDecoration(
            color: idx % 2 == 1
              ? theme.colorScheme.surfaceContainerHigh
              : theme.colorScheme.surfaceContainerLowest
          ),
          children: [
            _DefaultTableCell(
              child: Row(
                spacing: 8.0,
                children: [
                  if(shield.source == ObjectSource.local)
                    Column(
                      spacing: 4.0,
                      children: [
                        IconButton(
                          onPressed: () async {
                            ShieldModel? sm = await showDialog(
                              context: context,
                              builder: (BuildContext context) => ShieldEditDialog(
                                shield: shield,
                              ),
                            );
                            if(sm == null) return;
                            if(!context.mounted) return;
                            await ShieldModel.saveLocalModel(sm);
                            setState(() {
                              loadShields();
                            });
                          },
                          icon: const Icon(Icons.edit),
                          iconSize: 18.0,
                          padding: const EdgeInsets.all(4.0),
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () async {
                            await ShieldModel.deleteLocalModel(shield.id);
                            setState(() {
                              loadShields();
                            });
                          },
                          icon: const Icon(Icons.delete),
                          iconSize: 18.0,
                          padding: const EdgeInsets.all(4.0),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: shield.name),
                          if(shield.unique)
                            TextSpan(text: ' '),
                          if(shield.unique)
                            WidgetSpan(
                              child: Tooltip(
                                message: 'Unique',
                                child: Icon(
                                  Icons.looks_one_outlined,
                                  size: 18,
                                ),
                              ),
                            )
                        ]
                      )
                    )
                  ),
                ],
              )
            ),
            _DefaultTableCell(child: Text(shield.weight.toString())),
            _DefaultTableCell(child: Text(shield.creationDifficulty.toString())),
            _DefaultTableCell(child: Text(shield.creationTime.toString())),
            _DefaultTableCell(child: Text('${shield.villageAvailability.scarcity.short}/${shield.villageAvailability.price.toString()}')),
            _DefaultTableCell(child: Text('${shield.cityAvailability.scarcity.short}/${shield.cityAvailability.price.toString()}')),
            _DefaultTableCell(child: Text(reqsStr)),
            _DefaultTableCell(child: Text(shield.protection.toString())),
            _DefaultTableCell(child: Text(shield.penalty.toString())),
            _DefaultTableCell(child: Text(shield.damage.toString())),
            _DefaultTableCell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  for(var sp in shield.special)
                    Text(sp.description),
                ],
              )
            ),
          ]
        )
      );
    }

    return ret;
  }
}

class _ArmorDataContainer extends StatelessWidget {
  const _ArmorDataContainer();

  @override
  Widget build(BuildContext context) {
    var tables = <Widget>[];

    for(var type in ArmorType.values) {
      tables.add(
        _ArmorTypeContainer(
          type: type,
        )
      );
    }

    return _EquipmentTypeContainer(
      title: 'Armures',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tables,
      )
    );
  }
}

class _ArmorTypeContainer extends StatefulWidget {
  const _ArmorTypeContainer({
    required this.type,
  });

  final ArmorType type;

  @override
  State<_ArmorTypeContainer> createState() => _ArmorTypeContainerState();
}

class _ArmorTypeContainerState extends State<_ArmorTypeContainer> {
  bool expanded = false;
  List<ArmorModel> armors = <ArmorModel>[];

  @override
  void initState() {
    super.initState();

    loadArmors();
  }

  void loadArmors() {
    armors.clear();
    for(var aid in ArmorModel.idsByType(widget.type)) {
      var armor = ArmorModel.get(aid);
      if(armor == null) continue;
      armors.add(armor);
    }
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    children.add(
      Padding(
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4.0,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  size: 18.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: _SubCategoryTitle(
                title: widget.type.title,
                titleSuffix: IconButton(
                  onPressed: () async {
                    ArmorModel? am = await showDialog(
                      context: context,
                      builder: (BuildContext context) => ArmorEditDialog(
                        type: widget.type,
                      ),
                    );
                    if(am == null) return;
                    if(!context.mounted) return;
                    await ArmorModel.saveLocalModel(am);
                    setState(() {
                      loadArmors();
                    });
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 24.0,
                  padding: const EdgeInsets.all(4.0),
                  constraints: const BoxConstraints(),
                  tooltip: 'Nouvelle armure',
                ),
              ),
            )
          ]
        ),
      )
    );

    if(expanded) {
      if (armors.isEmpty) {
        children.add(Text('Aucune'));
      }
      else {
        children.add(_createArmorTable(armors, context));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Table _createArmorTable(List<ArmorModel> armors, BuildContext context) {
    return Table(
      border: TableBorder(
        left: BorderSide(width: 1.0, color: Colors.black38),
        top: BorderSide(width: 1.0, color: Colors.black38),
        right: BorderSide(width: 1.0, color: Colors.black38),
        bottom: BorderSide(width: 1.0, color: Colors.black38),
        verticalInside: BorderSide(width: 1.0, color: Colors.black38),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(140),   // Name
        1: IntrinsicColumnWidth(),  // Weight
        2: IntrinsicColumnWidth(),  // Creation difficulty
        3: IntrinsicColumnWidth(),  // Creation time
        4: IntrinsicColumnWidth(),  // Village scarcity
        5: IntrinsicColumnWidth(),  // City scarcity
        6: IntrinsicColumnWidth(),  // Requirements
        7: IntrinsicColumnWidth(),  // Protection
        8: IntrinsicColumnWidth(),  // Penalty
      },
      children: [
        TableRow(
            children: [
              _HeaderTableCell(
                  child: Text(
                    'Nom',
                  )
              ),
              _HeaderTableCell(
                  child: Text(
                    'Poids',
                  )
              ),
              _HeaderTableCell(
                  child: Text(
                    'DC',
                  )
              ),
              _HeaderTableCell(
                  child: Text(
                    'TC',
                  )
              ),
              _HeaderTableCell(
                  child: Text(
                    'Rareté/Prix\n(villages)',
                  )
              ),
              _HeaderTableCell(
                  child: Text(
                    'Rareté/Prix\n(villes)',
                  )
              ),
              _HeaderTableCell(
                  child: Text(
                    'Pré-requis',
                  )
              ),
              _HeaderTableCell(
                  child: Text(
                    'Protection',
                  )
              ),
              _HeaderTableCell(
                  child: Text(
                    'Pénalité',
                  )
              ),
              _HeaderTableCell(
                  child: Text(
                    'Spécial',
                  )
              ),
            ]
        ),
        ...(_createArmorRows(armors, context).toList())
      ],
    );
  }

  Iterable<TableRow> _createArmorRows(List<ArmorModel> armors, BuildContext context) {
    var theme = Theme.of(context);
    var ret = <TableRow>[];

    for(var (idx, armor) in armors.indexed) {
      var reqsStr = '';
      if (armor.requirements.isNotEmpty) {
        var reqs = <String>[];
        for (var a in armor.requirements.keys) {
          reqs.add('${a.short} ${armor.requirements[a]!}');
        }
        reqsStr = reqs.join(', ');
      }

      ret.add(
        TableRow(
          decoration: BoxDecoration(
            color: idx % 2 == 1
              ? theme.colorScheme.surfaceContainerHigh
              : theme.colorScheme.surfaceContainerLowest
          ),
          children: [
            _DefaultTableCell(
              child: Row(
                spacing: 8.0,
                children: [
                  if(armor.source == ObjectSource.local)
                    Column(
                      spacing: 4.0,
                      children: [
                        IconButton(
                          onPressed: () async {
                            ArmorModel? am = await showDialog(
                              context: context,
                              builder: (BuildContext context) => ArmorEditDialog(
                                type: armor.type,
                                armor: armor,
                              ),
                            );
                            if(am == null) return;
                            if(!context.mounted) return;

                            await ArmorModel.saveLocalModel(am);
                            setState(() {
                              loadArmors();
                            });
                          },
                          icon: const Icon(Icons.edit),
                          iconSize: 18.0,
                          padding: const EdgeInsets.all(4.0),
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () async {
                            await ArmorModel.deleteLocalModel(armor.id);
                            setState(() {
                              loadArmors();
                            });
                          },
                          icon: const Icon(Icons.delete),
                          iconSize: 18.0,
                          padding: const EdgeInsets.all(4.0),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: armor.name),
                          if(armor.unique)
                            TextSpan(text: ' '),
                          if(armor.unique)
                            WidgetSpan(
                              child: Tooltip(
                                message: 'Unique',
                                child: Icon(
                                  Icons.looks_one_outlined,
                                  size: 18,
                                ),
                              ),
                            )
                        ]
                      )
                    )
                  ),
                ],
              )
            ),
            _DefaultTableCell(child: Text(armor.weight.toString())),
            _DefaultTableCell(child: Text(armor.creationDifficulty.toString())),
            _DefaultTableCell(child: Text(armor.creationTime.toString())),
            _DefaultTableCell(child: Text('${armor.villageAvailability.scarcity.short}/${armor.villageAvailability.price.toString()}')),
            _DefaultTableCell(child: Text('${armor.cityAvailability.scarcity.short}/${armor.cityAvailability.price.toString()}')),
            _DefaultTableCell(child: Text(reqsStr)),
            _DefaultTableCell(child: Text(armor.protection.toString())),
            _DefaultTableCell(child: Text(armor.penalty.toString())),
            _DefaultTableCell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  for(var sp in armor.special)
                    Text(sp.description),
                ],
              )
            ),
          ]
        )
      );
    }

    return ret;
  }
}