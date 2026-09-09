// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterRole _$CharacterRoleFromJson(Map<String, dynamic> json) =>
    CharacterRole(
      name: json['name'] as String?,
      link: json['link'] == null
          ? null
          : ResourceLink.fromJson(json['link'] as Map<String, dynamic>),
      title: json['title'] as String,
    );

Map<String, dynamic> _$CharacterRoleToJson(CharacterRole instance) =>
    <String, dynamic>{
      'name': instance.name,
      'link': instance.link?.toJson(),
      'title': instance.title,
    };
