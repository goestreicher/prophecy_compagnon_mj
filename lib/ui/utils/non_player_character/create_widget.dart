import 'package:flutter/material.dart';

import '../../../classes/non_player_character.dart';
import '../../../classes/npc_category.dart';
import '../../../classes/object_source.dart';
import '../../../text_utils.dart';
import '../error_feedback.dart';
import '../single_line_input_dialog.dart';
import '../character/edit_widget.dart';
import 'create_form.dart';

class NPCCreateWidget extends StatefulWidget {
  const NPCCreateWidget({
    super.key,
    required this.onNPCCreated,
    this.source,
    this.cloneFrom
  });

  final void Function(NonPlayerCharacter?) onNPCCreated;
  final ObjectSource? source;
  final String? cloneFrom;

  @override
  State<NPCCreateWidget> createState() => _NPCCreateWidgetState();
}

class _NPCCreateWidgetState extends State<NPCCreateWidget> {
  NonPlayerCharacter? from;
  NonPlayerCharacter? npc;

  @override
  Widget build(BuildContext context) {
    if(widget.cloneFrom != null && from == null) {
      return FutureBuilder(
        future: NonPlayerCharacter.get(widget.cloneFrom!),
        builder: (BuildContext context, AsyncSnapshot<NonPlayerCharacter?> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('PNJ source non trouvé'),
            );
          }

          from = snapshot.data!;
          return getNPCCreateForm();
        }
      );
    }

    if(npc == null) {
      return getNPCCreateForm();
    }

    return CharacterEditWidget(
      character: npc!,
      onEditDone: (bool result) async {
        if(result) {
          await NonPlayerCharacter.saveLocalModel(npc!);
        }
        else {
          NonPlayerCharacter.removeFromCache(npc!.id);
          npc = null;
        }

        widget.onNPCCreated(npc);
      }
    );
  }

  Widget getNPCCreateForm() {
    return Center(
      child: SizedBox(
        width: 400,
        child: SizedBox(
          child: NPCCreateForm(
            source: widget.source ?? ObjectSource.local,
            cloneFrom: from,
            onNPCCreated: (NonPlayerCharacter? n) {
              if(n == null) {
                widget.onNPCCreated(null);
              }
              else {
                setState(() {
                  npc = n;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}