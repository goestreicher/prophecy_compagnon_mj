import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../widget_group_container.dart';
import '../change_stream.dart';

class CharacterViewCasteTechniquesWidget extends StatefulWidget {
  const CharacterViewCasteTechniquesWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  State<CharacterViewCasteTechniquesWidget> createState() => _CharacterViewCasteTechniquesWidgetState();
}

class _CharacterViewCasteTechniquesWidgetState extends State<CharacterViewCasteTechniquesWidget> {
  late Caste lastCaste;

  @override
  void initState() {
    super.initState();

    lastCaste = widget.character.caste;

    widget.changeStreamController.stream.listen((CharacterChange change) {
      if(change.item == CharacterChangeItem.caste) {
        if(change.value == null) return;

        var v = change.value as Caste;
        if(v != lastCaste) {
          setState(() {
            lastCaste = v;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];

    for(var t in Caste.techniques(widget.character.caste, widget.character.casteStatus)) {
      widgets.add(_CasteTechniqueWidget(technique: t));
    }

    if(widgets.isEmpty) {
      widgets.add(
        SizedBox(
          width: double.infinity,
          child: Text(
            'Pas de techniques',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        )
      );
    }

    return WidgetGroupContainer(
      title: Text(
        'Techniques de Caste',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 12.0,
        children: widgets,
      )
    );
  }
}

class _CasteTechniqueWidget extends StatelessWidget {
  const _CasteTechniqueWidget({ required this.technique });

  final String technique;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technique,
                  style: theme.textTheme.bodySmall,
                  softWrap: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}