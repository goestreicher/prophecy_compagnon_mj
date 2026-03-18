part of 'list.dart';

class _JewelDataContainer extends StatelessWidget {
  const _JewelDataContainer();

  @override
  Widget build(BuildContext context) {
    var tables = <Widget>[];

    for(var type in JewelModel.supportedBodyParts()) {
      tables.add(
          _JewelTypeContainer(
            type: type,
          )
      );
    }

    return _EquipmentTypeContainer(
        title: 'Bijoux',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tables,
        )
    );
  }
}

class _JewelTypeContainer extends StatefulWidget {
  const _JewelTypeContainer({ required this.type });

  final EquipableItemSlot type;

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
  }

  void loadJewels() {
    jewels.clear();
    for(var cid in JewelModel.idsByBodyPart(widget.type)) {
      var c = JewelModel.get(cid);
      if(c == null) continue;
      jewels.add(c);
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
        ...(_createJewelRows(jewels, context).toList())
      ],
    );
  }

  Iterable<TableRow> _createJewelRows(List<JewelModel> jewels, BuildContext context) {
    var theme = Theme.of(context);
    var ret = <TableRow>[];

    for(var (idx, jewel) in jewels.indexed) {
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
                  if(jewel.source == ObjectSource.local)
                    _EditableEquipmentMenu(
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
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: jewel.name),
                          if(jewel.unique)
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
                          if(jewel.description.isNotEmpty)
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
                                            title: jewel.name,
                                            content: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: 400,
                                                maxWidth: 400,
                                                maxHeight: 400,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  jewel.description,
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
            _DefaultTableCell(child: Text(jewel.weight.toString())),
            _DefaultTableCell(child: Text(jewel.creationDifficulty.toString())),
            _DefaultTableCell(child: Text(jewel.creationTime.toString())),
            _DefaultTableCell(child: Text('${jewel.villageAvailability.scarcity.short}/${jewel.villageAvailability.price.toString()}')),
            _DefaultTableCell(child: Text('${jewel.cityAvailability.scarcity.short}/${jewel.cityAvailability.price.toString()}')),
            _DefaultTableCell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: [
                    for(var sp in jewel.special)
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