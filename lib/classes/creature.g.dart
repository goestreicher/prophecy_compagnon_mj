// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NaturalWeaponModel _$NaturalWeaponModelFromJson(Map<String, dynamic> json) =>
    NaturalWeaponModel(
      name: json['name'] as String,
      skill: (json['skill'] as num).toInt(),
      damage: (json['damage'] as num).toInt(),
      ranges: (json['ranges'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$WeaponRangeEnumMap, k), (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$NaturalWeaponModelToJson(NaturalWeaponModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'skill': instance.skill,
      'damage': instance.damage,
      'ranges':
          instance.ranges.map((k, e) => MapEntry(_$WeaponRangeEnumMap[k]!, e)),
    };

const _$WeaponRangeEnumMap = {
  WeaponRange.contact: 'contact',
  WeaponRange.melee: 'melee',
  WeaponRange.distance: 'distance',
  WeaponRange.ranged: 'ranged',
};

CreatureModelSummary _$CreatureModelSummaryFromJson(
        Map<String, dynamic> json) =>
    CreatureModelSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      category: const CreatureCategoryJsonConverter()
          .fromJson(json['category'] as String),
      source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
      icon: json['icon'] == null
          ? null
          : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
      isDefault: json['is_default'] as bool,
    );

Map<String, dynamic> _$CreatureModelSummaryToJson(
        CreatureModelSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category':
          const CreatureCategoryJsonConverter().toJson(instance.category),
      'source': instance.source.toJson(),
      'icon': instance.icon?.toJson(),
      'is_default': instance.isDefault,
    };

CreatureModel _$CreatureModelFromJson(Map<String, dynamic> json) =>
    CreatureModel(
      uuid: json['uuid'] as String?,
      name: json['name'] as String,
      unique: json['unique'] as bool? ?? false,
      category: const CreatureCategoryJsonConverter()
          .fromJson(json['category'] as String),
      isDefault: json['is_default'] as bool? ?? false,
      source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
      description: json['description'] as String? ?? '',
      biome: json['biome'] as String,
      size: json['size'] as String,
      weight: json['weight'] as String,
      mapSize: (json['map_size'] as num?)?.toDouble(),
      abilities: (json['abilities'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$AbilityEnumMap, k), (e as num).toInt()),
      ),
      attributes: (json['attributes'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$AttributeEnumMap, k), (e as num).toInt()),
      ),
      initiative: (json['initiative'] as num).toInt(),
      injuries: (json['injuries'] as List<dynamic>)
          .map((e) => InjuryLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
      naturalArmor: (json['natural_armor'] as num).toInt(),
      naturalArmorDescription:
          json['natural_armor_description'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => SkillInstance.fromJson(e as Map<String, dynamic>))
          .toList(),
      naturalWeapons: (json['natural_weapons'] as List<dynamic>?)
          ?.map((e) => NaturalWeaponModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipment: (json['equipment'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specialCapability: json['special_capability'] as String? ?? '',
      image: json['image'] == null
          ? null
          : ExportableBinaryData.fromJson(
              json['image'] as Map<String, dynamic>),
      icon: json['icon'] == null
          ? null
          : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatureModelToJson(CreatureModel instance) =>
    <String, dynamic>{
      if (instance.uuid case final value?) 'uuid': value,
      'is_default': instance.isDefault,
      'name': instance.name,
      'unique': instance.unique,
      'category':
          const CreatureCategoryJsonConverter().toJson(instance.category),
      'source': instance.source.toJson(),
      'description': instance.description,
      'biome': instance.biome,
      'size': instance.size,
      'weight': instance.weight,
      'map_size': instance.mapSize,
      'abilities':
          instance.abilities.map((k, e) => MapEntry(_$AbilityEnumMap[k]!, e)),
      'attributes': instance.attributes
          .map((k, e) => MapEntry(_$AttributeEnumMap[k]!, e)),
      'initiative': instance.initiative,
      'injuries': instance.injuries.map((e) => e.toJson()).toList(),
      'natural_armor': instance.naturalArmor,
      'natural_armor_description': instance.naturalArmorDescription,
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'natural_weapons':
          instance.naturalWeapons.map((e) => e.toJson()).toList(),
      'equipment': instance.equipment,
      'special_capability': instance.specialCapability,
      'image': instance.image?.toJson(),
      'icon': instance.icon?.toJson(),
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

const _$AttributeEnumMap = {
  Attribute.physique: 'physique',
  Attribute.mental: 'mental',
  Attribute.manuel: 'manuel',
  Attribute.social: 'social',
};
