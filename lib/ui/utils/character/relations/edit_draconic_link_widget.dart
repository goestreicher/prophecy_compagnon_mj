import 'package:flutter/material.dart';

import '../../../../classes/draconic_link.dart';
import '../../../../classes/human_character.dart';
import '../../../../classes/magic.dart';
import '../../dismissible_dialog.dart';
import '../../widget_group_container.dart';

class CharacterEditDraconicLinkWidget extends StatefulWidget {
  const CharacterEditDraconicLinkWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  State<CharacterEditDraconicLinkWidget> createState() => _CharacterEditDraconicLinkWidgetState();
}

class _CharacterEditDraconicLinkWidgetState extends State<CharacterEditDraconicLinkWidget> {
  final TextEditingController dragonController = TextEditingController();

  late DraconicLinkProgress currentProgress;
  late String currentDragon;
  late MagicSphere currentSphere;

  @override
  void initState() {
    super.initState();
    refreshFromCharacter();
  }

  void refreshFromCharacter() {
    if(widget.character.draconicLink != null) {
      currentProgress = widget.character.draconicLink!.progress;
      currentDragon = widget.character.draconicLink!.dragon;
      currentSphere = widget.character.draconicLink!.sphere;
    }
    else {
      currentProgress = DraconicLinkProgress.aucunLien;
      currentDragon = '';
      currentSphere = MagicSphere.pierre;
    }

    dragonController.text = currentDragon;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var favorWidgets = <Widget>[];
    for(var favor in DraconicLink.favors(progress: currentProgress, sphere: currentSphere)) {
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
          DropdownMenu(
            requestFocusOnTap: true,
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            label: const Text('Progression'),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            initialSelection: currentProgress,
            onSelected: (DraconicLinkProgress? progress) {
              if(progress == null) return;

              if(progress == DraconicLinkProgress.aucunLien) {
                setState(() {
                  widget.character.draconicLink = null;
                  refreshFromCharacter();
                });
              }
              else {
                setState(() {
                  currentProgress = progress;
                });
              }
            },
            leadingIcon: InkWell(
              onTap: currentProgress == DraconicLinkProgress.aucunLien ? null : () {
                setState(() {
                  widget.character.draconicLink = null;
                  refreshFromCharacter();
                });
              },
              child: Opacity(
                opacity: widget.character.career == null ? 0.4 : 1.0,
                child: Icon(
                  Icons.cancel,
                  size: 16.0,
                  color: currentProgress == DraconicLinkProgress.aucunLien
                    ? theme.disabledColor
                    : theme.iconTheme.color,
                ),
              )
            ),
            dropdownMenuEntries: DraconicLinkProgress.values
              .map((DraconicLinkProgress p) => DropdownMenuEntry(value: p, label: p.title))
              .toList(),
          ),
          TextFormField(
            enabled: currentProgress != DraconicLinkProgress.aucunLien,
            controller: dragonController,
            decoration: const InputDecoration(
              label: Text('Dragon'),
              border: OutlineInputBorder(),
            ),
            style: theme.textTheme.bodySmall,
            validator: (String? value) {
              if(currentProgress == DraconicLinkProgress.aucunLien) return null;
              if(dragonController.text.isEmpty) return 'Valeur obligatoire';
              return null;
            },
            autovalidateMode: AutovalidateMode.disabled,
            onChanged: (String? value) {
              if(value == null || value.isEmpty) return;
              currentDragon = value;
            },
            onSaved: (String? value) {
              widget.character.draconicLink = DraconicLink(
                sphere: currentSphere,
                dragon: currentDragon,
                progress: currentProgress,
              );
            },
          ),
          DropdownMenu(
            enabled: currentProgress != DraconicLinkProgress.aucunLien,
            requestFocusOnTap: true,
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            label: const Text('Sphère'),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            initialSelection: currentSphere,
            onSelected: (MagicSphere? sphere) {
              if(sphere == null) return;
              setState(() {
                currentSphere = sphere;
              });
            },
            dropdownMenuEntries: MagicSphere.values
              .map((MagicSphere s) => DropdownMenuEntry(value: s, label: s.title))
              .toList(),
          ),
          WidgetGroupContainer(
            title: Text(
              'Faveurs',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Column(
              spacing: 8.0,
              children: favorWidgets,
            ),
          ),
        ],
      ),
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