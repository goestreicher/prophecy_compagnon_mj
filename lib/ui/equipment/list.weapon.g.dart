part of 'list.dart';

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

      if(weapon.handiness == 2) {
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
      if(oneHandedWeapons.isEmpty && twoHandedWeapons.isEmpty) {
        children.add(Text('Aucune'));
      }
      else {
        var rows = <TableRow>[];

        if(oneHandedWeapons.isNotEmpty) {
          rows.add(
              _createSeparatorRow('Une main', context)
          );
          rows.addAll(_createWeaponRows(oneHandedWeapons, context));
        }

        if(twoHandedWeapons.isNotEmpty) {
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
                    _EditableEquipmentMenu(
                      onEdit: () async {
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
                      onDownload: () async {
                        var jsonStr = json.encode(weapon.toJson());
                        await FilePicker.platform.saveFile(
                          fileName: 'weapon_${weapon.id}.json',
                          bytes: utf8.encode(jsonStr),
                        );
                      },
                      onDelete: () async {
                        await WeaponModel.deleteLocalModel(weapon.id);
                        setState(() {
                          loadWeapons();
                        });
                      },
                    ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: weapon.name),
                          if(weapon.unique)
                            TextSpan(
                              children: [
                                TextSpan(text: ' '),
                                WidgetSpan(
                                  child: Tooltip(
                                    message: 'Unique',
                                    child: Icon(
                                      Icons.looks_one_outlined,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          if(weapon.description.isNotEmpty)
                            TextSpan(
                              children: [
                                TextSpan(text: ' '),
                                WidgetSpan(
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          DismissibleDialog<void>(
                                            title: weapon.name,
                                            content: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: 400,
                                                maxWidth: 400,
                                                maxHeight: 400,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  weapon.description,
                                                ),
                                              )
                                            )
                                          )
                                        );
                                      },
                                      child: Icon(
                                        Icons.info_outline,
                                        size: 18,
                                      ),
                                    ),
                                  )
                                ),
                              ]
                            ),
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