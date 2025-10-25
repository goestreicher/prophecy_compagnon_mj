import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/non_player_character.dart';
import '../utils/non_player_character/create_widget.dart';

class NPCClonePage extends StatelessWidget {
  const NPCClonePage({ super.key, required this.from });

  final String from;

  @override
  Widget build(BuildContext context) {
    return NPCCreateWidget(
      cloneFrom: from,
      onNPCCreated: (NonPlayerCharacter? npc) {
        if(npc == null) {
          context.go('/npcs');
        }
        else {
          context.go('/npcs/${npc.id}');
        }
      },
    );
  }
}