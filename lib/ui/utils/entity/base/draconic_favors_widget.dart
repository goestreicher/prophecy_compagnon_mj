import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../uniform_height_wrap.dart';
import '../../widget_group_container.dart';
import 'display_draconic_favor_widget.dart';
import 'draconic_favor_picker_dialog.dart';

class EntityDisplayDraconicFavorsWidget extends StatelessWidget {
  const EntityDisplayDraconicFavorsWidget({
    super.key,
    required this.entity,
    this.edit = false,
  });

  final EntityBase entity;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Faveurs draconiques',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Center(
        child: Column(
          spacing: 12.0,
          children: [
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: ListenableBuilder(
                listenable: entity.favors,
                builder: (BuildContext context, _) {
                  return UniformHeightWrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: [
                      for(var favor in entity.favors)
                        DisplayDraconicFavorWidget(
                          favor: favor,
                          onDelete: !edit
                            ? null
                            : () {
                              entity.favors.remove(favor);
                            },
                        ),
                    ],
                  );
              },
              ),
            ),
            if(edit)
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                  size: 16.0,
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: theme.textTheme.bodySmall,
                ),
                label: const Text('Nouvelle faveur'),
                onPressed: () async {
                  var favor = await showDialog(
                    context: context,
                    builder: (BuildContext context) => DraconicFavorPickerDialog(),
                  );
                  if(!context.mounted) return;
                  if(favor == null) return;

                  entity.favors.add(favor);
                },
              ),
          ],
        ),
      )
    );
  }
}