import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/career.dart';
import '../../../../classes/human_character.dart';
import '../../widget_group_container.dart';
import '../change_stream.dart';

class CharacterViewCasteBenefitsWidget extends StatefulWidget {
  const CharacterViewCasteBenefitsWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  State<CharacterViewCasteBenefitsWidget> createState() => _CharacterViewCasteBenefitsWidgetState();
}

class _CharacterViewCasteBenefitsWidgetState extends State<CharacterViewCasteBenefitsWidget> {
  late Caste lastCaste;
  late Career? lastCareer;

  @override
  void initState() {
    super.initState();

    lastCaste = widget.character.caste;
    lastCareer = widget.character.career;

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
      else if(change.item == CharacterChangeItem.career) {
        var v = change.value as Career?;
        if(v != lastCareer) {
          setState(() {
            lastCareer = v;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];

    for(var b in Caste.benefits(widget.character.caste, widget.character.casteStatus)) {
      widgets.add(_CasteBenefitWidget(benefit: b));
    }

    if(lastCareer != null) {
      widgets.add(_CasteBenefitWidget(benefit: 'Bénéfice de carrière : ${lastCareer!.benefit.title}\n${lastCareer!.benefit.description}'));
    }

    if(widgets.isEmpty) {
      widgets.add(
        SizedBox(
          width: double.infinity,
          child: Text(
            'Pas de bénéfices',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
            ),
            softWrap: true,
          ),
        )
      );
    }

    return WidgetGroupContainer(
      title: Text(
        'Bénéfices de Caste',
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

class _CasteBenefitWidget extends StatelessWidget {
  const _CasteBenefitWidget({ required this.benefit });

  final String benefit;

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
                  benefit,
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