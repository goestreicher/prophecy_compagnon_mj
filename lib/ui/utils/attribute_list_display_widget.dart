import 'package:flutter/material.dart';

import '../../classes/character/base.dart';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: SizedBox(
          width: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Physique',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    attributes[Attribute.physique]!.toString(),
                    style: theme.textTheme.bodyLarge,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Mental',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    attributes[Attribute.mental]!.toString(),
                    style: theme.textTheme.bodyLarge,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Manuel',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    attributes[Attribute.manuel]!.toString(),
                    style: theme.textTheme.bodyLarge,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Social',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    attributes[Attribute.social]!.toString(),
                    style: theme.textTheme.bodyLarge,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}