// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceMap _$PlaceMapFromJson(Map<String, dynamic> json) =>
    PlaceMap(
        sourceType: $enumDecode(
          _$PlaceMapSourceTypeEnumMap,
          json['source_type'],
        ),
        source: json['source'] as String,
        imageWidth: (json['image_width'] as num).toInt(),
        imageHeight: (json['image_height'] as num).toInt(),
        realWidth: (json['real_width'] as num).toDouble(),
        realHeight: (json['real_height'] as num).toDouble(),
      )
      ..exportableBinaryData = json['exportable_binary_data'] == null
          ? null
          : ExportableBinaryData.fromJson(
              json['exportable_binary_data'] as Map<String, dynamic>,
            );

Map<String, dynamic> _$PlaceMapToJson(PlaceMap instance) => <String, dynamic>{
  'source_type': _$PlaceMapSourceTypeEnumMap[instance.sourceType]!,
  'source': instance.source,
  'image_width': instance.imageWidth,
  'image_height': instance.imageHeight,
  'real_width': instance.realWidth,
  'real_height': instance.realHeight,
  'exportable_binary_data': instance.exportableBinaryData?.toJson(),
};

const _$PlaceMapSourceTypeEnumMap = {
  PlaceMapSourceType.asset: 'asset',
  PlaceMapSourceType.local: 'local',
};

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

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
  uuid: json['uuid'] as String?,
  parentId: json['parent_id'] as String?,
  type: $enumDecode(_$PlaceTypeEnumMap, json['type']),
  name: json['name'] as String,
  government: json['government'] as String?,
  leader: json['leader'] as String?,
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
  'uuid': ?instance.uuid,
  'parent_id': instance.parentId,
  'type': _$PlaceTypeEnumMap[instance.type]!,
  'government': instance.government,
  'leader': instance.leader,
  'motto': instance.motto,
  'climate': instance.climate,
  'description': instance.description.toJson(),
  'map': instance.map?.toJson(),
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
