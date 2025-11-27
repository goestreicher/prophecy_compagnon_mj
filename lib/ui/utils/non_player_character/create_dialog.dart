import 'package:flutter/material.dart';

import '../../../classes/non_player_character.dart';
import '../../../classes/object_source.dart';
import 'create_form.dart';

class NPCCreateDialog extends StatelessWidget {
  const NPCCreateDialog({
    super.key,
    required this.source,
    this.cloneFrom,
  });

  final ObjectSource source;
  final NonPlayerCharacter? cloneFrom;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouveau PNJ'),
      content: NPCCreateForm(
        source: source,
        cloneFrom: cloneFrom,
        onNPCCreated: (NonPlayerCharacter? n) {
          Navigator.of(context, rootNavigator: true).pop(n);
        },
      ),
    );
  }
}