part of 'list.dart';

class _ArmorDataContainer extends StatelessWidget {
  const _ArmorDataContainer({ this.filter });

  final EquipmentModelListFilter? filter;

  @override
  Widget build(BuildContext context) {
    var tables = <Widget>[];

    for(var type in ArmorType.values) {
      tables.add(
        _ArmorTypeContainer(
          type: type,
          filter: filter,
        )
      );
    }

    return _EquipmentTypeContainer(
      title: 'Armures',
      forceExpand: filter?.isNotEmpty() ?? false,
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
    this.filter,
  });

  final ArmorType type;
  final EquipmentModelListFilter? filter;

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
    expanded = (widget.filter?.isNotEmpty() ?? false) && armors.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant _ArmorTypeContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadArmors();
    expanded = (widget.filter?.isNotEmpty() ?? false) && armors.isNotEmpty;
  }

  void loadArmors() {
    armors.clear();
    for(var aid in ArmorModel.idsByType(widget.type)) {
      var armor = ArmorModel.get(aid);
      if(armor == null) continue;
      if(!(widget.filter?.match(armor) ?? true)) continue;
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
      if(armors.isEmpty) {
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
    var defaultCells = _createStandardEquipmentHeaders(context: context);

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
                  'Protection',
                )
            ),
            _HeaderTableCell(
                child: Text(
                  'Pénalité',
                )
            ),
            defaultCells[_EquipmentTableCells.special]!,
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

      var defaultCells = _createStandardEquipmentCells(
        equipment: armor,
        context: context,
        editMenu: _EditableEquipmentMenu(
          onEdit: () async {
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
          onDownload: () async {
            var jsonStr = json.encode(armor.toJson());
            await FilePicker.platform.saveFile(
              fileName: 'armor_${armor.id}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
          onDelete: () async {
            await ArmorModel.deleteLocalModel(armor.id);
            setState(() {
              loadArmors();
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
            _DefaultTableCell(child: Text(armor.protection.toString())),
            _DefaultTableCell(child: Text(armor.penalty.toString())),
            defaultCells[_EquipmentTableCells.special]!,
          ]
        )
      );
    }

    return ret;
  }
}