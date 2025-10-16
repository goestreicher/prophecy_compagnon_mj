// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityBase _$EntityBaseFromJson(Map<String, dynamic> json) => EntityBase(
  uuid: json['uuid'] as String?,
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
  name: json['name'] as String,
  abilities: json['abilities'] == null
      ? null
      : EntityAbilities.fromJson(json['abilities'] as Map<String, dynamic>),
  attributes: json['attributes'] == null
      ? null
      : EntityAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
  initiative: (json['initiative'] as num?)?.toInt() ?? 1,
  injuries: json['injuries'] == null
      ? null
      : EntityInjuries.fromJson(json['injuries'] as Map<String, dynamic>),
  size: (json['size'] as num?)?.toDouble(),
  description: json['description'] as String?,
  skills: json['skills'] == null
      ? null
      : EntitySkills.fromJson(json['skills'] as Map<String, dynamic>),
  status: json['status'] == null
      ? null
      : EntityStatus.fromJson(json['status'] as Map<String, dynamic>),
  equipment: EntityEquipment.fromJson(json['equipment'] as List),
  magic: json['magic'] == null
      ? null
      : EntityMagic.fromJson(json['magic'] as Map<String, dynamic>),
  image: json['image'] == null
      ? null
      : ExportableBinaryData.fromJson(json['image'] as Map<String, dynamic>),
  icon: json['icon'] == null
      ? null
      : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EntityBaseToJson(EntityBase instance) =>
    <String, dynamic>{
      'uuid': ?instance.uuid,
      'name': instance.name,
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
    };
