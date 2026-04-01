part of 'list_widget.dart';

class _ClothDataContainer extends StatelessWidget {
  const _ClothDataContainer({
    required this.source,
    this.filter,
    this.onCreated,
    this.onModified,
    this.onDeleted,
  });

  final ObjectSource source;
  final EquipmentModelListFilter? filter;
  final void Function(ClothModel)? onCreated;
  final void Function(ClothModel)? onModified;
  final void Function(ClothModel)? onDeleted;

  @override
  Widget build(BuildContext context) {
    var tables = <Widget>[];

    for(var type in ClothModel.supportedBodyParts()) {
      tables.add(
        _ClothTypeContainer(
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
        title: 'Vêtements',
        forceExpand: filter?.isNotEmpty() ?? false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tables,
        )
    );
  }
}

class _ClothTypeContainer extends StatefulWidget {
  const _ClothTypeContainer({
    required this.type,
    required this.source,
    this.filter,
    this.onCreated,
    this.onModified,
    this.onDeleted,
  });

  final EquipableItemSlot type;
  final ObjectSource source;
  final EquipmentModelListFilter? filter;
  final void Function(ClothModel)? onCreated;
  final void Function(ClothModel)? onModified;
  final void Function(ClothModel)? onDeleted;

  @override
  State<_ClothTypeContainer> createState() => _ClothTypeContainerState();
}

class _ClothTypeContainerState extends State<_ClothTypeContainer> {
  bool expanded = false;
  List<ClothModel> clothes = <ClothModel>[];

  @override
  void initState() {
    super.initState();

    loadClothes();
    expanded = (widget.filter?.isNotEmpty() ?? false) && clothes.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant _ClothTypeContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadClothes();
    expanded = (widget.filter?.isNotEmpty() ?? false) && clothes.isNotEmpty;
  }

  void loadClothes() {
    clothes.clear();
    for(var cid in ClothModel.idsByBodyPart(widget.type)) {
      var cloth = ClothModel.get(cid);
      if(cloth == null) continue;
      if(!(widget.filter?.match(cloth) ?? true)) continue;
      clothes.add(cloth);
    }
    clothes.sort((a, b) => a.name.compareTo(b.name));
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
                    ClothModel? cm = await showDialog(
                      context: context,
                      builder: (BuildContext context) => ClothEditDialog(
                        type: widget.type,
                      ),
                    );
                    if(cm == null) return;
                    if(!context.mounted) return;
                    cm.source = widget.source;
                    await ClothModel.saveLocalModel(cm);
                    widget.onCreated?.call(cm);
                    setState(() {
                      loadClothes();
                    });
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 24.0,
                  padding: const EdgeInsets.all(4.0),
                  constraints: const BoxConstraints(),
                  tooltip: 'Nouveau vêtement (${widget.type.title})',
                ),
              ),
            )
          ]
        ),
      )
    );

    if(expanded) {
      if(clothes.isEmpty) {
        children.add(Text('Aucun'));
      }
      else {
        children.add(_createClothTable(clothes, context));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Table _createClothTable(List<ClothModel> clothes, BuildContext context) {
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
        ...(_createClothRows(clothes, context).toList())
      ],
    );
  }

  Iterable<TableRow> _createClothRows(List<ClothModel> clothes, BuildContext context) {
    var theme = Theme.of(context);
    var ret = <TableRow>[];

    for(var (idx, cloth) in clothes.indexed) {
      var canEdit = cloth.source == ObjectSource.local || cloth.source == widget.source;
      var defaultCells = _createStandardEquipmentCells(
        equipment: cloth,
        context: context,
        editMenu: !canEdit ? null : _EditableEquipmentMenu(
          onEdit: () async {
            ClothModel? cm = await showDialog(
              context: context,
              builder: (BuildContext context) => ClothEditDialog(
                type: widget.type,
                cloth: cloth,
              ),
            );
            if(cm == null) return;
            if(!context.mounted) return;
            cm.source = widget.source;
            await ClothModel.saveLocalModel(cm);
            widget.onModified?.call(cm);
            setState(() {
              loadClothes();
            });
          },
          onDownload: () async {
            var jsonStr = json.encode(cloth.toJson());
            await FilePicker.platform.saveFile(
              fileName: 'cloth_${cloth.uuid}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
          onDelete: () async {
            await ClothModel.deleteLocalModel(cloth.uuid);
            widget.onDeleted?.call(cloth);
            setState(() {
              loadClothes();
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