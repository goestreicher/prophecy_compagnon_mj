import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/ui/creature/create_form.dart';

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