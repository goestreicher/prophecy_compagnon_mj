import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/character/skill.dart';
import '../../../../classes/entity_base.dart';
import '../../character/change_stream.dart';
import '../../widget_group_container.dart';
import 'edit_skill_family_container.dart';

class EntityEditSkillGroupContainer extends StatefulWidget {
  const EntityEditSkillGroupContainer({
    super.key,
    required this.entity,
    required this.attribute,
    this.changeStreamController,
  });

  final EntityBase entity;
  final StreamController<CharacterChange>? changeStreamController;
  final Attribute attribute;

  @override
  State<EntityEditSkillGroupContainer> createState() => _EntityEditSkillGroupContainerState();
}

class _EntityEditSkillGroupContainerState extends State<EntityEditSkillGroupContainer> {
  late int currentAttributeValue;

  @override
  void initState() {
    super.initState();

    currentAttributeValue = widget.entity.attribute(widget.attribute);

    widget.changeStreamController?.stream.listen((CharacterChange change) {
      if(
          change.item == CharacterChangeItem.attribute
          && change.value != null
          && (change.value as CharacterAttributeChangeValue).attribute == widget.attribute
      ) {
        setState(() {
          currentAttributeValue = (change.value as CharacterAttributeChangeValue).value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var familyWidgets = SkillFamily.values
      .where((SkillFamily f) => f.defaultAttribute == widget.attribute)
      .map(
        (SkillFamily f) => EntityEditSkillFamilyContainer(
          entity: widget.entity,
          changeStreamController: widget.changeStreamController,
          family: f,
        )
      ).toList();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 450,
      ),
      child: WidgetGroupContainer(
        title: Text(
          '${widget.attribute.title} : $currentAttributeValue',
          style: theme.textTheme.titleLarge!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          )
        ),
        child: Column(
          spacing: 20.0,
          children: familyWidgets,
        )
      ),
    );
  }
}