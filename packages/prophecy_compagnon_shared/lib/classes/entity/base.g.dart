// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttributeBasedCalculator _$AttributeBasedCalculatorFromJson(
  Map<String, dynamic> json,
) => AttributeBasedCalculator(
  static: (json['static'] as num?)?.toDouble(),
  ability: $enumDecodeNullable(_$AbilityEnumMap, json['ability']),
  multiply: (json['multiply'] as num?)?.toInt() ?? 1,
  add: (json['add'] as num?)?.toInt() ?? 0,
  dice: (json['dice'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AttributeBasedCalculatorToJson(
  AttributeBasedCalculator instance,
) => <String, dynamic>{
  'static': instance.static,
  'ability': _$AbilityEnumMap[instance.ability],
  'multiply': instance.multiply,
  'add': instance.add,
  'dice': instance.dice,
};

const _$AbilityEnumMap = {
  Ability.force: 'force',
  Ability.intelligence: 'intelligence',
  Ability.coordination: 'coordination',
  Ability.presence: 'presence',
  Ability.resistance: 'resistance',
  Ability.volonte: 'volonte',
  Ability.perception: 'perception',
  Ability.empathie: 'empathie',
};
