part of 'list.dart';

class _JewelDataContainer extends StatelessWidget {
  const _JewelDataContainer({ this.filter });

  final EquipmentModelListFilter? filter;

  @override
  Widget build(BuildContext context) {
    var tables = <Widget>[];

    for(var type in JewelModel.supportedBodyParts()) {
      tables.add(
          _JewelTypeContainer(
            type: type,
            filter: filter,
          )
      );
    }

    return _EquipmentTypeContainer(
        title: 'Bijoux',
        forceExpand: filter?.isNotEmpty() ?? false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tables,
        )
    );
  }
}

class _JewelTypeContainer extends StatefulWidget {
  const _JewelTypeContainer({
    required this.type,
    this.filter,
  });

  final EquipableItemSlot type;
  final EquipmentModelListFilter? filter;

  @override
  State<_JewelTypeContainer> createState() => _JewelTypeContainerState();
}

class _JewelTypeContainerState extends State<_JewelTypeContainer> {
  bool expanded = false;
  List<JewelModel> jewels = <JewelModel>[];

  @override
  void initState() {
    super.initState();

    loadJewels();
    expanded = (widget.filter?.isNotEmpty() ?? false) && jewels.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant _JewelTypeContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadJewels();
    expanded = (widget.filter?.isNotEmpty() ?? false) && jewels.isNotEmpty;
  }

  void loadJewels() {
    jewels.clear();
    for(var cid in JewelModel.idsByBodyPart(widget.type)) {
      var jewel = JewelModel.get(cid);
      if(jewel == null) continue;
      if(!(widget.filter?.match(jewel) ?? true)) continue;
      jewels.add(jewel);
    }
    jewels.sort((a, b) => a.name.compareTo(b.name));
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
                    JewelModel? jm = await showDialog(
                      context: context,
                      builder: (BuildContext context) => JewelEditDialog(
                        type: widget.type,
                      ),
                    );
                    if(jm == null) return;
                    if(!context.mounted) return;
                    await JewelModel.saveLocalModel(jm);
                    setState(() {
                      loadJewels();
                    });
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 24.0,
                  padding: const EdgeInsets.all(4.0),
                  constraints: const BoxConstraints(),
                  tooltip: 'Nouveau bijou (${widget.type.title})',
                ),
              ),
            )
          ]
        ),
      )
    );

    if(expanded) {
      if(jewels.isEmpty) {
        children.add(Text('Aucun'));
      }
      else {
        children.add(_createJewelTable(jewels, context));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Table _createJewelTable(List<JewelModel> jewels, BuildContext context) {
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
            defaultCells[_EquipmentTableCells.special]!,
          ]
        ),
        ...(_createJewelRows(jewels, context).toList())
      ],
    );
  }

  Iterable<TableRow> _createJewelRows(List<JewelModel> jewels, BuildContext context) {
    var theme = Theme.of(context);
    var ret = <TableRow>[];

    for(var (idx, jewel) in jewels.indexed) {
      var defaultCells = _createStandardEquipmentCells(
        equipment: jewel,
        context: context,
        editMenu: _EditableEquipmentMenu(
          onEdit: () async {
            JewelModel? jm = await showDialog(
              context: context,
              builder: (BuildContext context) => JewelEditDialog(
                type: widget.type,
                jewel: jewel,
              ),
            );
            if(jm == null) return;
            if(!context.mounted) return;
            await JewelModel.saveLocalModel(jm);
            setState(() {
              loadJewels();
            });
          },
          onDownload: () async {
            var jsonStr = json.encode(jewel.toJson());
            await FilePicker.platform.saveFile(
              fileName: 'jewel_${jewel.id}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
          onDelete: () async {
            await JewelModel.deleteLocalModel(jewel.id);
            setState(() {
              loadJewels();
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
            defaultCells[_EquipmentTableCells.special]!,
          ]
        )
      );
    }

    return ret;
  }
}