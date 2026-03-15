// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc_gear.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiscGearModel _$MiscGearModelFromJson(Map<String, dynamic> json) =>
    MiscGearModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      unique: json['unique'] as bool? ?? false,
      source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
      location: json['location'] == null
          ? ObjectLocation.memory
          : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
      weight: (json['weight'] as num).toDouble(),
      creationDifficulty: (json['creation_difficulty'] as num).toInt(),
      creationTime: (json['creation_time'] as num).toInt(),
      villageAvailability: EquipmentAvailability.fromJson(
        json['village_availability'] as Map<String, dynamic>,
      ),
      cityAvailability: EquipmentAvailability.fromJson(
        json['city_availability'] as Map<String, dynamic>,
      ),
      supportsMetal: json['supports_metal'] as bool? ?? false,
      special: (json['special'] as List<dynamic>?)
          ?.map(
            (e) =>
                EquipmentSpecialCapability.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$MiscGearModelToJson(MiscGearModel instance) =>
    <String, dynamic>{
      'source': instance.source.toJson(),
      'name': instance.name,
      'uuid': instance.uuid,
      'unique': instance.unique,
      'weight': instance.weight,
      'creation_difficulty': instance.creationDifficulty,
      'creation_time': instance.creationTime,
      'village_availability': instance.villageAvailability.toJson(),
      'city_availability': instance.cityAvailability.toJson(),
      'supports_metal': instance.supportsMetal,
      'special': instance.special.map((e) => e.toJson()).toList(),
    };
