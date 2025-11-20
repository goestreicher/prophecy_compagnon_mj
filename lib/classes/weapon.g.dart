// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weapon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeaponModel _$WeaponModelFromJson(Map<String, dynamic> json) => WeaponModel(
  id: WeaponModel._getIdFromJson(json, 'id') as String,
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
  skill: SpecializedSkill.fromJson(
    WeaponModel._getSkillFromJson(json, 'skill') as Map<String, dynamic>,
  ),
  bodyPart: $enumDecode(_$EquipableItemBodyPartEnumMap, json['body_part']),
  hands: (json['hands'] as num).toInt(),
  requirements: (json['requirements'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$AbilityEnumMap, k), (e as num).toInt()),
  ),
  initiative: (json['initiative'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry($enumDecode(_$WeaponRangeEnumMap, k), (e as num).toInt()),
  ),
  damage: AttributeBasedCalculator.fromJson(
    json['damage'] as Map<String, dynamic>,
  ),
  rangeEffective: AttributeBasedCalculator.fromJson(
    json['range_effective'] as Map<String, dynamic>,
  ),
  rangeMax: AttributeBasedCalculator.fromJson(
    json['range_max'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WeaponModelToJson(WeaponModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'weight': instance.weight,
      'creation_difficulty': instance.creationDifficulty,
      'creation_time': instance.creationTime,
      'village_availability': instance.villageAvailability.toJson(),
      'city_availability': instance.cityAvailability.toJson(),
      'skill': WeaponModel._setSkillToJson(instance.skill),
      'body_part': _$EquipableItemBodyPartEnumMap[instance.bodyPart]!,
      'hands': instance.hands,
      'requirements': instance.requirements.map(
        (k, e) => MapEntry(_$AbilityEnumMap[k]!, e),
      ),
      'initiative': instance.initiative.map(
        (k, e) => MapEntry(_$WeaponRangeEnumMap[k]!, e),
      ),
      'damage': instance.damage.toJson(),
      'range_effective': instance.rangeEffective.toJson(),
      'range_max': instance.rangeMax.toJson(),
    };

const _$EquipableItemBodyPartEnumMap = {
  EquipableItemBodyPart.none: 'none',
  EquipableItemBodyPart.body: 'body',
  EquipableItemBodyPart.hand: 'hand',
  EquipableItemBodyPart.feet: 'feet',
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

const _$WeaponRangeEnumMap = {
  WeaponRange.contact: 'contact',
  WeaponRange.melee: 'melee',
  WeaponRange.distance: 'distance',
  WeaponRange.ranged: 'ranged',
};
