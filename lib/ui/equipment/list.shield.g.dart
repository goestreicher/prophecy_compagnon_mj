part of 'list.dart';

class _ShieldDataContainer extends StatefulWidget {
  const _ShieldDataContainer({ this.filter });

  final EquipmentModelListFilter? filter;

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
          await ShieldModel.saveLocalModel(sm);
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
      child: _createShieldTable(shields, context),
    );
  }

  Table _createShieldTable(List<ShieldModel> shields, BuildContext context) {
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
        9: IntrinsicColumnWidth(),  // Damage
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
            _HeaderTableCell(
                child: Text(
                  'Spécial',
                )
            ),
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
                  if(shield.source == ObjectSource.local)
                    _EditableEquipmentMenu(
                      onEdit: () async {
                        ShieldModel? sm = await showDialog(
                          context: context,
                          builder: (BuildContext context) => ShieldEditDialog(
                            shield: shield,
                          ),
                        );
                        if(sm == null) return;
                        if(!context.mounted) return;
                        await ShieldModel.saveLocalModel(sm);
                        setState(() {
                          loadShields();
                        });
                      },
                      onDownload: () async {
                        var jsonStr = json.encode(shield.toJson());
                        await FilePicker.platform.saveFile(
                          fileName: 'shield_${shield.id}.json',
                          bytes: utf8.encode(jsonStr),
                        );
                      },
                      onDelete: () async {
                        await ShieldModel.deleteLocalModel(shield.id);
                        setState(() {
                          loadShields();
                        });
                      },
                    ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: shield.name),
                          if(shield.unique)
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
                          if(shield.description.isNotEmpty)
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
                                            title: shield.name,
                                            content: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: 400,
                                                maxWidth: 400,
                                                maxHeight: 400,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  shield.description,
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
            _DefaultTableCell(child: Text(shield.weight.toString())),
            _DefaultTableCell(child: Text(shield.creationDifficulty.toString())),
            _DefaultTableCell(child: Text(shield.creationTime.toString())),
            _DefaultTableCell(child: Text('${shield.villageAvailability.scarcity.short}/${shield.villageAvailability.price.toString()}')),
            _DefaultTableCell(child: Text('${shield.cityAvailability.scarcity.short}/${shield.cityAvailability.price.toString()}')),
            _DefaultTableCell(child: Text(reqsStr)),
            _DefaultTableCell(child: Text(shield.protection.toString())),
            _DefaultTableCell(child: Text(shield.penalty.toString())),
            _DefaultTableCell(child: Text(shield.damage.toString())),
            _DefaultTableCell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  for(var sp in shield.special)
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