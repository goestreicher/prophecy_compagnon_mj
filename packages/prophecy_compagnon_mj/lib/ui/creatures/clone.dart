import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/ui/creature/create_widget.dart';

class CreatureClonePage extends StatelessWidget {
  const CreatureClonePage({ super.key, required this.from });

  final String from;

  @override
  Widget build(BuildContext context) {
    return CreatureCreateWidget(
      cloneFrom: from,
      onCreatureCreated: (Creature? creature) {
        if(creature == null) {
          context.go('/creatures');
        }
        else {
          context.go('/creatures/${creature.id}');
        }
      },
    );
  }
}