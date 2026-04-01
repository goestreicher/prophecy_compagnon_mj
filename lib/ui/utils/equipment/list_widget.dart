import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../classes/combat.dart';
import '../../../classes/creature.dart';
import '../../../classes/entity/skill.dart';
import '../../../classes/equipment/armor.dart';
import '../../../classes/equipment/cloth.dart';
import '../../../classes/equipment/enums.dart';
import '../../../classes/equipment/equipment.dart';
import '../../../classes/equipment/jewel.dart';
import '../../../classes/equipment/magic_gear.dart';
import '../../../classes/equipment/misc_gear.dart';
import '../../../classes/equipment/shield.dart';
import '../../../classes/equipment/weapon.dart';
import '../../../classes/object_source.dart';
import '../dismissible_dialog.dart';
import 'armor_edit_dialog.dart';
import 'cloth_edit_dialog.dart';
import 'jewel_edit_dialog.dart';
import 'list_filter.dart';
import 'magic_gear_edit_dialog.dart';
import 'misc_gear_edit_dialog.dart';
import 'shield_edit_dialog.dart';
import 'weapon_edit_dialog.dart';

part 'list.armor.g.dart';
part 'list.cloth.g.dart';
part 'list.jewel.g.dart';
part 'list.magic-gear.g.dart';
part 'list.misc-gear.g.dart';
part 'list.shield.g.dart';
part 'list.weapon.g.dart';

class EquipmentListWidget extends StatelessWidget {
  const EquipmentListWidget({
    super.key,
    this.source = ObjectSource.local,
    this.filter,
    this.onEquipmentCreated,
    this.onEquipmentModified,
    this.onEquipmentDeleted,
  });

  final ObjectSource source;
  final EquipmentModelListFilter? filter;
  final void Function(EquipmentModel)? onEquipmentCreated;
  final void Function(EquipmentModel)? onEquipmentModified;
  final void Function(EquipmentModel)? onEquipmentDeleted;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          _WeaponDataContainer(
            source: source,
            filter: filter,
            onCreated: (WeaponModel m) => onEquipmentCreated?.call(m),
            onModified: (WeaponModel m) => onEquipmentModified?.call(m),
            onDeleted: (WeaponModel m) => onEquipmentDeleted?.call(m),
          ),
          _ShieldDataContainer(
            source: source,
            filter: filter,
            onCreated: (ShieldModel m) => onEquipmentCreated?.call(m),
            onModified: (ShieldModel m) => onEquipmentModified?.call(m),
            onDeleted: (ShieldModel m) => onEquipmentDeleted?.call(m),
          ),
          _ArmorDataContainer(
            source: source,
            filter: filter,
            onCreated: (ArmorModel m) => onEquipmentCreated?.call(m),
            onModified: (ArmorModel m) => onEquipmentModified?.call(m),
            onDeleted: (ArmorModel m) => onEquipmentDeleted?.call(m),
          ),
          _ClothDataContainer(
            source: source,
            filter: filter,
            onCreated: (ClothModel m) => onEquipmentCreated?.call(m),
            onModified: (ClothModel m) => onEquipmentModified?.call(m),
            onDeleted: (ClothModel m) => onEquipmentDeleted?.call(m),
          ),
          _JewelDataContainer(
            source: source,
            filter: filter,
            onCreated: (JewelModel m) => onEquipmentCreated?.call(m),
            onModified: (JewelModel m) => onEquipmentModified?.call(m),
            onDeleted: (JewelModel m) => onEquipmentDeleted?.call(m),
          ),
          _MiscGearDataContainer(
            source: source,
            filter: filter,
            onCreated: (MiscGearModel m) => onEquipmentCreated?.call(m),
            onModified: (MiscGearModel m) => onEquipmentModified?.call(m),
            onDeleted: (MiscGearModel m) => onEquipmentDeleted?.call(m),
          ),
          _MagicGearDataContainer(
            source: source,
            filter: filter,
            onCreated: (MagicGearModel m) => onEquipmentCreated?.call(m),
            onModified: (MagicGearModel m) => onEquipmentModified?.call(m),
            onDeleted: (MagicGearModel m) => onEquipmentDeleted?.call(m),
          ),
        ],
      ),
    );
  }
}

class _EquipmentTypeContainer extends StatefulWidget {
  const _EquipmentTypeContainer({
    required this.title,
    required this.child,
    this.titleSuffix,
    this.forceExpand = false,
  });

  final String title;
  final Widget child;
  final Widget? titleSuffix;
  final bool forceExpand;

  @override
  State<_EquipmentTypeContainer> createState() => _EquipmentTypeContainerState();
}

class _EquipmentTypeContainerState extends State<_EquipmentTypeContainer> {
  late bool expanded;

  @override
  void initState() {
    super.initState();

    expanded = widget.forceExpand;
  }

  @override
  void didUpdateWidget(covariant _EquipmentTypeContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    expanded = widget.forceExpand;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 4.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ?widget.titleSuffix,
              ],
            ),
            if(expanded)
              widget.child,
          ],
        ),
      ),
    );
  }
}

class _SubCategoryTitle extends StatelessWidget {
  const _SubCategoryTitle({
    required this.title,
    this.titleSuffix
  });

  final String title;
  final Widget? titleSuffix;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
      child: Row(
        spacing: 4.0,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold
            ),
          ),
          ?titleSuffix,
        ],
      )
    );
  }
}

