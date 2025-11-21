import 'package:flutter/material.dart';

import '../../classes/player_character.dart';
import '../utils/character/display_widget.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';

class PCDisplayWidget extends StatefulWidget {
  const PCDisplayWidget({
    super.key,
    required this.id
  });

  final String id;

  @override
  State<PCDisplayWidget> createState() => _PCDisplayWidgetState();
}

class _PCDisplayWidgetState extends State<PCDisplayWidget> {
  late Future<PlayerCharacter?> pcFuture;

  @override
  void initState() {
    super.initState();
    pcFuture = PlayerCharacterStore().get(widget.id);
  }

  @override
  void didUpdateWidget(PCDisplayWidget old) {
    super.didUpdateWidget(old);
    pcFuture = PlayerCharacterStore().get(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pcFuture,
      builder: (BuildContext context, AsyncSnapshot<PlayerCharacter?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: false);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(message: 'PJ ${widget.id} non trouvé', canPop: false);
        }

        PlayerCharacter pc = snapshot.data!;
        return CharacterDisplayWidget(
          character: pc,
        );
      },
    );
  }
}