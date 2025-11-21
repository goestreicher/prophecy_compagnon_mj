import 'package:flutter/material.dart';

import '../../../classes/non_player_character.dart';
import '../character/display_widget.dart';
import '../error_feedback.dart';
import '../full_page_loading.dart';

class NPCDisplayWidget extends StatefulWidget {
  const NPCDisplayWidget({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<NPCDisplayWidget> createState() => _NPCDisplayWidgetState();
}

class _NPCDisplayWidgetState extends State<NPCDisplayWidget> {
  late Future<NonPlayerCharacter?> npcFuture;

  @override
  void initState() {
    super.initState();
    npcFuture = NonPlayerCharacter.get(widget.id);
  }

  @override
  void didUpdateWidget(NPCDisplayWidget old) {
    super.didUpdateWidget(old);
    npcFuture = NonPlayerCharacter.get(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: npcFuture,
      builder: (BuildContext context, AsyncSnapshot<NonPlayerCharacter?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: false);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(message: 'PNJ ${widget.id} non trouvé', canPop: false);
        }

        NonPlayerCharacter npc = snapshot.data!;
        return CharacterDisplayWidget(
          character: npc,
        );
      },
    );
  }
}