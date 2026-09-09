import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';

class DiceThrowEntityBaseAbility extends DiceThrowEntityBase {
  DiceThrowEntityBaseAbility({
    required super.attribute,
    required this.ability,
  });

  final Ability ability;

  @override
  String get label => '${attribute.title} + ${ability.title}';

  @override
  String componentLabel(EntityBase entity) => ability.title;

  @override
  int componentValue(EntityBase entity) => entity.abilities[ability];

  @override
  int value(EntityBase entity) {
    // TODO: manage bonuses
    return entity.attributes[attribute] + entity.abilities[ability];
  }
}