// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      parent: json['parent'] == null
          ? null
          : Place.fromJson(json['parent'] as Map<String, dynamic>),
      type: $enumDecode(_$PlaceTypeEnumMap, json['type']),
      name: json['name'] as String,
      isDefault: json['is_default'] as bool? ?? false,
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'parent': instance.parent?.toJson(),
      'type': _$PlaceTypeEnumMap[instance.type]!,
      'name': instance.name,
      'is_default': instance.isDefault,
    };

const _$PlaceTypeEnumMap = {
  PlaceType.monde: 'monde',
  PlaceType.continent: 'continent',
  PlaceType.nation: 'nation',
  PlaceType.archiduche: 'archiduche',
  PlaceType.principaute: 'principaute',
  PlaceType.duche: 'duche',
  PlaceType.marche: 'marche',
  PlaceType.comte: 'comte',
  PlaceType.baronnie: 'baronnie',
  PlaceType.citeLibre: 'citeLibre',
  PlaceType.capitale: 'capitale',
  PlaceType.cite: 'cite',
  PlaceType.ville: 'ville',
  PlaceType.village: 'village',
};
