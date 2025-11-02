import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/encounter_entity_factory.dart';
import '../../classes/entity_base.dart';
import '../../classes/non_player_character.dart';
import '../../classes/resource_link/resource_link.dart';
import '../../classes/scenario_encounter.dart';
import '../utils/resource_link/link_handler.dart';

class ScenarioEncounterDisplayWidget extends StatelessWidget {
  const ScenarioEncounterDisplayWidget({ super.key, required this.encounter });

  final ScenarioEncounter encounter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 24.0,
      children: [
        for(var e in encounter.entities)
          _EncounterEntityModelWidget(entity: e),
      ],
    );
  }
}

class _EncounterEntityModelWidget extends StatelessWidget {
  const _EncounterEntityModelWidget({ required this.entity });

  final EncounterEntity entity;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EncounterEntityFactory.instance.getModel(entity.id),
      builder: (BuildContext context, AsyncSnapshot<EncounterEntityModel?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("Pas de données pour l'entité ${entity.id}"));
        }

        var model = snapshot.data!;
        var theme = Theme.of(context);
        var prefix = '';
        ResourceLink? modelLink;
        String? modelType;

        if(model is EntityBase) {
          if (model is Creature) {
            modelType = 'creature';
          }
          else if (model is NonPlayerCharacter) {
            modelType = 'npc';
          }

          if(modelType != null) {
            var store = (model as EntityBase).location.type.name;
            var id = (model as EntityBase).id;
            modelLink = ResourceLink(
                name: model.displayName(),
                link: 'resource://$store/$modelType/$id'
            );
          }
        }

        if(model is NonPlayerCharacter) {
          prefix = '\u{1F9D9} ';
        }
        else if(model is Creature) {
          prefix = '\u{1F9CC} ';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    '$prefix${model.displayName()}',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    handleResourceLinkClicked(
                      modelLink!,
                      context,
                    );
                  },
                  icon: const Icon(Icons.help_outline),
                ),
              ],
            ),
            if(!model.isUnique())
              Text('Nombre minimum: ${entity.min} - Nombre maximum: ${entity.max}')
          ],
        );
      }
    );
  }
}