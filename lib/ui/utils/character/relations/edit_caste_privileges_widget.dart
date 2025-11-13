import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/character_caste.dart';
import '../../../../classes/caste/privileges.dart';
import '../../../../classes/human_character.dart';
import '../../dismissible_dialog.dart';
import '../../widget_group_container.dart';
import '../background/caste_privilege_picker_dialog.dart';

class CharacterEditCastePrivilegesWidget extends StatelessWidget {
  const CharacterEditCastePrivilegesWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Privilèges',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ListenableBuilder(
        listenable: character.caste.privileges,
        builder: (BuildContext context, _) {
          return _PrivilegesWidget(character: character);
        }
      )
    );
  }
}

class _PrivilegesWidget extends StatelessWidget {
  const _PrivilegesWidget({ required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var p in character.caste.privileges) {
      widgets.add(
        _PrivilegeWidget(
          privilege: p,
          onDeleted: () => character.caste.privileges.remove(p),
        )
      );
    }

    return Column(
      spacing: 12.0,
      children: [
        ...widgets,
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: theme.textTheme.bodySmall,
            ),
            onPressed: () async {
              var result = await showDialog<CharacterCastePrivilege>(
                context: context,
                builder: (BuildContext context) => CastePrivilegePickerDialog(
                  defaultCaste: character.caste.caste != Caste.sansCaste
                      ? character.caste.caste
                      : null,
                ),
              );
              if(!context.mounted) return;
              if(result == null) return;

              character.caste.privileges.add(result);
            },
            child: const Text('Nouveau privilège'),
          ),
        )
      ],
    );
  }
}

class _PrivilegeWidget extends StatelessWidget {
  const _PrivilegeWidget({
    required this.privilege,
    required this.onDeleted,
  });

  final CharacterCastePrivilege privilege;
  final void Function() onDeleted;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDeleted(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${privilege.privilege.title} (${privilege.cost})',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                ),
                if(privilege.description != null)
                  Text(
                    privilege.description!,
                    style: theme.textTheme.bodySmall,
                  )
              ],
            ),
          ),
          if(privilege.privilege.description.isNotEmpty)
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
                    title: privilege.privilege.title,
                    content: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 400,
                        maxWidth: 400,
                        maxHeight: 400,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          privilege.privilege.description,
                        ),
                      )
                    )
                  )
                );
              },
            ),
        ],
      ),
    );
  }
}