class _DefaultTableCell extends StatelessWidget {
  const _DefaultTableCell({ required this.child });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: child,
    );
  }
}

class _HeaderTableCell extends StatelessWidget {
  const _HeaderTableCell({ required this.child });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: child,
      ),
    );
  }
}

enum _EquipmentTableCells {
  name,
  weight,
  creationDifficulty,
  creationTime,
  villageAvailability,
  cityAvailability,
  special,
}

Map<_EquipmentTableCells, TableColumnWidth> _getEquipmentColumnsWidth() {
  var ret = <_EquipmentTableCells, TableColumnWidth>{
    _EquipmentTableCells.name: FixedColumnWidth(200),
    _EquipmentTableCells.weight: IntrinsicColumnWidth(),
    _EquipmentTableCells.creationDifficulty: IntrinsicColumnWidth(),
    _EquipmentTableCells.creationTime: IntrinsicColumnWidth(),
    _EquipmentTableCells.villageAvailability: IntrinsicColumnWidth(),
    _EquipmentTableCells.cityAvailability: IntrinsicColumnWidth(),
  };

  return ret;
}

Map<_EquipmentTableCells, _HeaderTableCell> _createStandardEquipmentHeaders({
  required BuildContext context,
}) {
  var ret = <_EquipmentTableCells, _HeaderTableCell>{
    _EquipmentTableCells.name: _HeaderTableCell(
      child: Text(
        'Nom',
      )
    ),
    _EquipmentTableCells.weight: _HeaderTableCell(
      child: Text(
        'Poids',
      )
    ),
    _EquipmentTableCells.creationDifficulty: _HeaderTableCell(
      child: Text(
        'DC',
      )
    ),
    _EquipmentTableCells.creationTime: _HeaderTableCell(
      child: Text(
        'TC',
      )
    ),
    _EquipmentTableCells.villageAvailability: _HeaderTableCell(
      child: Text(
        'Rareté/Prix\n(villages)',
      )
    ),
    _EquipmentTableCells.cityAvailability: _HeaderTableCell(
      child: Text(
        'Rareté/Prix\n(villes)',
      )
    ),
    _EquipmentTableCells.special: _HeaderTableCell(
      child: Text(
        'Spécial',
      )
    ),
  };

  return ret;
}

Map<_EquipmentTableCells, _DefaultTableCell> _createStandardEquipmentCells({
  required EquipmentModel equipment,
  required BuildContext context,
  _EditableEquipmentMenu? editMenu,
}) {
  var ret = <_EquipmentTableCells, _DefaultTableCell>{};

  ret[_EquipmentTableCells.name] = _DefaultTableCell(
    child: Row(
      spacing: 8.0,
      children: [
        ?editMenu,
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: equipment.name),
                if(equipment.unique)
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
                if(equipment.description.isNotEmpty)
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
                                  title: equipment.name,
                                  content: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 400,
                                      maxWidth: 400,
                                      maxHeight: 400,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        equipment.description,
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
  );

  ret[_EquipmentTableCells.weight] = _DefaultTableCell(
    child: Text(equipment.weight.toString()),
  );

  ret[_EquipmentTableCells.creationDifficulty] = _DefaultTableCell(
    child: Text(equipment.creationDifficulty.toString())
  );

  ret[_EquipmentTableCells.creationTime] = _DefaultTableCell(
    child: Text(equipment.creationTime.toString())
  );

  ret[_EquipmentTableCells.villageAvailability] = _DefaultTableCell(
    child: Text(
      '${equipment.villageAvailability.scarcity.short}'
      '/'
      '${equipment.villageAvailability.price.toString()}'
    )
  );

  ret[_EquipmentTableCells.cityAvailability] = _DefaultTableCell(
    child: Text(
      '${equipment.cityAvailability.scarcity.short}'
      '/'
      '${equipment.cityAvailability.price.toString()}'
    )
  );

  ret[_EquipmentTableCells.special] = _DefaultTableCell(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        for(var sp in equipment.special)
          _EquipmentSpecialTableCell(special: sp),
      ],
    )
  );

  return ret;
}

class _EquipmentSpecialTableCell extends StatelessWidget {
  const _EquipmentSpecialTableCell({ required this.special });

  final EquipmentSpecialCapability special;

  @override
  Widget build(BuildContext context) {
    if(special.title == null) {
      return Text(special.description);
    }
    else {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${special.title} '),
            WidgetSpan(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      DismissibleDialog<void>(
                        title: special.title!,
                        content: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 400,
                            maxWidth: 400,
                            maxHeight: 400,
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              special.description,
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
        )
      );
    }
  }
}

class _EditableEquipmentMenu extends StatelessWidget {
  const _EditableEquipmentMenu({
    required this.onEdit,
    required this.onDownload,
    required this.onDelete,
  });

  final void Function() onEdit;
  final void Function() onDownload;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () => onEdit(),
          leadingIcon: const Icon(Icons.edit),
          child: const Text('Éditer'),
        ),
        MenuItemButton(
          onPressed: () => onDownload(),
          leadingIcon: const Icon(Icons.download),
          child: const Text('Télécharger'),
        ),
        MenuItemButton(
          onPressed: () => onDelete(),
          leadingIcon: const Icon(Icons.delete),
          child: const Text('Supprimer'),
        ),
      ],
      builder: (_, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
          iconSize: 18.0,
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
        );
      },
    );
  }
}