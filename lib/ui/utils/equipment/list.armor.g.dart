part of 'list_widget.dart';

class _ArmorDataContainer extends StatelessWidget {
  const _ArmorDataContainer({
    required this.source,
    this.filter,
    this.onCreated,
    this.onModified,
    this.onDeleted,
  });

  final ObjectSource source;
  final EquipmentModelListFilter? filter;
  final void Function(ArmorModel)? onCreated;
  final void Function(ArmorModel)? onModified;
  final void Function(ArmorModel)? onDeleted;

  @override
  Widget build(BuildContext context) {
    var tables = <Widget>[];

    for(var type in ArmorType.values) {
      tables.add(
        _ArmorTypeContainer(
          type: type,
          source: source,
          filter: filter,
          onCreated: onCreated,
          onModified: onModified,
          onDeleted: onDeleted,
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
    required this.source,
    this.filter,
    this.onCreated,
    this.onModified,
    this.onDeleted,
  });

  final ArmorType type;
  final ObjectSource source;
  final EquipmentModelListFilter? filter;
  final void Function(ArmorModel)? onCreated;
  final void Function(ArmorModel)? onModified;
  final void Function(ArmorModel)? onDeleted;

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
    armors.sort((a, b) => a.name.compareTo(b.name));
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
                    am.source = widget.source;
                    await ArmorModel.saveLocalModel(am);
                    widget.onCreated?.call(am);
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
    var widths = _getEquipmentColumnsWidth();
    var defaultCells = _createStandardEquipmentHeaders(context: context);

    return Table(
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

      var canEdit = armor.source == ObjectSource.local || armor.source == widget.source;
      var defaultCells = _createStandardEquipmentCells(
        equipment: armor,
        context: context,
        editMenu: !canEdit ? null : _EditableEquipmentMenu(
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

            am.source = widget.source;
            await ArmorModel.saveLocalModel(am);
            widget.onModified?.call(am);
            setState(() {
              loadArmors();
            });
          },
          onDownload: () async {
            var jsonStr = json.encode(armor.toJson());
            await FilePicker.saveFile(
              fileName: 'armor_${armor.uuid}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
          onDelete: () async {
            await ArmorModel.deleteLocalModel(armor.uuid);
            widget.onDeleted?.call(armor);
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