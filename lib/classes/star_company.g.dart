// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'star_company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StarCompany _$StarCompanyFromJson(Map<String, dynamic> json) => StarCompany(
  name: json['name'] as String,
  guide: json['guide'] == null
      ? null
      : CharacterRole.fromJson(json['guide'] as Map<String, dynamic>),
  archiviste: json['archiviste'] == null
      ? null
      : CharacterRole.fromJson(json['archiviste'] as Map<String, dynamic>),
  mainDuDestin: json['main_du_destin'] == null
      ? null
      : CharacterRole.fromJson(json['main_du_destin'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StarCompanyToJson(StarCompany instance) =>
    <String, dynamic>{
      'name': instance.name,
      'guide': instance.guide?.toJson(),
      'archiviste': instance.archiviste?.toJson(),
      'main_du_destin': instance.mainDuDestin?.toJson(),
    };
