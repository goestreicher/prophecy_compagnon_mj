import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

import 'abilities.dart';

part 'attributes.g.dart';

enum Attribute {
  physique(title: "Physique", relatedAbilities: [Ability.force, Ability.resistance]),
  mental(title: "Mental", relatedAbilities: [Ability.intelligence, Ability.volonte]),
  manuel(title: "Manuel", relatedAbilities: [Ability.perception, Ability.coordination]),
  social(title: "Social", relatedAbilities: [Ability.empathie, Ability.presence]);

  const Attribute({
    required this.title,
    required this.relatedAbilities,
  });

  final String title;
  final List<Ability> relatedAbilities;
}

class AttributeStreamChange {
  AttributeStreamChange({ required this.attribute, required this.value });

  Attribute attribute;
  int value;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, constructor: 'empty')
class EntityAttributes {
  EntityAttributes({ required Map<Attribute, int> attributes })
    : _attributes = Map.from(attributes);

  EntityAttributes.empty()
      : _attributes = <Attribute, int>{for(var a in Attribute.values) a: 0};

  @JsonKey(includeFromJson: false, includeToJson: false)
  StreamController<AttributeStreamChange> streamController =
      StreamController<AttributeStreamChange>.broadcast();

  Map<Attribute, int> get all => _attributes;

  int get physique => attribute(Attribute.physique);
  set physique(int v) => setAttribute(Attribute.physique, v);

  int get mental => attribute(Attribute.mental);
  set mental(int v) => setAttribute(Attribute.mental, v);

  int get manuel => attribute(Attribute.manuel);
  set manuel(int v) => setAttribute(Attribute.manuel, v);

  int get social => attribute(Attribute.social);
  set social(int v) => setAttribute(Attribute.social, v);

  int attribute(Attribute a) => _attributes[a] ?? 0;

  void setAttribute(Attribute a, int v) {
    _attributes[a] = v;
    streamController.add(AttributeStreamChange(attribute: a, value: v));
  }

  static int? attributeModifier(Attribute attribute, Map<Ability, int> abilities) {
    int? modifier;
    var sum = 0;
    for(var ability in attribute.relatedAbilities) {
      if(!abilities.containsKey(ability)) {
        return null;
      }
      sum += abilities[ability]!;
    }

    switch(sum) {
      case >=1 && <= 2:
        modifier = -3;
      case >= 3 && <= 5:
        modifier = -2;
      case >= 6 && <= 8:
        modifier = -1;
      case >= 9 && <= 11:
        modifier = 0;
      case >= 12 && <= 13:
        modifier = 1;
      case >= 14 && <= 15:
        modifier = 2;
      case >= 16 && <= 17:
        modifier = 3;
      case >= 18 && <= 19:
        modifier = 4;
      case >= 20:
        modifier = 5;
    }

    return modifier;
  }

  final Map<Attribute, int> _attributes;

  factory EntityAttributes.fromJson(Map<String, dynamic> json) =>
      _$EntityAttributesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityAttributesToJson(this);
}