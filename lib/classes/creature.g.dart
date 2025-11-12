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
      special: json['special'] as String?,
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
      'special': instance.special,
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

CreatureSpecialCapability _$CreatureSpecialCapabilityFromJson(
  Map<String, dynamic> json,
) => CreatureSpecialCapability(
  name: json['name'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$CreatureSpecialCapabilityToJson(
  CreatureSpecialCapability instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
};

CreatureSummary _$CreatureSummaryFromJson(Map<String, dynamic> json) =>
    CreatureSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
      location: json['location'] == null
          ? ObjectLocation.memory
          : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
      category: const CreatureCategoryJsonConverter().fromJson(
        json['category'] as String,
      ),
      icon: json['icon'] == null
          ? null
          : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatureSummaryToJson(
  CreatureSummary instance,
) => <String, dynamic>{
  'source': instance.source.toJson(),
  'name': instance.name,
  'id': instance.id,
  'category': const CreatureCategoryJsonConverter().toJson(instance.category),
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
        specialCapabilities: (json['special_capabilities'] as List<dynamic>?)
            ?.map(
              (e) =>
                  CreatureSpecialCapability.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        status: json['status'] == null
            ? null
            : EntityStatus.fromJson(json['status'] as Map<String, dynamic>),
        equipment: EntityEquipment.fromJson(json['equipment'] as List),
        magic: json['magic'] == null
            ? null
            : EntityMagic.fromJson(json['magic'] as Map<String, dynamic>),
        favors: EntityDraconicFavors.fromJson(
          EntityDraconicFavors.readFavorsFromJson(json, 'favors') as List,
        ),
      )
      ..abilities = EntityAbilities.fromJson(
        json['abilities'] as Map<String, dynamic>,
      )
      ..attributes = EntityAttributes.fromJson(
        json['attributes'] as Map<String, dynamic>,
      )
      ..injuries = EntityInjuries.fromJson(
        json['injuries'] as Map<String, dynamic>,
      )
      ..skills = EntitySkills.fromJson(json['skills'] as Map<String, dynamic>);

Map<String, dynamic> _$CreatureToJson(Creature instance) => <String, dynamic>{
  'source': instance.source.toJson(),
  'name': instance.name,
  'uuid': ?instance.uuid,
  'description': instance.description,
  'image': instance.image?.toJson(),
  'icon': instance.icon?.toJson(),
  'abilities': instance.abilities.toJson(),
  'attributes': instance.attributes.toJson(),
  'initiative': instance.initiative,
  'injuries': instance.injuries.toJson(),
  'size': instance.size,
  'skills': instance.skills.toJson(),
  'status': instance.status.toJson(),
  'equipment': EntityEquipment.toJson(instance.equipment),
  'magic': instance.magic.toJson(),
  'favors': EntityDraconicFavors.toJson(instance.favors),
  'unique': instance.unique,
  'category': const CreatureCategoryJsonConverter().toJson(instance.category),
  'biome': instance.biome,
  'real_size': instance.realSize,
  'weight': instance.weight,
  'natural_armor': instance.naturalArmor,
  'natural_armor_description': instance.naturalArmorDescription,
  'natural_weapons': instance.naturalWeapons.map((e) => e.toJson()).toList(),
  'special_capabilities': instance.specialCapabilities
      .map((e) => e.toJson())
      .toList(),
};
