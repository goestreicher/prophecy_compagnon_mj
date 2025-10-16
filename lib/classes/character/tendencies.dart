import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tendencies.g.dart';

enum Tendency {
  dragon,
  human,
  fatality,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TendencyAttribute {
  TendencyAttribute({ required int value, required int circles })
    : valueNotifier = ValueNotifier<int>(value),
      circlesNotifier = ValueNotifier<int>(circles);

  int get value => valueNotifier.value;
  set value(int v) => valueNotifier.value = v;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ValueNotifier<int> valueNotifier;

  int get circles => circlesNotifier.value;
  set circles(int v) => circlesNotifier.value = v;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ValueNotifier<int> circlesNotifier;

  factory TendencyAttribute.fromJson(Map<String, dynamic> json) =>
      _$TendencyAttributeFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TendencyAttributeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterTendencies {
  CharacterTendencies.empty()
      : dragon = TendencyAttribute(value: 0, circles: 0),
        human = TendencyAttribute(value: 0, circles: 0),
        fatality = TendencyAttribute(value: 0, circles: 0);

  CharacterTendencies({
    required this.dragon,
    required this.human,
    required this.fatality,
  });

  TendencyAttribute dragon;
  TendencyAttribute human;
  TendencyAttribute fatality;

  factory CharacterTendencies.fromJson(Map<String, dynamic> json) => _$CharacterTendenciesFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterTendenciesToJson(this);
}