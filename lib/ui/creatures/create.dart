import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/creature.dart';
import '../utils/creature/create_widget.dart';

class CreatureCreatePage extends StatelessWidget {
  const CreatureCreatePage({ super.key });

  @override
  Widget build(BuildContext context) {
    return CreatureCreateWidget(
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