import 'package:flutter/material.dart';

import '../../../classes/creature.dart';
import '../../../classes/object_source.dart';
import 'create_form.dart';

class CreatureCreateDialog extends StatelessWidget {
  const CreatureCreateDialog({ super.key, required this.source, this.cloneFrom });

  final ObjectSource source;
  final Creature? cloneFrom;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle créature'),
      content: CreatureCreateForm(
        source: source,
        cloneFrom: cloneFrom,
        onCreatureCreated: (Creature? c) {
          Navigator.of(context, rootNavigator: true).pop(c);
        },
      ),
    );
  }
}