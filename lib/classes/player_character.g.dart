// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerCharacterSummary _$PlayerCharacterSummaryFromJson(
  Map<String, dynamic> json,
) => PlayerCharacterSummary(
  id: json['id'] as String,
  name: json['name'] as String,
  player: json['player'] as String,
  caste: CharacterCaste.fromJson(json['caste'] as Map<String, dynamic>),
  icon: json['icon'] == null
      ? null
      : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlayerCharacterSummaryToJson(
  PlayerCharacterSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'player': instance.player,
  'caste': instance.caste.toJson(),
  'icon': instance.icon?.toJson(),
};

PlayerCharacter _$PlayerCharacterFromJson(Map<String, dynamic> json) =>
    PlayerCharacter(
        uuid: json['uuid'] as String?,
        player: json['player'] as String,
        augure: $enumDecode(_$AugureEnumMap, json['augure']),
        name: json['name'] as String,
        source: json['source'] == null
            ? ObjectSource.local
            : ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
        location: json['location'] == null
            ? ObjectLocation.memory
            : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
        abilities: json['abilities'] == null
            ? null
            : EntityAbilities.fromJson(
                json['abilities'] as Map<String, dynamic>,
              ),
        attributes: json['attributes'] == null
            ? null
            : EntityAttributes.fromJson(
                json['attributes'] as Map<String, dynamic>,
              ),
        initiative: (json['initiative'] as num?)?.toInt() ?? 1,
        injuries: json['injuries'] == null
            ? null
            : EntityInjuries.fromJson(json['injuries'] as Map<String, dynamic>),
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
        caste: json['caste'] == null
            ? null
            : CharacterCaste.fromJson(json['caste'] as Map<String, dynamic>),
        age: (json['age'] as num?)?.toInt() ?? 25,
        height: (json['height'] as num?)?.toDouble() ?? 1.7,
        size: (json['size'] as num?)?.toDouble(),
        weight: (json['weight'] as num?)?.toDouble() ?? 60.0,
        luck: (json['luck'] as num?)?.toInt() ?? 0,
        proficiency: (json['proficiency'] as num?)?.toInt() ?? 0,
        renown: (json['renown'] as num?)?.toInt() ?? 0,
        origin: json['origin'] == null
            ? null
            : CharacterOrigin.fromJson(json['origin'] as Map<String, dynamic>),
        disadvantages: CharacterDisadvantages.fromJson(
          json['disadvantages'] as List?,
        ),
        advantages: CharacterAdvantages.fromJson(json['advantages'] as List?),
        tendencies: json['tendencies'] == null
            ? null
            : CharacterTendencies.fromJson(
                json['tendencies'] as Map<String, dynamic>,
              ),
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
      )
      ..draconicLink = DraconicLink.fromJson(
        json['draconic_link'] as Map<String, dynamic>,
      );

Map<String, dynamic> _$PlayerCharacterToJson(PlayerCharacter instance) =>
    <String, dynamic>{
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
      'caste': instance.caste.toJson(),
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'origin': instance.origin.toJson(),
      'luck': instance.luck,
      'proficiency': instance.proficiency,
      'renown': instance.renown,
      'disadvantages': CharacterDisadvantages.toJson(instance.disadvantages),
      'advantages': CharacterAdvantages.toJson(instance.advantages),
      'tendencies': instance.tendencies.toJson(),
      'draconic_link': instance.draconicLink.toJson(),
      'player': instance.player,
      'augure': _$AugureEnumMap[instance.augure]!,
    };

const _$AugureEnumMap = {
  Augure.pierre: 'pierre',
  Augure.fataliste: 'fataliste',
  Augure.chimere: 'chimere',
  Augure.nature: 'nature',
  Augure.ocean: 'ocean',
  Augure.metal: 'metal',
  Augure.volcan: 'volcan',
  Augure.vent: 'vent',
  Augure.homme: 'homme',
  Augure.cite: 'cite',
  Augure.none: 'none',
};
