// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceDescription _$PlaceDescriptionFromJson(Map<String, dynamic> json) =>
    PlaceDescription(
      general: json['general'] as String,
      history: json['history'] as String?,
      ethnology: json['ethnology'] as String?,
      society: json['society'] as String?,
      politics: json['politics'] as String?,
      judicial: json['judicial'] as String?,
      economy: json['economy'] as String?,
      military: json['military'] as String?,
    );

Map<String, dynamic> _$PlaceDescriptionToJson(PlaceDescription instance) =>
    <String, dynamic>{
      'general': instance.general,
      'history': instance.history,
      'ethnology': instance.ethnology,
      'society': instance.society,
      'politics': instance.politics,
      'judicial': instance.judicial,
      'economy': instance.economy,
      'military': instance.military,
    };

PlaceSummary _$PlaceSummaryFromJson(Map<String, dynamic> json) => PlaceSummary(
  uuid: json['uuid'] as String,
  source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
  name: json['name'] as String,
  type: $enumDecode(_$PlaceTypeEnumMap, json['type']),
  parentId: json['parent_id'] as String?,
  canCache: json['can_cache'] as bool? ?? true,
);

Map<String, dynamic> _$PlaceSummaryToJson(PlaceSummary instance) =>
    <String, dynamic>{
      'source': instance.source.toJson(),
      'name': instance.name,
      'uuid': instance.uuid,
      'type': _$PlaceTypeEnumMap[instance.type]!,
      'parent_id': instance.parentId,
      'can_cache': instance.canCache,
    };

const _$PlaceTypeEnumMap = {
  PlaceType.monde: 'monde',
  PlaceType.continent: 'continent',
  PlaceType.nation: 'nation',
  PlaceType.region: 'region',
  PlaceType.lieuUnique: 'lieuUnique',
  PlaceType.citeEtat: 'citeEtat',
  PlaceType.capitale: 'capitale',
  PlaceType.archiduche: 'archiduche',
  PlaceType.principaute: 'principaute',
  PlaceType.duche: 'duche',
  PlaceType.marche: 'marche',
  PlaceType.comte: 'comte',
  PlaceType.baronnie: 'baronnie',
  PlaceType.citeLibre: 'citeLibre',
  PlaceType.cite: 'cite',
  PlaceType.ville: 'ville',
  PlaceType.village: 'village',
  PlaceType.quartier: 'quartier',
  PlaceType.batiment: 'batiment',
};

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
  uuid: json['uuid'] as String?,
  parentId: json['parent_id'] as String?,
  type: $enumDecode(_$PlaceTypeEnumMap, json['type']),
  name: json['name'] as String,
  leaders: (json['leaders'] as List<dynamic>?)
      ?.map((e) => CharacterRole.fromJson(e as Map<String, dynamic>))
      .toList(),
  government: json['government'] as String?,
  motto: json['motto'] as String?,
  climate: json['climate'] as String?,
  description: PlaceDescription.fromJson(
    json['description'] as Map<String, dynamic>,
  ),
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
  source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
  map: json['map'] == null
      ? null
      : PlaceMap.fromJson(json['map'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
  'source': instance.source.toJson(),
  'name': instance.name,
  'uuid': instance.uuid,
  'parent_id': instance.parentId,
  'type': _$PlaceTypeEnumMap[instance.type]!,
  'leaders': instance.leaders.map((e) => e.toJson()).toList(),
  'government': instance.government,
  'motto': instance.motto,
  'climate': instance.climate,
  'description': instance.description.toJson(),
  'map': instance.map?.toJson(),
};
