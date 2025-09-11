// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityStatus _$EntityStatusFromJson(Map<String, dynamic> json) =>
    EntityStatus((json['bitfield'] as num).toInt());

Map<String, dynamic> _$EntityStatusToJson(EntityStatus instance) =>
    <String, dynamic>{'bitfield': instance.bitfield};

EntityBase _$EntityBaseFromJson(Map<String, dynamic> json) =>
    EntityBase(
        uuid: json['uuid'] as String?,
        location: json['location'] == null
            ? ObjectLocation.memory
            : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
        name: json['name'] as String,
        initiative: (json['initiative'] as num?)?.toInt() ?? 1,
        size: (json['size'] as num?)?.toDouble(),
        description: json['description'] as String?,
        skills: (json['skills'] as List<dynamic>?)
            ?.map((e) => SkillInstance.fromJson(e as Map<String, dynamic>))
            .toList(),
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
      )
      ..status = json['status'] == null
          ? EntityStatus.empty()
          : EntityStatus.fromJson(json['status'] as Map<String, dynamic>);

Map<String, dynamic> _$EntityBaseToJson(EntityBase instance) =>
    <String, dynamic>{
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
    };
