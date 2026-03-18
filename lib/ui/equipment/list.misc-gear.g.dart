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
                  'Spécial',
                )
            ),
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
                  if(item.source == ObjectSource.local)
                    _EditableEquipmentMenu(
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
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: item.name),
                          if(item.unique)
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
                          if(item.description.isNotEmpty)
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
                                            title: item.name,
                                            content: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: 400,
                                                maxWidth: 400,
                                                maxHeight: 400,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  item.description,
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
            _DefaultTableCell(child: Text(item.weight.toString())),
            _DefaultTableCell(child: Text(item.creationDifficulty.toString())),
            _DefaultTableCell(child: Text(item.creationTime.toString())),
            _DefaultTableCell(child: Text('${item.villageAvailability.scarcity.short}/${item.villageAvailability.price.toString()}')),
            _DefaultTableCell(child: Text('${item.cityAvailability.scarcity.short}/${item.cityAvailability.price.toString()}')),
            _DefaultTableCell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  for(var sp in item.special)
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