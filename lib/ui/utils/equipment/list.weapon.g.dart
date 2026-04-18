part of 'list_widget.dart';

class _WeaponDataContainer extends StatelessWidget {
  const _WeaponDataContainer({
    required this.source,
    this.filter,
    this.onCreated,
    this.onModified,
    this.onDeleted,
  });

  final ObjectSource source;
  final EquipmentModelListFilter? filter;
  final void Function(WeaponModel)? onCreated;
  final void Function(WeaponModel)? onModified;
  final void Function(WeaponModel)? onDeleted;

  @override
  Widget build(BuildContext context) {
    var tables = <Widget>[];

    for(var skill in WeaponModel.weaponSkills()) {
      tables.add(
        _WeaponTypeContainer(
          title: skill.title,
          skill: skill,
          source: source,
          filter: filter,
          onCreated: onCreated,
          onModified: onModified,
          onDeleted: onDeleted,
        )
      );
    }

    return _EquipmentTypeContainer(
      title: 'Armes',
      forceExpand: filter?.isNotEmpty() ?? false,
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
    required this.source,
    this.filter,
    this.onCreated,
    this.onModified,
    this.onDeleted,
  });

  final String title;
  final Skill skill;
  final ObjectSource source;
  final EquipmentModelListFilter? filter;
  final void Function(WeaponModel)? onCreated;
  final void Function(WeaponModel)? onModified;
  final void Function(WeaponModel)? onDeleted;

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
    expanded = (widget.filter?.isNotEmpty() ?? false)
        && (oneHandedWeapons.isNotEmpty || twoHandedWeapons.isNotEmpty);
  }

  @override
  void didUpdateWidget(covariant _WeaponTypeContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadWeapons();
    expanded = (widget.filter?.isNotEmpty() ?? false)
        && (oneHandedWeapons.isNotEmpty || twoHandedWeapons.isNotEmpty);
  }

  void loadWeapons() {
    oneHandedWeapons.clear();
    twoHandedWeapons.clear();

    for(var wid in WeaponModel.idsBySkill(widget.skill)) {
      var weapon = WeaponModel.get(wid);
      if(weapon == null) continue;
      if(weapon is NaturalWeaponModel) continue;
      if(!(widget.filter?.match(weapon) ?? true)) continue;

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
                    wm.source = widget.source;
                    await WeaponModel.saveLocalModel(wm);
                    widget.onCreated?.call(wm);
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
          oneHandedWeapons.sort((a, b) => a.name.compareTo(b.name));
          rows.add(
              _createSeparatorRow('Une main', context)
          );
          rows.addAll(_createWeaponRows(oneHandedWeapons, context));
        }

        if(twoHandedWeapons.isNotEmpty) {
          twoHandedWeapons.sort((a, b) => a.name.compareTo(b.name));
          rows.add(
              _createSeparatorRow('Deux mains', context)
          );
          rows.addAll(_createWeaponRows(twoHandedWeapons, context));
        }

        var widths = _getEquipmentColumnsWidth();
        var defaultCells = _createStandardEquipmentHeaders(context: context);

        children.add(
          Table(
            border: TableBorder(
              left: BorderSide(width: 1.0, color: Colors.black38),
              top: BorderSide(width: 1.0, color: Colors.black38),
              right: BorderSide(width: 1.0, color: Colors.black38),
              bottom: BorderSide(width: 1.0, color: Colors.black38),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: <int, TableColumnWidth>{
              0: ?widths[_EquipmentTableCells.name],
              1: ?widths[_EquipmentTableCells.weight],
              2: ?widths[_EquipmentTableCells.creationDifficulty],
              3: ?widths[_EquipmentTableCells.creationTime],
              4: ?widths[_EquipmentTableCells.villageAvailability],
              5: ?widths[_EquipmentTableCells.cityAvailability],
              6: IntrinsicColumnWidth(), // Requirements
              7: IntrinsicColumnWidth(), // Initiative
              8: IntrinsicColumnWidth(), // Range
              9: IntrinsicColumnWidth(), // Damage
            },
            children: [
              TableRow(
                children: [
                  defaultCells[_EquipmentTableCells.name]!,
                  defaultCells[_EquipmentTableCells.weight]!,
                  defaultCells[_EquipmentTableCells.creationDifficulty]!,
                  defaultCells[_EquipmentTableCells.creationTime]!,
                  defaultCells[_EquipmentTableCells.villageAvailability]!,
                  defaultCells[_EquipmentTableCells.cityAvailability]!,
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
                  defaultCells[_EquipmentTableCells.special]!,
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

      var canEdit = weapon.source == ObjectSource.local || weapon.source == widget.source;
      var defaultCells = _createStandardEquipmentCells(
        equipment: weapon,
        context: context,
        editMenu: !canEdit ? null : _EditableEquipmentMenu(
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
            wm.source = widget.source;
            await WeaponModel.saveLocalModel(wm);
            widget.onModified?.call(wm);
            setState(() {
              loadWeapons();
            });
          },
          onDownload: () async {
            var jsonStr = json.encode(weapon.toJson());
            await FilePicker.saveFile(
              fileName: 'weapon_${weapon.uuid}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
          onDelete: () async {
            await WeaponModel.deleteLocalModel(weapon.uuid);
            widget.onDeleted?.call(weapon);
            setState(() {
              loadWeapons();
            });
          },
        ),
      );

      ret.add(
        TableRow(
          decoration: BoxDecoration(
            color: idx % 2 == 1
              ? theme.colorScheme.surfaceContainerHigh
              : theme.colorScheme.surfaceContainerLowest
          ),
          children: [
            defaultCells[_EquipmentTableCells.name]!,
            defaultCells[_EquipmentTableCells.weight]!,
            defaultCells[_EquipmentTableCells.creationDifficulty]!,
            defaultCells[_EquipmentTableCells.creationTime]!,
            defaultCells[_EquipmentTableCells.villageAvailability]!,
            defaultCells[_EquipmentTableCells.cityAvailability]!,
            _DefaultTableCell(child: Text(reqsStr)),
            _DefaultTableCell(child: Text(initStr)),
            _DefaultTableCell(child: Text('${weapon.rangeEffective.toString()} / ${weapon.rangeMax.toString()}')),
            _DefaultTableCell(child: Text(weapon.damage.toString())),
            defaultCells[_EquipmentTableCells.special]!,
          ]
        )
      );
    }

    return ret;
  }
}