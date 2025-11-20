// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shield.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShieldModel _$ShieldModelFromJson(Map<String, dynamic> json) => ShieldModel(
  id: ShieldModel._getIdFromJson(json, 'id') as String,
  name: json['name'] as String,
  weight: (json['weight'] as num).toDouble(),
  creationDifficulty: (json['creation_difficulty'] as num).toInt(),
  creationTime: (json['creation_time'] as num).toInt(),
  villageAvailability: EquipmentAvailability.fromJson(
    json['village_availability'] as Map<String, dynamic>,
  ),
  cityAvailability: EquipmentAvailability.fromJson(
    json['city_availability'] as Map<String, dynamic>,
  ),
  requirements: (json['requirements'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$AbilityEnumMap, k), (e as num).toInt()),
  ),
  protection: (json['protection'] as num).toInt(),
  penalty: (json['penalty'] as num).toInt(),
  damage: AttributeBasedCalculator.fromJson(
    json['damage'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ShieldModelToJson(ShieldModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'weight': instance.weight,
      'creation_difficulty': instance.creationDifficulty,
      'creation_time': instance.creationTime,
      'village_availability': instance.villageAvailability.toJson(),
      'city_availability': instance.cityAvailability.toJson(),
      'requirements': instance.requirements.map(
        (k, e) => MapEntry(_$AbilityEnumMap[k]!, e),
      ),
      'protection': instance.protection,
      'penalty': instance.penalty,
      'damage': instance.damage.toJson(),
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
