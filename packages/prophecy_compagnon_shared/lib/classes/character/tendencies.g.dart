// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tendencies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TendencyAttribute _$TendencyAttributeFromJson(Map<String, dynamic> json) =>
    TendencyAttribute(
      value: (json['value'] as num).toInt(),
      circles: (json['circles'] as num).toInt(),
    );

Map<String, dynamic> _$TendencyAttributeToJson(TendencyAttribute instance) =>
    <String, dynamic>{'value': instance.value, 'circles': instance.circles};

CharacterTendencies _$CharacterTendenciesFromJson(Map<String, dynamic> json) =>
    CharacterTendencies(
      dragon: TendencyAttribute.fromJson(
        json['dragon'] as Map<String, dynamic>,
      ),
      human: TendencyAttribute.fromJson(json['human'] as Map<String, dynamic>),
      fatality: TendencyAttribute.fromJson(
        json['fatality'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CharacterTendenciesToJson(
  CharacterTendencies instance,
) => <String, dynamic>{
  'dragon': instance.dragon.toJson(),
  'human': instance.human.toJson(),
  'fatality': instance.fatality.toJson(),
};
