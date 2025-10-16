// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityInstance _$EntityInstanceFromJson(Map<String, dynamic> json) =>
    EntityInstance(
        uuid: json['uuid'] as String?,
        location: json['location'] == null
            ? ObjectLocation.memory
            : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
        name: json['name'] as String,
        initiative: (json['initiative'] as num?)?.toInt() ?? 1,
        size: (json['size'] as num?)?.toDouble(),
        modelSpecification: json['model_specification'] as String,
      )
      ..description = json['description'] as String
      ..abilities = EntityAbilities.fromJson(
        json['abilities'] as Map<String, dynamic>,
      )
      ..attributes = EntityAttributes.fromJson(
        json['attributes'] as Map<String, dynamic>,
      )
      ..injuries = EntityInjuries.fromJson(
        json['injuries'] as Map<String, dynamic>,
      )
      ..skills = EntitySkills.fromJson(json['skills'] as Map<String, dynamic>)
      ..status = EntityStatus.fromJson(json['status'] as Map<String, dynamic>)
      ..image = json['image'] == null
          ? null
          : ExportableBinaryData.fromJson(json['image'] as Map<String, dynamic>)
      ..icon = json['icon'] == null
          ? null
          : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>);

Map<String, dynamic> _$EntityInstanceToJson(EntityInstance instance) =>
    <String, dynamic>{
      'uuid': ?instance.uuid,
      'name': instance.name,
      'description': instance.description,
      'abilities': instance.abilities.toJson(),
      'attributes': instance.attributes.toJson(),
      'initiative': instance.initiative,
      'injuries': instance.injuries.toJson(),
      'size': instance.size,
      'skills': instance.skills.toJson(),
      'status': instance.status.toJson(),
      'model_specification': instance.modelSpecification,
      'image': instance.image?.toJson(),
      'icon': instance.icon?.toJson(),
    };
