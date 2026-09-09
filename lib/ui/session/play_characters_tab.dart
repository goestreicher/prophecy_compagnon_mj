import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/dice/throw_entity_base_skill.dart';
import '../../classes/dice/throw_request.dart';
import '../../classes/dice/throw_result.dart';
import '../../classes/entity/abilities.dart';
import '../../classes/entity/attributes.dart';
import '../../classes/entity/skill.dart';
import '../../classes/session/game_session.dart';
import '../utils/session/entity_dice_throw_dialog.dart';
import '../utils/session/evaluate_dice_throw.dart';

class PlayCharactersPage extends StatelessWidget {
  const PlayCharactersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var session = context.watch<GameSession>();

    var pcWidgets = <Widget>[];
    for(var pc in session.table.players) {
      pcWidgets.add(
        Row(
          spacing: 8.0,
          children: [
            Text(pc.name),
            TextButton(
              onPressed: () async {
                var request = DiceThrowRequest(
                  difficulty: 15,
                  base: DiceThrowEntityBaseSkill(
                    attribute: Attribute.physique,
                    ability: Ability.force,
                    skill: Skill.athletisme,
                  )
                );

                var result = await showDialog<DiceThrowResult>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => EntityDiceThrowDialog(
                    entity: pc,
                    request: request,
                  ),
                );
                if(result == null) return;

                var bundle = EntityThrowBundle(
                  entity: pc,
                  request: request,
                  result: result,
                );

                evaluateDiceThrow(bundle);
              },
              child: Text('click-o'),
            )
          ],
        )
      );
    }

    return Column(
      spacing: 12.0,
      children: pcWidgets,
    );
  }
}