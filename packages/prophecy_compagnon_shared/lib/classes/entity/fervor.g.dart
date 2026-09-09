// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fervor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityFervor _$EntityFervorFromJson(Map<String, dynamic> json) => EntityFervor(
  value: (json['value'] as num?)?.toInt() ?? 0,
  powers: (json['powers'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$SpiritPowerEnumMap, e))
      .toList(),
);

Map<String, dynamic> _$EntityFervorToJson(EntityFervor instance) =>
    <String, dynamic>{
      'value': instance.value,
      'powers': instance.powers.map((e) => _$SpiritPowerEnumMap[e]!).toList(),
    };

const _$SpiritPowerEnumMap = {
  SpiritPower.apaisement: 'apaisement',
  SpiritPower.auraDePresence: 'auraDePresence',
  SpiritPower.barriereMentale: 'barriereMentale',
  SpiritPower.conviction: 'conviction',
  SpiritPower.invasionMentale: 'invasionMentale',
  SpiritPower.lienSpirituel: 'lienSpirituel',
  SpiritPower.meditation: 'meditation',
  SpiritPower.negation: 'negation',
  SpiritPower.sondeMentale: 'sondeMentale',
  SpiritPower.telekinesie: 'telekinesie',
  SpiritPower.telepathie: 'telepathie',
  SpiritPower.transcendance: 'transcendance',
  SpiritPower.transeDActivite: 'transeDActivite',
};
