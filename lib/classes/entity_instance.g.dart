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
      ..status = json['status'] == null
          ? EntityStatus.empty()
          : EntityStatus.fromJson(json['status'] as Map<String, dynamic>)
      ..skills = (json['skills'] as List<dynamic>)
          .map((e) => SkillInstance.fromJson(e as Map<String, dynamic>))
          .toList()
      ..magicSpells =
          (json['magic_spells'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              $enumDecode(_$MagicSphereEnumMap, k),
              (e as List<dynamic>).map((e) => e as String).toList(),
            ),
          ) ??
          {}
      ..extraMagicPool = (json['extra_magic_pool'] as num?)?.toInt() ?? 0
      ..image = json['image'] == null
          ? null
          : ExportableBinaryData.fromJson(json['image'] as Map<String, dynamic>)
      ..icon = json['icon'] == null
          ? null
          : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>);

Map<String, dynamic> _$EntityInstanceToJson(EntityInstance instance) =>
    <String, dynamic>{
      'equiped': equipedToJson(instance.equiped),
      'uuid': ?instance.uuid,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status.toJson(),
      'size': instance.size,
      'initiative': instance.initiative,
      'abilities': enumKeyedMapToJson(instance.abilities),
      'attributes': enumKeyedMapToJson(instance.attributes),
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'equipment': equipmentToJson(instance.equipment),
      'magic_spells': instance.magicSpells.map(
        (k, e) => MapEntry(_$MagicSphereEnumMap[k]!, e),
      ),
      'extra_magic_pool': instance.extraMagicPool,
      'model_specification': instance.modelSpecification,
      'image': instance.image?.toJson(),
      'icon': instance.icon?.toJson(),
    };

const _$MagicSphereEnumMap = {
  MagicSphere.pierre: 'pierre',
  MagicSphere.feu: 'feu',
  MagicSphere.oceans: 'oceans',
  MagicSphere.metal: 'metal',
  MagicSphere.nature: 'nature',
  MagicSphere.reves: 'reves',
  MagicSphere.cite: 'cite',
  MagicSphere.vents: 'vents',
  MagicSphere.ombre: 'ombre',
};
