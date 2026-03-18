import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../classes/equipment/enums.dart';
import '../widget_group_container.dart';

class ScarcityEditWidget extends StatefulWidget {
  const ScarcityEditWidget({
    super.key,
    required this.type,
    required this.onScarcityChanged,
    required this.onPriceChanged,
    this.scarcity,
    this.price,
  });

  final String type;
  final void Function(EquipmentScarcity) onScarcityChanged;
  final void Function(int) onPriceChanged;
  final EquipmentScarcity? scarcity;
  final int? price;

  @override
  State<ScarcityEditWidget> createState() => _ScarcityEditWidgetState();
}

class _ScarcityEditWidgetState extends State<ScarcityEditWidget> {
  TextEditingController scarcityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.price != null) priceController.text = widget.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        widget.type,
        style: theme.textTheme.bodySmall!.copyWith(
          color: Colors.black87,
        )
      ),
      child: Column(
        spacing: 12.0,
        children: [
          DropdownMenuFormField<EquipmentScarcity>(
            initialSelection: widget.scarcity,
            requestFocusOnTap: true,
            label: const Text('Rareté'),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: EquipmentScarcity.values
              .map((EquipmentScarcity s) => DropdownMenuEntry(value: s, label: s.title))
              .toList(),
            validator: (EquipmentScarcity? s) {
              if(s == null) return 'Valeur manquante';
              return null;
            },
            onSelected: (EquipmentScarcity? s) {
              if(s == null) return;
              widget.onScarcityChanged(s);
            },
          ),
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Prix (df)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (String? value) {
              if(value == null || value.isEmpty) return 'Valeur manquante';
              int? input = int.tryParse(value);
              if(input == null) return 'Pas un nombre';
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (String? value) {
              if(value == null || value.isEmpty) return;
              int? input = int.tryParse(value);
              if(input == null) return;
              widget.onPriceChanged(input);
            },
          ),
        ],
      )
    );
  }
}