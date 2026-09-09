part of 'list_widget.dart';

class _ShieldDataContainer extends StatefulWidget {
  const _ShieldDataContainer({
    required this.source,
    this.filter,
    this.onCreated,
    this.onModified,
    this.onDeleted,
  });

  final ObjectSource source;
  final EquipmentModelListFilter? filter;
  final void Function(ShieldModel)? onCreated;
  final void Function(ShieldModel)? onModified;
  final void Function(ShieldModel)? onDeleted;

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

  @override
  void didUpdateWidget(covariant _ShieldDataContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadShields();
  }

  void loadShields() {
    shields.clear();
    for(var sid in ShieldModel.ids()) {
      var shield = ShieldModel.get(sid);
      if(shield == null) continue;
      if(!(widget.filter?.match(shield) ?? true)) continue;
      shields.add(shield);
    }
    shields.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    return _EquipmentTypeContainer(
      title: 'Boucliers',
      forceExpand: (widget.filter?.isNotEmpty() ?? false) && shields.isNotEmpty,
      titleSuffix: IconButton(
        onPressed: () async {
          ShieldModel? sm = await showDialog(
            context: context,
            builder: (BuildContext context) => ShieldEditDialog(),
          );
          if(sm == null) return;
          if(!context.mounted) return;
          sm.source = widget.source;
          await ShieldModel.saveLocalModel(sm);
          widget.onCreated?.call(sm);
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
      child: shields.isEmpty
        ? const Text('Aucun')
        : _createShieldTable(shields, context),
    );
  }

  Table _createShieldTable(List<ShieldModel> shields, BuildContext context) {
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
        9: IntrinsicColumnWidth(),  // Damage
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
            _HeaderTableCell(
              child: Text(
                'Dommages',
              ),
            ),
            defaultCells[_EquipmentTableCells.special]!,
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

      var canEdit = shield.source == ObjectSource.local || shield.source == widget.source;
      var defaultCells = _createStandardEquipmentCells(
        equipment: shield,
        context: context,
        editMenu: !canEdit ? null : _EditableEquipmentMenu(
          onEdit: () async {
            ShieldModel? sm = await showDialog(
              context: context,
              builder: (BuildContext context) => ShieldEditDialog(
                shield: shield,
              ),
            );
            if(sm == null) return;
            if(!context.mounted) return;
            sm.source = widget.source;
            await ShieldModel.saveLocalModel(sm);
            widget.onModified?.call(sm);
            setState(() {
              loadShields();
            });
          },
          onDownload: () async {
            var jsonStr = json.encode(shield.toJson());
            await FilePicker.saveFile(
              fileName: 'shield_${shield.uuid}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
          onDelete: () async {
            await ShieldModel.deleteLocalModel(shield.uuid);
            widget.onDeleted?.call(shield);
            setState(() {
              loadShields();
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
            _DefaultTableCell(child: Text(shield.protection.toString())),
            _DefaultTableCell(child: Text(shield.penalty.toString())),
            _DefaultTableCell(child: Text(shield.damage.toString())),
            defaultCells[_EquipmentTableCells.special]!,
          ]
        )
      );
    }

    return ret;
  }
}