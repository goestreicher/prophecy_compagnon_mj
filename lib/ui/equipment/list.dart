import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_mj/classes/equipment/misc_gear.dart';

import '../../classes/creature.dart';
import '../../classes/equipment/armor.dart';
import '../../classes/combat.dart';
import '../../classes/entity/skill.dart';
import '../../classes/equipment/cloth.dart';
import '../../classes/equipment/enums.dart';
import '../../classes/equipment/jewel.dart';
import '../../classes/object_source.dart';
import '../../classes/equipment/shield.dart';
import '../../classes/equipment/weapon.dart';
import '../utils/dismissible_dialog.dart';
import '../utils/equipment/armor_edit_dialog.dart';
import '../utils/equipment/cloth_edit_dialog.dart';
import '../utils/equipment/jewel_edit_dialog.dart';
import '../utils/equipment/list_filter.dart';
import '../utils/equipment/list_filter_widget.dart';
import '../utils/equipment/misc_gear_edit_dialog.dart';
import '../utils/equipment/shield_edit_dialog.dart';
import '../utils/equipment/weapon_edit_dialog.dart';

part 'list.armor.g.dart';
part 'list.cloth.g.dart';
part 'list.jewel.g.dart';
part 'list.misc-gear.g.dart';
part 'list.shield.g.dart';
part 'list.weapon.g.dart';

class EquipmentListPage extends StatefulWidget {
  const EquipmentListPage({ super.key });

  @override
  State<EquipmentListPage> createState() => _EquipmentListPageState();
}

class _EquipmentListPageState extends State<EquipmentListPage> {
  EquipmentModelListFilter filter = EquipmentModelListFilter();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: EquipmentModelListFilterWidget(
            onFilterChanged: (EquipmentModelListFilter f) {
              setState(() {
                filter = f;
              });
            }
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                _WeaponDataContainer(
                  filter: filter,
                ),
                _ShieldDataContainer(
                  filter: filter,
                ),
                _ArmorDataContainer(
                  filter: filter,
                ),
                _ClothDataContainer(
                  filter: filter,
                ),
                _JewelDataContainer(
                  filter: filter,
                ),
                _MiscGearDataContainer(
                  filter: filter,
                ),
              ],
            ),
          ),
        ),
      ],
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