// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityBase _$EntityBaseFromJson(Map<String, dynamic> json) => EntityBase.create(
      name: json['name'] as String,
      initiative: (json['initiative'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      description: json['description'] as String?,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => SkillInstance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EntityBaseToJson(EntityBase instance) =>
    <String, dynamic>{
      'equiped': equipedToJson(instance.equiped),
      'name': instance.name,
      'description': instance.description,
      'size': instance.size,
      'weight': instance.weight,
      'initiative': instance.initiative,
      'abilities': enumKeyedMapToJson(instance.abilities),
      'attributes': enumKeyedMapToJson(instance.attributes),
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'equipment': equipmentToJson(instance.equipment),
    };
