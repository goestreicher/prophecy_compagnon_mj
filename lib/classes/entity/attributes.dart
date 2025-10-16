import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'attributes.g.dart';

enum Attribute {
  physique(title: "Physique"),
  mental(title: "Mental"),
  manuel(title: "Manuel"),
  social(title: "Social");

  const Attribute({
    required this.title,
  });

  final String title;
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

  final Map<Attribute, int> _attributes;

  factory EntityAttributes.fromJson(Map<String, dynamic> json) =>
      _$EntityAttributesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityAttributesToJson(this);
}