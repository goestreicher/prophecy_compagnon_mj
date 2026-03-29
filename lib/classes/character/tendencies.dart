import 'package:json_annotation/json_annotation.dart';

part 'tendencies.g.dart';

enum Tendency {
  dragon(title: "Dragon"),
  human(title: "Homme"),
  fatality(title: "Fatalité"),
  ;

  final String title;

  const Tendency({ required this.title });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TendencyAttribute {
  TendencyAttribute({ required this.value, required this.circles });

  int value;
  int circles;

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

  TendencyAttribute operator [](Tendency tendency) {
    switch(tendency) {
      case Tendency.dragon:
        return dragon;
      case Tendency.human:
        return human;
      case Tendency.fatality:
        return fatality;
    }
  }

  factory CharacterTendencies.fromJson(Map<String, dynamic> json) => _$CharacterTendenciesFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterTendenciesToJson(this);
}