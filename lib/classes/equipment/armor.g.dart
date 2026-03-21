// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'armor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArmorModel _$ArmorModelFromJson(Map<String, dynamic> json) => ArmorModel(
  uuid: json['uuid'] as String,
  name: json['name'] as String,
  unique: json['unique'] as bool? ?? false,
  source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
  description: json['description'] as String? ?? '',
  weight: (json['weight'] as num).toDouble(),
  creationDifficulty: (json['creation_difficulty'] as num).toInt(),
  creationTime: (json['creation_time'] as num).toInt(),
  villageAvailability: EquipmentAvailability.fromJson(
    json['village_availability'] as Map<String, dynamic>,
  ),
  cityAvailability: EquipmentAvailability.fromJson(
    json['city_availability'] as Map<String, dynamic>,
  ),
  handiness: (json['handiness'] as num?)?.toInt() ?? 0,
  layer:
      $enumDecodeNullable(_$EquipableItemLayerEnumMap, json['layer']) ??
      EquipableItemLayer.normal,
  slot: $enumDecode(_$EquipableItemSlotEnumMap, json['slot']),
  type: $enumDecode(_$ArmorTypeEnumMap, json['type']),
  requirements: (json['requirements'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$AbilityEnumMap, k), (e as num).toInt()),
  ),
  protection: (json['protection'] as num).toInt(),
  penalty: (json['penalty'] as num).toInt(),
  supportsMetal: json['supports_metal'] as bool? ?? false,
  intrinsicResistance: $enumDecodeNullable(
    _$EquipmentQualityEnumMap,
    json['intrinsic_resistance'],
  ),
  special: (json['special'] as List<dynamic>?)
      ?.map(
        (e) => EquipmentSpecialCapability.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ArmorModelToJson(ArmorModel instance) =>
    <String, dynamic>{
      'source': instance.source.toJson(),
      'name': instance.name,
      'uuid': instance.uuid,
      'unique': instance.unique,
      'description': instance.description,
      'weight': instance.weight,
      'creation_difficulty': instance.creationDifficulty,
      'creation_time': instance.creationTime,
      'village_availability': instance.villageAvailability.toJson(),
      'city_availability': instance.cityAvailability.toJson(),
      'supports_metal': instance.supportsMetal,
      'intrinsic_resistance':
          ?_$EquipmentQualityEnumMap[instance.intrinsicResistance],
      'special': instance.special.map((e) => e.toJson()).toList(),
      'slot': _$EquipableItemSlotEnumMap[instance.slot]!,
      'handiness': instance.handiness,
      'layer': _$EquipableItemLayerEnumMap[instance.layer]!,
      'type': _$ArmorTypeEnumMap[instance.type]!,
      'requirements': instance.requirements.map(
        (k, e) => MapEntry(_$AbilityEnumMap[k]!, e),
      ),
      'protection': instance.protection,
      'penalty': instance.penalty,
    };

const _$EquipableItemLayerEnumMap = {
  EquipableItemLayer.under: 'under',
  EquipableItemLayer.normal: 'normal',
  EquipableItemLayer.over: 'over',
};

const _$EquipableItemSlotEnumMap = {
  EquipableItemSlot.body: 'body',
  EquipableItemSlot.fullBody: 'fullBody',
  EquipableItemSlot.upperBody: 'upperBody',
  EquipableItemSlot.head: 'head',
  EquipableItemSlot.forehead: 'forehead',
  EquipableItemSlot.ears: 'ears',
  EquipableItemSlot.neck: 'neck',
  EquipableItemSlot.torso: 'torso',
  EquipableItemSlot.chest: 'chest',
  EquipableItemSlot.arms: 'arms',
  EquipableItemSlot.upperArm: 'upperArm',
  EquipableItemSlot.forearm: 'forearm',
  EquipableItemSlot.hands: 'hands',
  EquipableItemSlot.dominantHand: 'dominantHand',
  EquipableItemSlot.weakHand: 'weakHand',
  EquipableItemSlot.finger: 'finger',
  EquipableItemSlot.belt: 'belt',
  EquipableItemSlot.legs: 'legs',
  EquipableItemSlot.feet: 'feet',
};

const _$ArmorTypeEnumMap = {
  ArmorType.light: 'light',
  ArmorType.medium: 'medium',
  ArmorType.heavy: 'heavy',
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

const _$EquipmentQualityEnumMap = {
  EquipmentQuality.inferior: 'inferior',
  EquipmentQuality.normal: 'normal',
  EquipmentQuality.good: 'good',
  EquipmentQuality.veryGood: 'veryGood',
  EquipmentQuality.superior: 'superior',
  EquipmentQuality.exceptional: 'exceptional',
  EquipmentQuality.incredible: 'incredible',
  EquipmentQuality.legendary: 'legendary',
};
