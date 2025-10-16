import 'package:flutter/material.dart';

import '../../../../classes/draconic_link.dart';
import '../../../../classes/human_character.dart';
import '../../../../classes/magic.dart';
import '../../dismissible_dialog.dart';
import '../../widget_group_container.dart';

class CharacterEditDraconicLinkWidget extends StatelessWidget {
  const CharacterEditDraconicLinkWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Lien',
        style: theme.textTheme.bodySmall!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 12.0,
        children: [
          ValueListenableBuilder(
            valueListenable: character.draconicLink.progressNotifier,
            builder: (BuildContext context, DraconicLinkProgress progress, _) {
              return DropdownMenu(
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                textStyle: theme.textTheme.bodySmall,
                label: const Text('Progression'),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                ),
                initialSelection: progress,
                onSelected: (DraconicLinkProgress? p) {
                  if(p == null) return;
                  character.draconicLink.progress = p;
                },
                leadingIcon: InkWell(
                  onTap: progress == DraconicLinkProgress.aucunLien ? null : () {
                    character.draconicLink.progress = DraconicLinkProgress.aucunLien;
                  },
                  child: Opacity(
                    opacity: progress == DraconicLinkProgress.aucunLien ? 0.4 : 1.0,
                    child: Icon(
                      Icons.cancel,
                      size: 16.0,
                      color: progress == DraconicLinkProgress.aucunLien
                        ? theme.disabledColor
                        : theme.iconTheme.color,
                    ),
                  )
                ),
                dropdownMenuEntries: DraconicLinkProgress.values
                  .map((DraconicLinkProgress p) => DropdownMenuEntry(value: p, label: p.title))
                  .toList(),
              );
            }
          ),
          ValueListenableBuilder(
            valueListenable: character.draconicLink.progressNotifier,
            builder: (BuildContext context, DraconicLinkProgress progress, _) {
              return TextFormField(
                enabled: progress != DraconicLinkProgress.aucunLien,
                initialValue: character.draconicLink.dragon,
                decoration: const InputDecoration(
                  label: Text('Dragon'),
                  border: OutlineInputBorder(),
                ),
                style: theme.textTheme.bodySmall,
                validator: (String? value) {
                  if(progress == DraconicLinkProgress.aucunLien) return null;
                  if(value == null || value.isEmpty) return 'Valeur obligatoire';
                  return null;
                },
                autovalidateMode: AutovalidateMode.disabled,
                onChanged: (String? value) {
                  if(value == null || value.isEmpty) return;
                  character.draconicLink.dragon = value;
                },
              );
            }
          ),
          ValueListenableBuilder(
            valueListenable: character.draconicLink.progressNotifier,
            builder: (BuildContext context, DraconicLinkProgress progress, _) {
              return DropdownMenu(
                enabled: progress != DraconicLinkProgress.aucunLien,
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                textStyle: theme.textTheme.bodySmall,
                label: const Text('Sphère'),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                ),
                initialSelection: character.draconicLink.sphere,
                onSelected: (MagicSphere? sphere) {
                  if(sphere == null) return;
                  character.draconicLink.sphere = sphere;
                },
                dropdownMenuEntries: MagicSphere.values
                  .map((MagicSphere s) => DropdownMenuEntry(value: s, label: s.title))
                  .toList(),
              );
            }
          ),
          WidgetGroupContainer(
            title: Text(
              'Faveurs',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: ValueListenableBuilder(
              valueListenable: character.draconicLink.progressNotifier,
              builder: (BuildContext context, _, _) {
                return ValueListenableBuilder(
                  valueListenable: character.draconicLink.sphereNotifier,
                  builder: (BuildContext context, _, _) {
                    return _FavorsWidget(character: character);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FavorsWidget extends StatelessWidget {
  const _FavorsWidget({ required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var favorWidgets = <Widget>[];

    for(var favor in DraconicLink.favors(progress: character.draconicLink.progress, sphere: character.draconicLink.sphere)) {
      favorWidgets.add(
        _FavorWidget(title: favor.title, description: favor.description),
      );
    }
    if(favorWidgets.isEmpty) {
      favorWidgets.add(
        SizedBox(
          width: double.infinity,
          child: Text(
            'Pas de faveurs',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        )
      );
    }

    return Column(
      spacing: 8.0,
      children: favorWidgets,
    );
  }
}

class _FavorWidget extends StatelessWidget {
  const _FavorWidget({ required this.title, required this.description });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall,
                  softWrap: true,
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
                  title: title,
                  content: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 400,
                        maxWidth: 400,
                        maxHeight: 400,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          description,
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