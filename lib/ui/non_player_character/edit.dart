import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/non_player_character.dart';
import '../utils/character/edit_widget.dart';

class NPCEditPage extends StatelessWidget {
  const NPCEditPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NonPlayerCharacter.get(id),
      builder: (BuildContext context, AsyncSnapshot<NonPlayerCharacter?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text('PNJ non trouvé'),
          );
        }

        var npc = snapshot.data!;

        return CharacterEditWidget(
          character: npc,
          onEditDone: (bool result) async {
            if(result) {
              await NonPlayerCharacter.saveLocalModel(npc);
              if(!context.mounted) return;
              context.go('/npcs/${npc.id}');
            }
            else {
              await NonPlayerCharacter.reloadFromStore(id);
              if(!context.mounted) return;
              context.go('/npcs/${npc.id}');
            }
          }
        );
      }
    );
  }
}