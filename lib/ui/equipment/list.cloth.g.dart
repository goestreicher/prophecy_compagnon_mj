part of 'list.dart';

class _ClothDataContainer extends StatelessWidget {
  const _ClothDataContainer();

  @override
  Widget build(BuildContext context) {
    var tables = <Widget>[];

    for(var type in ClothModel.supportedBodyParts()) {
      tables.add(
        _ClothTypeContainer(
          type: type,
        )
      );
    }

    return _EquipmentTypeContainer(
        title: 'Vêtements',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tables,
        )
    );
  }
}

class _ClothTypeContainer extends StatefulWidget {
  const _ClothTypeContainer({ required this.type });

  final EquipableItemSlot type;

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
  }

  void loadClothes() {
    clothes.clear();
    for(var cid in ClothModel.idsByBodyPart(widget.type)) {
      var c = ClothModel.get(cid);
      if(c == null) continue;
      clothes.add(c);
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
                    ClothModel? cm = await showDialog(
                      context: context,
                      builder: (BuildContext context) => ClothEditDialog(
                        type: widget.type,
                      ),
                    );
                    if(cm == null) return;
                    if(!context.mounted) return;
                    await ClothModel.saveLocalModel(cm);
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
        ...(_createClothRows(clothes, context).toList())
      ],
    );
  }

  Iterable<TableRow> _createClothRows(List<ClothModel> clothes, BuildContext context) {
    var theme = Theme.of(context);
    var ret = <TableRow>[];

    for(var (idx, cloth) in clothes.indexed) {
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
                  if(cloth.source == ObjectSource.local)
                    _EditableEquipmentMenu(
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
                        await ClothModel.saveLocalModel(cm);
                        setState(() {
                          loadClothes();
                        });
                      },
                      onDownload: () async {
                        var jsonStr = json.encode(cloth.toJson());
                        await FilePicker.platform.saveFile(
                          fileName: 'cloth_${cloth.id}.json',
                          bytes: utf8.encode(jsonStr),
                        );
                      },
                      onDelete: () async {
                        await ClothModel.deleteLocalModel(cloth.id);
                        setState(() {
                          loadClothes();
                        });
                      },
                    ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: cloth.name),
                          if(cloth.unique)
                            TextSpan(text: ' '),
                          if(cloth.unique)
                            WidgetSpan(
                              child: Tooltip(
                                message: 'Unique',
                                child: Icon(
                                  Icons.looks_one_outlined,
                                  size: 18,
                                ),
                              ),
                            )
                        ]
                      )
                    )
                  ),
                ],
              )
            ),
            _DefaultTableCell(child: Text(cloth.weight.toString())),
            _DefaultTableCell(child: Text(cloth.creationDifficulty.toString())),
            _DefaultTableCell(child: Text(cloth.creationTime.toString())),
            _DefaultTableCell(child: Text('${cloth.villageAvailability.scarcity.short}/${cloth.villageAvailability.price.toString()}')),
            _DefaultTableCell(child: Text('${cloth.cityAvailability.scarcity.short}/${cloth.cityAvailability.price.toString()}')),
            _DefaultTableCell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  for(var sp in cloth.special)
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