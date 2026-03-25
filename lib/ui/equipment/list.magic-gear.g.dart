part of 'list.dart';

class _MagicGearDataContainer extends StatefulWidget {
  const _MagicGearDataContainer({ this.filter });

  final EquipmentModelListFilter? filter;

  @override
  State<_MagicGearDataContainer> createState() => _MagicGearDataContainerState();
}

class _MagicGearDataContainerState extends State<_MagicGearDataContainer> {
  List<MagicGearModel> gear = <MagicGearModel>[];
  
  @override
  void initState() {
    super.initState();
    
    loadGear();
  }

  @override
  void didUpdateWidget(covariant _MagicGearDataContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadGear();
  }
  
  void loadGear() {
    gear.clear();
    for(var gid in MagicGearModel.ids()) {
      var g = MagicGearModel.get(gid);
      if(g == null) continue;
      if(!(widget.filter?.match(g) ?? true)) continue;
      gear.add(g);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return _EquipmentTypeContainer(
      title: 'Objets magiques',
      forceExpand: (widget.filter?.isNotEmpty() ?? false) && gear.isNotEmpty,
      titleSuffix: IconButton(
        onPressed: () async {
          MagicGearModel? gm = await showDialog(
            context: context,
            builder: (BuildContext context) => MagicGearEditDialog(),
          );
          if(gm == null) return;
          if(!context.mounted) return;
          await MagicGearModel.saveLocalModel(gm);
          setState(() {
            loadGear();
          });
        },
        icon: const Icon(Icons.add),
        iconSize: 24.0,
        padding: const EdgeInsets.all(4.0),
        constraints: const BoxConstraints(),
        tooltip: 'Nouvel équipement commun',
      ),
      child: _createGearTable(gear, context),
    );
  }
  
  Table _createGearTable(List<MagicGearModel> gear, BuildContext context) {
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
        ...(_createGearRows(gear, context).toList())
      ],
    );
  }

  Iterable<TableRow> _createGearRows(List<MagicGearModel> gear, BuildContext context) {
    var theme = Theme.of(context);
    var ret = <TableRow>[];

    for(var (idx, item) in gear.indexed) {
      var defaultCells = _createStandardEquipmentCells(
        equipment: item,
        context: context,
        editMenu: _EditableEquipmentMenu(
          onEdit: () async {
            MagicGearModel? gm = await showDialog(
              context: context,
              builder: (BuildContext context) => MagicGearEditDialog(
                item: item,
              ),
            );
            if(gm == null) return;
            if(!context.mounted) return;
            await MagicGearModel.saveLocalModel(gm);
            setState(() {
              loadGear();
            });
          },
          onDownload: () async {
            var jsonStr = json.encode(item.toJson());
            await FilePicker.platform.saveFile(
              fileName: 'magic-gear_${item.id}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
          onDelete: () async {
            await MagicGearModel.deleteLocalModel(item.id);
            setState(() {
              loadGear();
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