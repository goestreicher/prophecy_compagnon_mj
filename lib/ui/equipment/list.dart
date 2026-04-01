import 'package:flutter/material.dart';

import '../utils/equipment/list_filter.dart';
import '../utils/equipment/list_filter_widget.dart';
import '../utils/equipment/list_widget.dart';

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
          child: EquipmentListWidget(
            filter: filter,
          ),
        ),
      ],
    );
  }
}