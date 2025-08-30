import '../../../classes/character/base.dart';

enum CharacterChangeItem {
  caste,
  casteStatus,
  career,
  ability,
  attribute,
}

class CharacterAbilityChangeValue {
  CharacterAbilityChangeValue({ required this.ability, required this.value });

  Ability ability;
  int value;
}

class CharacterAttributeChangeValue {
  CharacterAttributeChangeValue({ required this.attribute, required this.value });

  Attribute attribute;
  int value;
}

enum CharacterListChangeType {
  add,
  del,
}

class CharacterListChangeValue {
  CharacterListChangeValue({ required this.type, required this.value });

  CharacterListChangeType type;
  dynamic value;
}

class CharacterChange {
  CharacterChange({ required this.item, this.value });

  CharacterChangeItem item;
  dynamic value;
}