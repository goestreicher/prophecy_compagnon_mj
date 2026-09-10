import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/ui/creature/edit_widget.dart';

class CreatureEditPage extends StatelessWidget {
  const CreatureEditPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Creature.get(id),
      builder: (BuildContext context, AsyncSnapshot<Creature?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text('Creature non trouvée'),
          );
        }

        var creature = snapshot.data!;

        return CreatureEditWidget(
          creature: creature,
          onEditDone: (bool result) async {
            if(result) {
              await Creature.saveLocalModel(creature);
              if(!context.mounted) return;
              context.go('/creatures/${creature.id}');
            }
            else {
              await Creature.reloadFromStore(id);
              if(!context.mounted) return;
              context.go('/creatures/${creature.id}');
            }
          }
        );
      }
    );
  }
}