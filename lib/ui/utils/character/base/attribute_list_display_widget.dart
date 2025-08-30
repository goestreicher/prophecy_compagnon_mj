import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';

class AttributeListDisplayWidget extends StatelessWidget {
  const AttributeListDisplayWidget({ super.key, required this.attributes });

  final Map<Attribute, int> attributes;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Physique',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Mental',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Manuel',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Social',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(width: 4.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                attributes[Attribute.physique]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                attributes[Attribute.mental]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                attributes[Attribute.manuel]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                attributes[Attribute.social]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}