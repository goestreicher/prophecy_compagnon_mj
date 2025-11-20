// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquipmentAvailability _$EquipmentAvailabilityFromJson(
  Map<String, dynamic> json,
) => EquipmentAvailability(
  scarcity: $enumDecode(_$EquipmentScarcityEnumMap, json['scarcity']),
  price: (json['price'] as num).toInt(),
);

Map<String, dynamic> _$EquipmentAvailabilityToJson(
  EquipmentAvailability instance,
) => <String, dynamic>{
  'scarcity': _$EquipmentScarcityEnumMap[instance.scarcity]!,
  'price': instance.price,
};

const _$EquipmentScarcityEnumMap = {
  EquipmentScarcity.tresCommun: 'tresCommun',
  EquipmentScarcity.commun: 'commun',
  EquipmentScarcity.peuCommun: 'peuCommun',
  EquipmentScarcity.rare: 'rare',
  EquipmentScarcity.tresRare: 'tresRare',
  EquipmentScarcity.introuvable: 'introuvable',
  EquipmentScarcity.nonApplicable: 'nonApplicable',
};

Map<String, dynamic> _$SupportsEquipableItemToJson(
  SupportsEquipableItem instance,
) => <String, dynamic>{};
