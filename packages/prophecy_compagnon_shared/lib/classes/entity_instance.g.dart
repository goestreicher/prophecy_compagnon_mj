// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityInstance _$EntityInstanceFromJson(Map<String, dynamic> json) =>
    EntityInstance(
        uuid: json['uuid'] as String?,
        name: json['name'] as String,
        source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
        location: json['location'] == null
            ? ObjectLocation.memory
            : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
        initiative: (json['initiative'] as num?)?.toInt() ?? 1,
        size: (json['size'] as num?)?.toDouble(),
        healthStatus: json['health_status'] == null
            ? null
            : EntityHealthStatus.fromJson(
                json['health_status'] as Map<String, dynamic>,
              ),
        combatStatus: json['combat_status'] == null
            ? null
            : EntityCombatStatus.fromJson(
                json['combat_status'] as Map<String, dynamic>,
              ),
        modelSpecification: json['model_specification'] as String,
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
      ..description = json['description'] as String
      ..skills = EntitySkills.fromJson(json['skills'] as Map<String, dynamic>)
      ..image = json['image'] == null
          ? null
          : ExportableBinaryData.fromJson(json['image'] as Map<String, dynamic>)
      ..icon = json['icon'] == null
          ? null
          : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>);

Map<String, dynamic> _$EntityInstanceToJson(EntityInstance instance) =>
    <String, dynamic>{
      'source': instance.source.toJson(),
      'name': instance.name,
      'uuid': ?instance.uuid,
      'abilities': instance.abilities.toJson(),
      'attributes': instance.attributes.toJson(),
      'initiative': instance.initiative,
      'injuries': instance.injuries.toJson(),
      'size': instance.size,
      'description': instance.description,
      'skills': instance.skills.toJson(),
      'health_status': instance.healthStatus.toJson(),
      'combat_status': instance.combatStatus.toJson(),
      'model_specification': instance.modelSpecification,
      'image': instance.image?.toJson(),
      'icon': instance.icon?.toJson(),
    };
