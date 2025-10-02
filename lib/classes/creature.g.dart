// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NaturalWeaponModelRangeSpecification
_$NaturalWeaponModelRangeSpecificationFromJson(Map<String, dynamic> json) =>
    NaturalWeaponModelRangeSpecification(
      initiative: (json['initiative'] as num).toInt(),
      effectiveDistance: (json['effective_distance'] as num).toDouble(),
      maximumDistance: (json['maximum_distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NaturalWeaponModelRangeSpecificationToJson(
  NaturalWeaponModelRangeSpecification instance,
) => <String, dynamic>{
  'initiative': instance.initiative,
  'effective_distance': instance.effectiveDistance,
  'maximum_distance': instance.maximumDistance,
};

NaturalWeaponModel _$NaturalWeaponModelFromJson(Map<String, dynamic> json) =>
    NaturalWeaponModel(
      name: json['name'] as String,
      skill: (json['skill'] as num).toInt(),
      damage: (json['damage'] as num).toInt(),
      ranges: (json['ranges'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          $enumDecode(_$WeaponRangeEnumMap, k),
          NaturalWeaponModelRangeSpecification.fromJson(
            e as Map<String, dynamic>,
          ),
        ),
      ),
    );

Map<String, dynamic> _$NaturalWeaponModelToJson(NaturalWeaponModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'skill': instance.skill,
      'damage': instance.damage,
      'ranges': instance.ranges.map(
        (k, e) => MapEntry(_$WeaponRangeEnumMap[k]!, e.toJson()),
      ),
    };

const _$WeaponRangeEnumMap = {
  WeaponRange.contact: 'contact',
  WeaponRange.melee: 'melee',
  WeaponRange.distance: 'distance',
  WeaponRange.ranged: 'ranged',
};

CreatureSummary _$CreatureSummaryFromJson(Map<String, dynamic> json) =>
    CreatureSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      category: const CreatureCategoryJsonConverter().fromJson(
        json['category'] as String,
      ),
      location: json['location'] == null
          ? ObjectLocation.memory
          : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
      source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
      icon: json['icon'] == null
          ? null
          : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatureSummaryToJson(
  CreatureSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': const CreatureCategoryJsonConverter().toJson(instance.category),
  'source': instance.source.toJson(),
  'icon': instance.icon?.toJson(),
};

Creature _$CreatureFromJson(Map<String, dynamic> json) =>
    Creature(
        uuid: json['uuid'] as String?,
        location: json['location'] == null
            ? ObjectLocation.memory
            : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
        source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
        name: json['name'] as String,
        initiative: (json['initiative'] as num).toInt(),
        size: (json['size'] as num).toDouble(),
        description: json['description'] as String?,
        image: json['image'] == null
            ? null
            : ExportableBinaryData.fromJson(
                json['image'] as Map<String, dynamic>,
              ),
        icon: json['icon'] == null
            ? null
            : ExportableBinaryData.fromJson(
                json['icon'] as Map<String, dynamic>,
              ),
        unique: json['unique'] as bool? ?? false,
        category: const CreatureCategoryJsonConverter().fromJson(
          json['category'] as String,
        ),
        biome: json['biome'] as String,
        realSize: json['real_size'] as String,
        weight: json['weight'] as String,
        naturalArmor: (json['natural_armor'] as num).toInt(),
        naturalArmorDescription:
            json['natural_armor_description'] as String? ?? '',
        naturalWeapons: (json['natural_weapons'] as List<dynamic>?)
            ?.map((e) => NaturalWeaponModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        specialCapability: json['special_capability'] as String? ?? '',
      )
      ..status = json['status'] == null
          ? EntityStatus.empty()
          : EntityStatus.fromJson(json['status'] as Map<String, dynamic>)
      ..skills = (json['skills'] as List<dynamic>)
          .map((e) => SkillInstance.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CreatureToJson(Creature instance) => <String, dynamic>{
  'equiped': equipedToJson(instance.equiped),
  'uuid': ?instance.uuid,
  'name': instance.name,
  'description': instance.description,
  'image': instance.image?.toJson(),
  'icon': instance.icon?.toJson(),
  'status': instance.status.toJson(),
  'size': instance.size,
  'initiative': instance.initiative,
  'abilities': enumKeyedMapToJson(instance.abilities),
  'attributes': enumKeyedMapToJson(instance.attributes),
  'skills': instance.skills.map((e) => e.toJson()).toList(),
  'equipment': equipmentToJson(instance.equipment),
  'unique': instance.unique,
  'category': const CreatureCategoryJsonConverter().toJson(instance.category),
  'source': instance.source.toJson(),
  'biome': instance.biome,
  'real_size': instance.realSize,
  'weight': instance.weight,
  'natural_armor': instance.naturalArmor,
  'natural_armor_description': instance.naturalArmorDescription,
  'natural_weapons': instance.naturalWeapons.map((e) => e.toJson()).toList(),
  'special_capability': instance.specialCapability,
};
