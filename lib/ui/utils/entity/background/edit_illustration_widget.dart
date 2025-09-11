import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../illustration_edit_widget.dart';
import '../../widget_group_container.dart';

class EntityEditIllustrationWidget extends StatelessWidget {
  const EntityEditIllustrationWidget({
    super.key,
    required this.entity,
  });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Illustration',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: IllustrationEditFormField(
        entity: entity,
      )
    );
  }
}