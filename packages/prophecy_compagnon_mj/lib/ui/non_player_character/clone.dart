import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_shared/classes/non_player_character.dart';
import 'package:prophecy_compagnon_shared/ui/non_player_character/create_widget.dart';

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