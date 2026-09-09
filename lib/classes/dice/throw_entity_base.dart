import '../entity/attributes.dart';
import '../entity_base.dart';

abstract class DiceThrowEntityBase {
  DiceThrowEntityBase({
    required this.attribute,
  });

  final Attribute attribute;

  bool canThrow(EntityBase entity) => true;

  String componentLabel(EntityBase entity);
  int componentValue(EntityBase entity);

  String get label;
  int value(EntityBase entity);

  int difficultyModifier(EntityBase entity) => 0;
}