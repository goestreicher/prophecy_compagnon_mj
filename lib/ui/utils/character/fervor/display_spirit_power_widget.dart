import 'package:flutter/material.dart';

import '../../../../classes/entity/spirit_powers.dart';

class DisplaySpiritPowerWidget extends StatelessWidget {
  const DisplaySpiritPowerWidget({
    super.key,
    required this.power,
    this.onDelete,
  });

  final SpiritPower power;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 12.0,
              children: [
                Text(
                  '${power.title} (${power.cost})',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  power.description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if(onDelete != null)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: () {
                  onDelete?.call();
                },
                style: IconButton.styleFrom(
                  iconSize: 16.0,
                ),
                icon: const Icon(Icons.delete),
              ),
            )
        ],
      )
    );
  }
}