import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/non_player_character.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/ui/non_player_character/create_form.dart';

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