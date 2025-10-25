import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/non_player_character.dart';
import '../utils/non_player_character/create_widget.dart';

class NPCCreatePage extends StatelessWidget {
  const NPCCreatePage({ super.key });

  @override
  Widget build(BuildContext context) {
    return NPCCreateWidget(
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