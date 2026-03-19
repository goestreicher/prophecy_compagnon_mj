part of 'list.dart';

class _MiscGearDataContainer extends StatefulWidget {
  const _MiscGearDataContainer({ this.filter });

  final EquipmentModelListFilter? filter;

  @override
  State<_MiscGearDataContainer> createState() => _MiscGearDataContainerState();
}

class _MiscGearDataContainerState extends State<_MiscGearDataContainer> {
  List<MiscGearModel> gear = <MiscGearModel>[];
  
  @override
  void initState() {
    super.initState();
    
    loadGear();
  }

  @override
  void didUpdateWidget(covariant _MiscGearDataContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadGear();
  }
  
  void loadGear() {
    gear.clear();
    for(var gid in MiscGearModel.ids()) {
      var g = MiscGearModel.get(gid);
      if(g == null) continue;
      if(!(widget.filter?.match(g) ?? true)) continue;
      gear.add(g);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return _EquipmentTypeContainer(
      title: 'Équipement commun',
      forceExpand: (widget.filter?.isNotEmpty() ?? false) && gear.isNotEmpty,
      titleSuffix: IconButton(
        onPressed: () async {
          MiscGearModel? gm = await showDialog(
            context: context,
            builder: (BuildContext context) => MiscGearEditDialog(),
          );
          if(gm == null) return;
          if(!context.mounted) return;
          await MiscGearModel.saveLocalModel(gm);
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
  
  Table _createGearTable(List<MiscGearModel> gear, BuildContext context) {
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

  Iterable<TableRow> _createGearRows(List<MiscGearModel> gear, BuildContext context) {
    var theme = Theme.of(context);
    var ret = <TableRow>[];

    for(var (idx, item) in gear.indexed) {
      var defaultCells = _createStandardEquipmentCells(
        equipment: item,
        context: context,
        editMenu: _EditableEquipmentMenu(
          onEdit: () async {
            MiscGearModel? gm = await showDialog(
              context: context,
              builder: (BuildContext context) => MiscGearEditDialog(
                item: item,
              ),
            );
            if(gm == null) return;
            if(!context.mounted) return;
            await MiscGearModel.saveLocalModel(gm);
            setState(() {
              loadGear();
            });
          },
          onDownload: () async {
            var jsonStr = json.encode(item.toJson());
            await FilePicker.platform.saveFile(
              fileName: 'misc-gear_${item.id}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
          onDelete: () async {
            await MiscGearModel.deleteLocalModel(item.id);
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