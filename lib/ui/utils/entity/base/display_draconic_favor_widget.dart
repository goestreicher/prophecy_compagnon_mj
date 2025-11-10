import 'package:flutter/material.dart';

import '../../../../classes/draconic_favor.dart';
import '../../../../classes/draconic_link.dart';
import '../../dismissible_dialog.dart';

class DisplayDraconicFavorWidget extends StatelessWidget {
  const DisplayDraconicFavorWidget({
    super.key,
    required this.favor,
    this.onDelete,
  });

  final DraconicFavor favor;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: theme.canvasColor,
        boxShadow: [BoxShadow(
          color: theme.colorScheme.onPrimaryContainer.withAlpha(80),
          blurRadius: 1,
          offset: Offset(0, 1),
        )]
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
        child: IntrinsicWidth(
          child: Row(
            spacing: 4.0,
            children: [
              if(onDelete != null)
                IconButton(
                  style: IconButton.styleFrom(
                    iconSize: 20.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDelete!();
                  },
                ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.0,
                  children: [
                    Text(
                      favor.title,
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      'Sphère : ${favor.sphere.title}',
                        style: theme.textTheme.bodySmall,
                    ),
                    if(favor.linkProgress.index > DraconicLinkProgress.prelude.index)
                      Text(
                        'Niveau : ${favor.linkProgress.title}',
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  iconSize: 16.0,
                ),
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.info_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    DismissibleDialog<void>(
                      title: favor.title,
                      content: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 400,
                          maxWidth: 400,
                          maxHeight: 400,
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            favor.description,
                          ),
                        )
                      )
                    )
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}